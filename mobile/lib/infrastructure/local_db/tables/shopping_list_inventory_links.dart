part of '../app_database.dart';

class ShoppingListInventoryLinks extends Table {
  TextColumn get id => text()();

  TextColumn get shoppingListId =>
      text().references(ShoppingLists, #id, onDelete: KeyAction.cascade)();

  TextColumn get inventoryId =>
      text().references(Inventories, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get syncStatus => text().customConstraint(
        "NOT NULL DEFAULT 'local_only' CHECK (sync_status IN ('local_only', 'pending_sync', 'synced', 'sync_error'))",
      )();

  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
