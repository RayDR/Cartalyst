part of '../app_database.dart';

class InventoryCategories extends Table {
  TextColumn get id => text()();

  TextColumn get inventoryId =>
      text().references(Inventories, #id, onDelete: KeyAction.cascade)();

  TextColumn get categoryId =>
      text().references(Categories, #id, onDelete: KeyAction.cascade)();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
