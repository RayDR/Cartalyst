part of '../app_database.dart';

MigrationStrategy buildMigrationStrategy(AppDatabase db) {
  return MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
      await db.customStatement('''
        CREATE TABLE IF NOT EXISTS shopping_list_drafts (
          shopping_list_id TEXT NOT NULL PRIMARY KEY REFERENCES shopping_lists(id) ON DELETE CASCADE,
          payload TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      await db.seedCommonProductsAndAliases();
      await db.seedDefaultInventory();
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.createTable(db.inventories);
        await migrator.createTable(db.inventoryItems);

        await _addColumnIfMissing(
          db,
          tableName: 'shopping_lists',
          columnName: 'inventory_id',
          sql:
              'ALTER TABLE shopping_lists ADD COLUMN inventory_id TEXT NULL REFERENCES inventories(id)',
        );

        await _addColumnIfMissing(
          db,
          tableName: 'inventory_events',
          columnName: 'inventory_id',
          sql:
              'ALTER TABLE inventory_events ADD COLUMN inventory_id TEXT NULL REFERENCES inventories(id)',
        );

        await _addColumnIfMissing(
          db,
          tableName: 'inventory_events',
          columnName: 'inventory_item_id',
          sql:
              'ALTER TABLE inventory_events ADD COLUMN inventory_item_id TEXT NULL REFERENCES inventory_items(id)',
        );

        final DateTime now = DateTime.now();
        await db.customStatement(
          "INSERT OR IGNORE INTO inventories (id, name, created_at, updated_at, sync_status, version) VALUES (?, 'Pantry', ?, ?, 'local_only', 1)",
          <Object>[
            defaultInventoryId,
            now.toIso8601String(),
            now.toIso8601String(),
          ],
        );

        await db.customStatement(
          '''
          INSERT OR IGNORE INTO inventory_items (
            id,
            inventory_id,
            product_id,
            raw_name,
            quantity_estimated,
            unit,
            status,
            confidence_score,
            last_confirmed_at,
            created_at,
            updated_at,
            deleted_at,
            sync_status,
            version
          )
          SELECT
            id,
            ?,
            product_id,
            raw_name,
            quantity_estimated,
            unit,
            status,
            confidence_score,
            last_confirmed_at,
            created_at,
            updated_at,
            deleted_at,
            sync_status,
            version
          FROM pantry_items
          ''',
          <Object>[defaultInventoryId],
        );

        await db.customStatement(
          '''
          UPDATE inventory_events
          SET inventory_item_id = pantry_item_id
          WHERE inventory_item_id IS NULL AND pantry_item_id IS NOT NULL
          ''',
        );

        await db.customStatement(
          'UPDATE inventory_events SET inventory_id = ? WHERE inventory_id IS NULL',
          <Object>[defaultInventoryId],
        );
      }

      if (from < 3) {
        await db.customStatement('''
          CREATE TABLE IF NOT EXISTS shopping_list_drafts (
            shopping_list_id TEXT NOT NULL PRIMARY KEY REFERENCES shopping_lists(id) ON DELETE CASCADE,
            payload TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      }
    },
  );
}

Future<void> _addColumnIfMissing(
  AppDatabase db, {
  required String tableName,
  required String columnName,
  required String sql,
}) async {
  final List<QueryRow> info =
      await db.customSelect('PRAGMA table_info($tableName)').get();
  final bool exists =
      info.any((QueryRow row) => row.read<String>('name') == columnName);
  if (!exists) {
    await db.customStatement(sql);
  }
}
