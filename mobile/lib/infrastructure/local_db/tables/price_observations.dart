part of '../app_database.dart';

class PriceObservations extends Table {
  TextColumn get id => text()();

  TextColumn get productId => text().nullable().references(Products, #id)();

  TextColumn get storeName => text().nullable().withLength(min: 1, max: 120)();

  RealColumn get packageQuantity => real()();

  TextColumn get packageUnit =>
    text().customConstraint(
      "NOT NULL DEFAULT 'unit' CHECK (package_unit IN ('unit', 'kg', 'g', 'liter', 'ml', 'pack'))",
        )();

  RealColumn get price => real()();

  RealColumn get unitPrice => real()();

  DateTimeColumn get observedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
