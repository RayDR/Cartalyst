part of '../app_database.dart';

class ShoppingListCategories extends Table {
  TextColumn get id => text()();

  TextColumn get shoppingListId =>
      text().references(ShoppingLists, #id, onDelete: KeyAction.cascade)();

  TextColumn get categoryId =>
      text().references(Categories, #id, onDelete: KeyAction.cascade)();

  TextColumn get targetInventoryId =>
      text().nullable().references(Inventories, #id)();

  TextColumn get targetInventoryCategoryId =>
      text().nullable().references(InventoryCategories, #id)();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
