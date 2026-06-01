part of '../app_database.dart';

@DriftAccessor(
  tables: <Type>[
    Categories,
    ShoppingLists,
    ShoppingListCategories,
    ShoppingListItems,
    InventoryCategories,
    ShoppingListInventoryLinks,
    Inventories,
  ],
)
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

  Future<void> upsertShoppingListCategory(ShoppingListCategoriesCompanion row) {
    return into(shoppingListCategories).insertOnConflictUpdate(row);
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

  Stream<List<TypedResult>> watchCategoriesForList(String shoppingListId) {
    final query = select(shoppingListCategories).join([
      innerJoin(
        categories,
        categories.id.equalsExp(shoppingListCategories.categoryId) &
            categories.deletedAt.isNull(),
      ),
    ])
      ..where(
        shoppingListCategories.shoppingListId.equals(shoppingListId) &
            shoppingListCategories.deletedAt.isNull(),
      )
      ..orderBy(<OrderingTerm>[
        OrderingTerm.asc(shoppingListCategories.sortOrder),
        OrderingTerm.asc(categories.name),
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

  Future<void> linkListToInventory({
    required String id,
    required String shoppingListId,
    required String inventoryId,
    required DateTime createdAt,
    required String syncStatus,
    required int version,
  }) {
    return into(shoppingListInventoryLinks).insertOnConflictUpdate(
      ShoppingListInventoryLinksCompanion.insert(
        id: id,
        shoppingListId: shoppingListId,
        inventoryId: inventoryId,
        createdAt: Value(createdAt),
        deletedAt: const Value(null),
        syncStatus: Value(syncStatus),
        version: Value(version),
      ),
    );
  }

  Future<void> unlinkListFromInventory({
    required String shoppingListId,
    required String inventoryId,
  }) {
    final DateTime now = DateTime.now();
    return customStatement(
      '''
      UPDATE shopping_list_inventory_links
      SET deleted_at = ?,
          sync_status = 'pending_sync',
          version = version + 1
      WHERE shopping_list_id = ?
        AND inventory_id = ?
        AND deleted_at IS NULL
      ''',
      <Object>[dbDateTimeValue(now), shoppingListId, inventoryId],
    );
  }

  Stream<List<Inventory>> watchInventoriesForList(String shoppingListId) {
    final query = select(inventories).join([
      innerJoin(
        shoppingListInventoryLinks,
        shoppingListInventoryLinks.inventoryId.equalsExp(inventories.id) &
            shoppingListInventoryLinks.shoppingListId.equals(shoppingListId) &
            shoppingListInventoryLinks.deletedAt.isNull(),
      ),
    ])
      ..where(inventories.deletedAt.isNull())
      ..orderBy(<OrderingTerm>[
        OrderingTerm.asc(inventories.name),
      ]);

    return query.watch().map(
          (List<TypedResult> rows) => rows
              .map((TypedResult row) => row.readTable(inventories))
              .toList(growable: false),
        );
  }

  Stream<List<ShoppingList>> watchListsForInventory(String inventoryId) {
    final query = select(shoppingLists).join([
      innerJoin(
        shoppingListInventoryLinks,
        shoppingListInventoryLinks.shoppingListId.equalsExp(shoppingLists.id) &
            shoppingListInventoryLinks.inventoryId.equals(inventoryId) &
            shoppingListInventoryLinks.deletedAt.isNull(),
      ),
    ])
      ..where(shoppingLists.deletedAt.isNull())
      ..orderBy(<OrderingTerm>[
        OrderingTerm.desc(shoppingLists.updatedAt),
      ]);

    return query.watch().map(
          (List<TypedResult> rows) => rows
              .map((TypedResult row) => row.readTable(shoppingLists))
              .toList(growable: false),
        );
  }
}
