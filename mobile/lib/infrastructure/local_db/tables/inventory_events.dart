part of '../app_database.dart';

class InventoryEvents extends Table {
  TextColumn get id => text()();

  TextColumn get productId => text().nullable().references(Products, #id)();

  TextColumn get pantryItemId => text().nullable().references(PantryItems, #id)();

  TextColumn get eventType =>
    text().customConstraint(
      "NOT NULL DEFAULT 'adjust' CHECK (event_type IN ('add', 'purchase', 'consume', 'adjust', 'confirm', 'finish', 'discard'))",
        )();

  RealColumn get quantity => real().nullable()();

  TextColumn get unit => text().nullable().withLength(min: 1, max: 32)();

  TextColumn get source =>
    text().customConstraint(
      "NOT NULL DEFAULT 'manual' CHECK (source IN ('manual', 'receipt', 'system'))",
        )();

  DateTimeColumn get occurredAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
