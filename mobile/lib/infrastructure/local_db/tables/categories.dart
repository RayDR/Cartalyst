part of '../app_database.dart';

class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 120)();

  TextColumn get color => text().nullable().withLength(min: 1, max: 32)();

  TextColumn get icon => text().nullable().withLength(min: 1, max: 64)();

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
