part of '../app_database.dart';

class ShoppingListItems extends Table {
  TextColumn get id => text()();

  TextColumn get shoppingListId => text().references(ShoppingLists, #id)();

  TextColumn get productId => text().nullable().references(Products, #id)();

  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  TextColumn get targetInventoryId =>
      text().nullable().references(Inventories, #id)();

  TextColumn get targetInventoryCategoryId =>
      text().nullable().references(InventoryCategories, #id)();

  TextColumn get rawText => text().withLength(min: 1, max: 160)();

  RealColumn get quantity => real().nullable()();

  TextColumn get unit => text().nullable().withLength(min: 1, max: 32)();

  TextColumn get status => text().customConstraint(
        "NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'purchased', 'skipped'))",
      )();

  TextColumn get source => text().customConstraint(
        "NOT NULL DEFAULT 'manual' CHECK (source IN ('manual', 'suggestion', 'import'))",
      )();

  RealColumn get priorityScore => real().withDefault(const Constant(0.0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get purchasedAt => dateTime().nullable()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get syncStatus => text().customConstraint(
        "NOT NULL DEFAULT 'local_only' CHECK (sync_status IN ('local_only', 'pending_sync', 'synced', 'sync_error'))",
      )();

  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
