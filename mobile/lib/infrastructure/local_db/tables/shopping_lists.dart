part of '../app_database.dart';

class ShoppingLists extends Table {
  TextColumn get id => text()();

  @Deprecated('Legacy one-to-many relation. Use shopping_list_inventory_links.')
  TextColumn get inventoryId =>
      text().nullable().references(Inventories, #id)();

  TextColumn get name => text().withLength(min: 1, max: 120)();

  TextColumn get listType => text().customConstraint(
        "NOT NULL DEFAULT 'simple' CHECK (list_type IN ('simple', 'organized'))",
      )();

  TextColumn get routingMode => text().customConstraint(
        "NOT NULL DEFAULT 'none' CHECK (routing_mode IN ('none', 'inventory_categories', 'category_as_inventory'))",
      )();

  TextColumn get status => text().customConstraint(
        "NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'archived'))",
      )();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get syncStatus => text().customConstraint(
        "NOT NULL DEFAULT 'local_only' CHECK (sync_status IN ('local_only', 'pending_sync', 'synced', 'sync_error'))",
      )();

  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
