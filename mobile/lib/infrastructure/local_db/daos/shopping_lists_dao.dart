part of '../app_database.dart';

@DriftAccessor(tables: <Type>[ShoppingLists, ShoppingListItems])
class ShoppingListsDao extends DatabaseAccessor<AppDatabase>
    with _$ShoppingListsDaoMixin {
  ShoppingListsDao(super.db);

  Stream<List<ShoppingList>> watchActiveLists() {
    final query = select(shoppingLists)
      ..where((tbl) => tbl.deletedAt.isNull() & tbl.status.equals('active'))
      ..orderBy(<OrderingTerm Function($ShoppingListsTable)>[
        (tbl) => OrderingTerm.desc(tbl.updatedAt),
      ]);
    return query.watch();
  }

  Future<void> upsertShoppingList(ShoppingListsCompanion list) {
    return into(shoppingLists).insertOnConflictUpdate(list);
  }

  Future<void> upsertListItem(ShoppingListItemsCompanion item) {
    return into(shoppingListItems).insertOnConflictUpdate(item);
  }

  Stream<List<ShoppingList>> watchAllLists() {
    return (select(shoppingLists)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy(<OrderingTerm Function($ShoppingListsTable)>[
            (tbl) => OrderingTerm.desc(tbl.updatedAt),
          ]))
        .watch();
  }

  Future<void> softDeleteShoppingList(String id) async {
    final DateTime now = DateTime.now();
    await (update(shoppingLists)..where((tbl) => tbl.id.equals(id))).write(
      ShoppingListsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId) {
    final query = select(shoppingListItems)
      ..where(
        (tbl) =>
            tbl.shoppingListId.equals(shoppingListId) & tbl.deletedAt.isNull(),
      )
      ..orderBy(<OrderingTerm Function($ShoppingListItemsTable)>[
        (tbl) => OrderingTerm.desc(tbl.priorityScore),
        (tbl) => OrderingTerm.asc(tbl.createdAt),
      ]);
    return query.watch();
  }

  Future<String?> readDraftPayload(String shoppingListId) async {
    final List<QueryRow> rows = await customSelect(
      'SELECT payload FROM shopping_list_drafts WHERE shopping_list_id = ?',
      variables: <Variable<Object>>[
        Variable<String>(shoppingListId),
      ],
    ).get();

    if (rows.isEmpty) {
      return null;
    }

    return rows.first.read<String>('payload');
  }

  Future<void> upsertDraftPayload({
    required String shoppingListId,
    required String payload,
    required DateTime updatedAt,
  }) {
    return customStatement(
      '''
      INSERT INTO shopping_list_drafts (shopping_list_id, payload, updated_at)
      VALUES (?, ?, ?)
      ON CONFLICT(shopping_list_id)
      DO UPDATE SET payload = excluded.payload, updated_at = excluded.updated_at
      ''',
      <Object>[shoppingListId, payload, updatedAt.toIso8601String()],
    );
  }

  Future<void> deleteDraft(String shoppingListId) {
    return customStatement(
      'DELETE FROM shopping_list_drafts WHERE shopping_list_id = ?',
      <Object>[shoppingListId],
    );
  }
}
