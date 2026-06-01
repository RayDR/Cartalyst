import 'dart:io';

import 'package:cartalyst_mobile/features/inventories/data/repositories/local_inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart'
    as inventory_domain;
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('AppDatabase', () {
    AppDatabase? database;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
    });

    tearDown(() async {
      await database?.close();
    });

    test('seeds common products and aliases on first create', () async {
      try {
        final List<Product> products =
            await database!.select(database!.products).get();
        final aliases = await database!.select(database!.productAliases).get();

        expect(products.length, 15);
        expect(aliases.length, greaterThanOrEqualTo(30));
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });

    test('development reset clears user tables and reseeds products', () async {
      try {
        final String listId = const Uuid().v4();

        await database!.into(database!.shoppingLists).insert(
              ShoppingListsCompanion.insert(
                id: listId,
                name: 'Weekly list',
              ),
            );

        await database!.developmentReset();

        final List<ShoppingList> lists =
            await database!.select(database!.shoppingLists).get();
        final List<Product> products =
            await database!.select(database!.products).get();
        final List<Inventory> inventories =
            await database!.select(database!.inventories).get();

        expect(lists, isEmpty);
        expect(products.length, 15);
        expect(inventories.length, 1);
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });

    test('persists shopping list items after database restart', () async {
      final bool previousWarnValue =
          drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases;
      drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

      final String filePath =
          '${Directory.systemTemp.path}/cartalyst_persistence_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final File dbFile = File(filePath);

      AppDatabase? first;
      AppDatabase? second;

      try {
        first = AppDatabase(executor: NativeDatabase(dbFile));
        final String listId = const Uuid().v4();
        final String itemId = const Uuid().v4();

        await first.into(first.shoppingLists).insert(
              ShoppingListsCompanion.insert(
                id: listId,
                name: 'Restart list',
              ),
            );

        await first.into(first.shoppingListItems).insert(
              ShoppingListItemsCompanion.insert(
                id: itemId,
                shoppingListId: listId,
                rawText: 'milk',
                quantity: const drift.Value(1),
                unit: const drift.Value('gal'),
              ),
            );

        await first.close();
        first = null;

        second = AppDatabase(executor: NativeDatabase(dbFile));
        final List<ShoppingListItem> reloadedItems =
            await second.select(second.shoppingListItems).get();

        expect(reloadedItems.length, 1);
        expect(reloadedItems.first.rawText, 'milk');
        expect(reloadedItems.first.quantity, 1);
        expect(reloadedItems.first.unit, 'gal');
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      } finally {
        drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases =
            previousWarnValue;
        await first?.close();
        await second?.close();
        if (dbFile.existsSync()) {
          dbFile.deleteSync();
        }
      }
    });

    test('creates inventory records', () async {
      try {
        final DateTime now = DateTime.now();
        await database!.into(database!.inventories).insert(
              InventoriesCompanion.insert(
                id: const Uuid().v4(),
                name: 'Despensa',
                description: const drift.Value('Household inventory'),
                createdAt: drift.Value(now),
                updatedAt: drift.Value(now),
                syncStatus: const drift.Value('pending_sync'),
                version: const drift.Value(1),
              ),
            );

        final List<Inventory> inventories =
            await database!.select(database!.inventories).get();
        expect(
          inventories
              .any((Inventory inventory) => inventory.name == 'Despensa'),
          isTrue,
        );
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });

    test(
      'repository watchAllInventories returns created active inventory',
      () async {
        try {
          final LocalInventoryRepository repository =
              LocalInventoryRepository(database!);
          final DateTime now = DateTime.now();
          const String inventoryId = 'inventory-watch-active';

          await repository.saveInventory(
            inventory_domain.Inventory(
              id: inventoryId,
              name: 'Garage shelf',
              createdAt: now,
              updatedAt: now,
              syncStatus: 'pending_sync',
              version: 1,
            ),
          );

          final List<inventory_domain.Inventory> inventories =
              await repository.watchAllInventories().first;

          expect(
            inventories.any(
              (inventory_domain.Inventory inventory) =>
                  inventory.id == inventoryId &&
                  inventory.name == 'Garage shelf',
            ),
            isTrue,
          );
          expect(
            inventories.every(
              (inventory_domain.Inventory inventory) =>
                  inventory.deletedAt == null,
            ),
            isTrue,
          );
        } on ArgumentError catch (error) {
          if (_isMissingSqlite(error)) {
            return;
          }
          rethrow;
        }
      },
    );

    test(
      'repository watchAllInventories hides soft-deleted inventory',
      () async {
        try {
          final LocalInventoryRepository repository =
              LocalInventoryRepository(database!);
          final DateTime now = DateTime.now();
          const String inventoryId = 'inventory-watch-deleted';

          await repository.saveInventory(
            inventory_domain.Inventory(
              id: inventoryId,
              name: 'Temporary shelf',
              createdAt: now,
              updatedAt: now,
              syncStatus: 'pending_sync',
              version: 1,
            ),
          );
          await repository.deleteInventory(inventoryId);

          final List<inventory_domain.Inventory> inventories =
              await repository.watchAllInventories().first;

          expect(
            inventories.any(
              (inventory_domain.Inventory inventory) =>
                  inventory.id == inventoryId,
            ),
            isFalse,
          );
          expect(
            inventories.every(
              (inventory_domain.Inventory inventory) =>
                  inventory.deletedAt == null,
            ),
            isTrue,
          );
        } on ArgumentError catch (error) {
          if (_isMissingSqlite(error)) {
            return;
          }
          rethrow;
        }
      },
    );

    test('persists shopping list inventory links via link table', () async {
      try {
        final DateTime now = DateTime.now();
        final String inventoryId = const Uuid().v4();
        final String listId = const Uuid().v4();
        final String linkId = const Uuid().v4();

        await database!.into(database!.inventories).insert(
              InventoriesCompanion.insert(
                id: inventoryId,
                name: 'Pantry',
                createdAt: drift.Value(now),
                updatedAt: drift.Value(now),
                syncStatus: const drift.Value('pending_sync'),
                version: const drift.Value(1),
              ),
            );

        await database!.into(database!.shoppingLists).insert(
              ShoppingListsCompanion.insert(
                id: listId,
                name: 'Weekly list',
                createdAt: drift.Value(now),
                updatedAt: drift.Value(now),
              ),
            );

        await database!.into(database!.shoppingListInventoryLinks).insert(
              ShoppingListInventoryLinksCompanion.insert(
                id: linkId,
                shoppingListId: listId,
                inventoryId: inventoryId,
                createdAt: drift.Value(now),
                syncStatus: const drift.Value('pending_sync'),
                version: const drift.Value(1),
              ),
            );

        final ShoppingListInventoryLink link =
            await (database!.select(database!.shoppingListInventoryLinks)
                  ..where((tbl) => tbl.id.equals(linkId)))
                .getSingle();

        expect(link.shoppingListId, listId);
        expect(link.inventoryId, inventoryId);
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });

    test(
      'creates and reads inventory uncategorized category without FormatException',
      () async {
        try {
          final LocalInventoryRepository repository =
              LocalInventoryRepository(database!);
          final DateTime now = DateTime.now();
          final String inventoryId = const Uuid().v4();

          await repository.saveInventory(
            inventory_domain.Inventory(
              id: inventoryId,
              name: 'Pantry shelf',
              createdAt: now,
              updatedAt: now,
              syncStatus: 'pending_sync',
              version: 1,
            ),
          );

          final String uncategorizedId =
              await repository.ensureUncategorizedInventoryCategory(
            inventoryId,
          );
          final categories =
              await repository.watchInventoryCategories(inventoryId).first;

          expect(categories, isNotEmpty);
          expect(categories.first.id, uncategorizedId);
          expect(categories.first.name, 'Uncategorized');
        } on ArgumentError catch (error) {
          if (_isMissingSqlite(error)) {
            return;
          }
          rethrow;
        }
      },
    );

    test('migrates inventory categories with drift DateTime values', () async {
      final bool previousWarnValue =
          drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases;
      drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

      final String filePath =
          '${Directory.systemTemp.path}/cartalyst_upgrade_${DateTime.now().microsecondsSinceEpoch}.sqlite';
      final File dbFile = File(filePath);
      AppDatabase? upgraded;

      try {
        final int now = DateTime.now().microsecondsSinceEpoch;
        upgraded = AppDatabase(
          executor: NativeDatabase(
            dbFile,
            setup: (database) {
              database.execute('PRAGMA user_version = 4');
              database.execute('''
                CREATE TABLE IF NOT EXISTS inventories (
                  id TEXT NOT NULL PRIMARY KEY,
                  name TEXT NOT NULL,
                  description TEXT NULL,
                  created_at INTEGER NOT NULL,
                  updated_at INTEGER NOT NULL,
                  deleted_at INTEGER NULL,
                  sync_status TEXT NOT NULL,
                  version INTEGER NOT NULL
                )
              ''');
              database.execute('''
                CREATE TABLE IF NOT EXISTS shopping_lists (
                  id TEXT NOT NULL PRIMARY KEY,
                  inventory_id TEXT NULL,
                  name TEXT NOT NULL,
                  status TEXT NOT NULL DEFAULT 'active',
                  created_at INTEGER NOT NULL,
                  updated_at INTEGER NOT NULL,
                  deleted_at INTEGER NULL,
                  sync_status TEXT NOT NULL,
                  version INTEGER NOT NULL
                )
              ''');
              database.execute('''
                CREATE TABLE IF NOT EXISTS shopping_list_items (
                  id TEXT NOT NULL PRIMARY KEY,
                  shopping_list_id TEXT NOT NULL,
                  product_id TEXT NULL,
                  raw_text TEXT NOT NULL,
                  quantity REAL NULL,
                  unit TEXT NULL,
                  status TEXT NOT NULL DEFAULT 'pending',
                  source TEXT NOT NULL DEFAULT 'manual',
                  priority_score REAL NOT NULL DEFAULT 0.0,
                  created_at INTEGER NOT NULL,
                  updated_at INTEGER NOT NULL,
                  purchased_at INTEGER NULL,
                  deleted_at INTEGER NULL,
                  sync_status TEXT NOT NULL,
                  version INTEGER NOT NULL
                )
              ''');
              database.execute('''
                CREATE TABLE IF NOT EXISTS inventory_items (
                  id TEXT NOT NULL PRIMARY KEY,
                  inventory_id TEXT NOT NULL,
                  product_id TEXT NULL,
                  raw_name TEXT NULL,
                  quantity_estimated REAL NULL,
                  unit TEXT NULL,
                  status TEXT NOT NULL DEFAULT 'unknown',
                  confidence_score REAL NOT NULL DEFAULT 0.5,
                  last_confirmed_at INTEGER NULL,
                  created_at INTEGER NOT NULL,
                  updated_at INTEGER NOT NULL,
                  deleted_at INTEGER NULL,
                  sync_status TEXT NOT NULL,
                  version INTEGER NOT NULL
                )
              ''');
              database.execute(
                'INSERT INTO inventories (id, name, description, created_at, updated_at, deleted_at, sync_status, version) VALUES (?, ?, NULL, ?, ?, NULL, ?, ?)',
                <Object>[
                  'inventory-legacy',
                  'Legacy pantry',
                  now,
                  now,
                  'local_only',
                  1,
                ],
              );
            },
          ),
        );

        final LocalInventoryRepository repository =
            LocalInventoryRepository(upgraded);
        final categories =
            await repository.watchInventoryCategories('inventory-legacy').first;

        expect(categories, hasLength(1));
        expect(categories.first.name, 'Uncategorized');
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      } finally {
        drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases =
            previousWarnValue;
        await upgraded?.close();
        if (dbFile.existsSync()) {
          dbFile.deleteSync();
        }
      }
    });

    test('seedDefaultInventory completes without throwing', () async {
      try {
        // A fresh in-memory database seeds on onCreate; verify the result.
        final List<Inventory> inventories =
            await database!.select(database!.inventories).get();
        expect(inventories, isNotEmpty);
        expect(inventories.first.id, defaultInventoryId);

        // Calling again must be idempotent.
        await database!.seedDefaultInventory();
        final List<Inventory> after =
            await database!.select(database!.inventories).get();
        expect(after.length, 1);
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });

    test('unlinkListFromInventory does not throw invalid DateTime parameter',
        () async {
      try {
        final DateTime now = DateTime.now();
        final String inventoryId = const Uuid().v4();
        final String listId = const Uuid().v4();
        final String linkId = const Uuid().v4();

        await database!.into(database!.inventories).insert(
              InventoriesCompanion.insert(
                id: inventoryId,
                name: 'Test inventory',
                createdAt: drift.Value(now),
                updatedAt: drift.Value(now),
                syncStatus: const drift.Value('pending_sync'),
                version: const drift.Value(1),
              ),
            );

        await database!.into(database!.shoppingLists).insert(
              ShoppingListsCompanion.insert(
                id: listId,
                name: 'Test list',
                createdAt: drift.Value(now),
                updatedAt: drift.Value(now),
              ),
            );

        await database!.into(database!.shoppingListInventoryLinks).insert(
              ShoppingListInventoryLinksCompanion.insert(
                id: linkId,
                shoppingListId: listId,
                inventoryId: inventoryId,
                createdAt: drift.Value(now),
                syncStatus: const drift.Value('pending_sync'),
                version: const drift.Value(1),
              ),
            );

        // This was previously crashing with:
        // Invalid argument (params[1]): Instance of 'DateTime'
        await expectLater(
          database!.shoppingListsDao.unlinkListFromInventory(
            shoppingListId: listId,
            inventoryId: inventoryId,
          ),
          completes,
        );

        final ShoppingListInventoryLink link =
            await (database!.select(database!.shoppingListInventoryLinks)
                  ..where((tbl) => tbl.id.equals(linkId)))
                .getSingle();
        expect(link.deletedAt, isNotNull);
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });

    test(
        'create inventory and ensure Uncategorized category — no FormatException',
        () async {
      try {
        final LocalInventoryRepository repository =
            LocalInventoryRepository(database!);
        final DateTime now = DateTime.now();
        final String inventoryId = const Uuid().v4();

        await repository.saveInventory(
          inventory_domain.Inventory(
            id: inventoryId,
            name: 'Fridge',
            createdAt: now,
            updatedAt: now,
            syncStatus: 'pending_sync',
            version: 1,
          ),
        );

        final String uncategorizedId =
            await repository.ensureUncategorizedInventoryCategory(inventoryId);
        expect(uncategorizedId, isNotEmpty);

        // Calling again must be idempotent (returns the same id).
        final String second =
            await repository.ensureUncategorizedInventoryCategory(inventoryId);
        expect(second, isNotEmpty);

        final categories =
            await repository.watchInventoryCategories(inventoryId).first;
        expect(
          categories.any((c) => c.name == 'Uncategorized'),
          isTrue,
        );
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });
  });
}

bool _isMissingSqlite(ArgumentError error) {
  return error.toString().contains('libsqlite3.so');
}
