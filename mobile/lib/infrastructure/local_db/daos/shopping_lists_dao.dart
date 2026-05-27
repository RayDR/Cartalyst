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

  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId) {
    final query = select(shoppingListItems)
      ..where((tbl) => tbl.shoppingListId.equals(shoppingListId) & tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($ShoppingListItemsTable)>[
        (tbl) => OrderingTerm.desc(tbl.priorityScore),
        (tbl) => OrderingTerm.asc(tbl.createdAt),
      ]);
    return query.watch();
  }
}
