part of '../app_database.dart';

class PantryItems extends Table {
  TextColumn get id => text()();

  TextColumn get productId => text().nullable().references(Products, #id)();

  TextColumn get rawName => text().nullable().withLength(min: 1, max: 120)();

  RealColumn get quantityEstimated => real().nullable()();

  TextColumn get unit => text().nullable().withLength(min: 1, max: 32)();

  TextColumn get status =>
    text().customConstraint(
      "NOT NULL DEFAULT 'unknown' CHECK (status IN ('unknown', 'in_stock', 'low', 'out'))",
        )();

  RealColumn get confidenceScore => real().withDefault(const Constant(0.5))();

  DateTimeColumn get lastConfirmedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get syncStatus =>
    text().customConstraint(
      "NOT NULL DEFAULT 'local_only' CHECK (sync_status IN ('local_only', 'pending_sync', 'synced', 'sync_error'))",
        )();

  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}
