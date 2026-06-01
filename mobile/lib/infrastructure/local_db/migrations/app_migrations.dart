part of '../app_database.dart';

Future<void> _insertInventoryIfMissing(
  AppDatabase db, {
  required String id,
  required String name,
  required DateTime now,
}) {
  return db.into(db.inventories).insert(
        InventoriesCompanion.insert(
          id: id,
          name: name,
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value('local_only'),
          version: const Value(1),
        ),
        mode: InsertMode.insertOrIgnore,
      );
}

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
        await _insertInventoryIfMissing(
          db,
          id: defaultInventoryId,
          name: 'Pantry',
          now: now,
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

      if (from < 4) {
        await db.customStatement('''
          CREATE TABLE IF NOT EXISTS shopping_list_inventory_links (
            id TEXT NOT NULL PRIMARY KEY,
            shopping_list_id TEXT NOT NULL REFERENCES shopping_lists(id) ON DELETE CASCADE,
            inventory_id TEXT NOT NULL REFERENCES inventories(id) ON DELETE CASCADE,
            created_at TEXT NOT NULL,
            deleted_at TEXT NULL,
            sync_status TEXT NOT NULL DEFAULT 'local_only' CHECK (sync_status IN ('local_only', 'pending_sync', 'synced', 'sync_error')),
            version INTEGER NOT NULL DEFAULT 1
          )
        ''');

        await db.customStatement(
          '''
          INSERT OR IGNORE INTO shopping_list_inventory_links (
            id,
            shopping_list_id,
            inventory_id,
            created_at,
            deleted_at,
            sync_status,
            version
          )
          SELECT
            shopping_lists.id || '::' || shopping_lists.inventory_id,
            shopping_lists.id,
            shopping_lists.inventory_id,
            shopping_lists.updated_at,
            NULL,
            'pending_sync',
            1
          FROM shopping_lists
          WHERE shopping_lists.inventory_id IS NOT NULL
          ''',
        );
      }

      if (from < 5) {
        await db.customStatement('''
          CREATE TABLE IF NOT EXISTS categories (
            id TEXT NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            color TEXT NULL,
            icon TEXT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            deleted_at TEXT NULL,
            sync_status TEXT NOT NULL DEFAULT 'local_only' CHECK (sync_status IN ('local_only', 'pending_sync', 'synced', 'sync_error')),
            version INTEGER NOT NULL DEFAULT 1
          )
        ''');

        await db.customStatement('''
          CREATE TABLE IF NOT EXISTS inventory_categories (
            id TEXT NOT NULL PRIMARY KEY,
            inventory_id TEXT NOT NULL REFERENCES inventories(id) ON DELETE CASCADE,
            category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
            sort_order INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            deleted_at TEXT NULL
          )
        ''');

        await db.customStatement('''
          CREATE TABLE IF NOT EXISTS shopping_list_categories (
            id TEXT NOT NULL PRIMARY KEY,
            shopping_list_id TEXT NOT NULL REFERENCES shopping_lists(id) ON DELETE CASCADE,
            category_id TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
            target_inventory_id TEXT NULL REFERENCES inventories(id),
            target_inventory_category_id TEXT NULL REFERENCES inventory_categories(id),
            sort_order INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            deleted_at TEXT NULL
          )
        ''');

        await _addColumnIfMissing(
          db,
          tableName: 'shopping_lists',
          columnName: 'list_type',
          sql:
              "ALTER TABLE shopping_lists ADD COLUMN list_type TEXT NOT NULL DEFAULT 'simple' CHECK (list_type IN ('simple', 'organized'))",
        );

        await _addColumnIfMissing(
          db,
          tableName: 'shopping_lists',
          columnName: 'routing_mode',
          sql:
              "ALTER TABLE shopping_lists ADD COLUMN routing_mode TEXT NOT NULL DEFAULT 'none' CHECK (routing_mode IN ('none', 'inventory_categories', 'category_as_inventory'))",
        );

        await _addColumnIfMissing(
          db,
          tableName: 'shopping_list_items',
          columnName: 'category_id',
          sql:
              'ALTER TABLE shopping_list_items ADD COLUMN category_id TEXT NULL REFERENCES categories(id)',
        );

        await _addColumnIfMissing(
          db,
          tableName: 'shopping_list_items',
          columnName: 'target_inventory_id',
          sql:
              'ALTER TABLE shopping_list_items ADD COLUMN target_inventory_id TEXT NULL REFERENCES inventories(id)',
        );

        await _addColumnIfMissing(
          db,
          tableName: 'shopping_list_items',
          columnName: 'target_inventory_category_id',
          sql:
              'ALTER TABLE shopping_list_items ADD COLUMN target_inventory_category_id TEXT NULL REFERENCES inventory_categories(id)',
        );

        await _addColumnIfMissing(
          db,
          tableName: 'inventory_items',
          columnName: 'inventory_category_id',
          sql:
              'ALTER TABLE inventory_items ADD COLUMN inventory_category_id TEXT NULL REFERENCES inventory_categories(id)',
        );

        await db.customStatement('''
          INSERT OR IGNORE INTO categories (
            id,
            name,
            color,
            icon,
            created_at,
            updated_at,
            deleted_at,
            sync_status,
            version
          )
          SELECT
            inventories.id || '::uncategorized',
            'Uncategorized',
            NULL,
            NULL,
            inventories.updated_at,
            inventories.updated_at,
            NULL,
            'pending_sync',
            1
          FROM inventories
          ''');

        await db.customStatement('''
          INSERT OR IGNORE INTO inventory_categories (
            id,
            inventory_id,
            category_id,
            sort_order,
            created_at,
            updated_at,
            deleted_at
          )
          SELECT
            inventories.id || '::inventory-uncategorized',
            inventories.id,
            inventories.id || '::uncategorized',
            0,
            inventories.updated_at,
            inventories.updated_at,
            NULL
          FROM inventories
          ''');

        await db.customStatement('''
          UPDATE inventory_items
          SET inventory_category_id = inventory_items.inventory_id || '::inventory-uncategorized'
          WHERE inventory_items.inventory_category_id IS NULL
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
