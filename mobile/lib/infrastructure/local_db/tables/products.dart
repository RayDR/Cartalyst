part of '../app_database.dart';

class Products extends Table {
  TextColumn get id => text()();

  TextColumn get canonicalName => text().withLength(min: 1, max: 120)();

  TextColumn get brand => text().nullable().withLength(min: 1, max: 120)();

  TextColumn get category =>
    text().customConstraint(
      "NOT NULL DEFAULT 'other' CHECK (category IN ('produce', 'dairy', 'protein', 'grains', 'bakery', 'household', 'other'))",
          )();

  TextColumn get defaultUnit =>
    text().customConstraint(
      "NOT NULL DEFAULT 'unit' CHECK (default_unit IN ('unit', 'kg', 'g', 'liter', 'ml', 'pack'))",
          )();

  RealColumn get defaultPackageQuantity => real().nullable()();

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
