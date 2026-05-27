part of '../app_database.dart';

class ProductAliases extends Table {
  TextColumn get id => text()();

  TextColumn get productId => text().references(Products, #id)();

  TextColumn get alias => text().withLength(min: 1, max: 120)();

  TextColumn get languageCode => text().withLength(min: 2, max: 8)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
        <Column<Object>>{productId, alias, languageCode},
      ];

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
