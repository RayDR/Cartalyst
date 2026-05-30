import 'dart:io';

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
            isTrue,);
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });

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
  });
}

bool _isMissingSqlite(ArgumentError error) {
  return error.toString().contains('libsqlite3.so');
}
