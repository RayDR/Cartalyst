part of '../app_database.dart';

MigrationStrategy buildMigrationStrategy(AppDatabase db) {
  return MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
      await db.seedCommonProductsAndAliases();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 1) {
        await migrator.createAll();
      }
    },
  );
}
