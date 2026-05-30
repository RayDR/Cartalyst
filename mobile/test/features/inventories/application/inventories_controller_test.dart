import 'dart:async';

import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeInventoryRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeInventoryRepository();

    container = ProviderContainer(
      overrides: <Override>[
        inventoryRepositoryProvider.overrideWithValue(repository),
      ],
    );

    addTearDown(container.dispose);
    addTearDown(repository.dispose);
  });

  Future<void> waitForInventories(int count) async {
    for (int i = 0; i < 50; i++) {
      final InventoriesState state = container.read(inventoriesControllerProvider);
      if (state.inventories.length == count) return;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail('Expected $count inventories but got '
        '${container.read(inventoriesControllerProvider).inventories.length}');
  }

  group('InventoriesController', () {
    test('createInventory adds inventory and returns id', () async {
      final InventoriesController controller =
          container.read(inventoriesControllerProvider.notifier);

      final String? id = await controller.createInventory('Pantry');
      expect(id, isNotNull);

      await waitForInventories(1);

      final InventoriesState state =
          container.read(inventoriesControllerProvider);
      expect(state.inventories.length, 1);
      expect(state.inventories.first.name, 'Pantry');
      expect(state.inventories.first.id, id);
    });

    test('createInventory with empty name returns null', () async {
      final InventoriesController controller =
          container.read(inventoriesControllerProvider.notifier);

      final String? id = await controller.createInventory('   ');
      expect(id, isNull);
      expect(container.read(inventoriesControllerProvider).inventories, isEmpty);
    });

    test('renameInventory updates name', () async {
      final InventoriesController controller =
          container.read(inventoriesControllerProvider.notifier);

      await controller.createInventory('Old Name');
      await waitForInventories(1);

      final Inventory created =
          container.read(inventoriesControllerProvider).inventories.first;

      await controller.renameInventory(created, 'New Name');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final InventoriesState state =
          container.read(inventoriesControllerProvider);
      expect(state.inventories.first.name, 'New Name');
    });

    test('deleteInventory soft-deletes and stores lastDeletedInventory',
        () async {
      final InventoriesController controller =
          container.read(inventoriesControllerProvider.notifier);

      await controller.createInventory('Almacén');
      await waitForInventories(1);

      final Inventory created =
          container.read(inventoriesControllerProvider).inventories.first;

      await controller.deleteInventory(created);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final InventoriesState state =
          container.read(inventoriesControllerProvider);
      expect(state.inventories, isEmpty);
      expect(state.lastDeletedInventory?.id, created.id);
    });

    test('restoreLastDeleted restores inventory', () async {
      final InventoriesController controller =
          container.read(inventoriesControllerProvider.notifier);

      await controller.createInventory('Despensa');
      await waitForInventories(1);

      final Inventory created =
          container.read(inventoriesControllerProvider).inventories.first;

      await controller.deleteInventory(created);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      await controller.restoreLastDeleted();
      await waitForInventories(1);

      final InventoriesState state =
          container.read(inventoriesControllerProvider);
      expect(state.inventories.length, 1);
      expect(state.inventories.first.name, 'Despensa');
      expect(state.lastDeletedInventory, isNull);
    });

    test('inventories are sorted by updatedAt desc', () async {
      final DateTime t1 = DateTime(2026, 1, 1);
      final DateTime t2 = DateTime(2026, 1, 2);
      final DateTime t3 = DateTime(2026, 1, 3);

      repository.seedInventory(Inventory(
        id: 'inv-a',
        name: 'Alpha',
        createdAt: t1,
        updatedAt: t1,
        syncStatus: 'synced',
        version: 1,
      ));
      repository.seedInventory(Inventory(
        id: 'inv-c',
        name: 'Charlie',
        createdAt: t3,
        updatedAt: t3,
        syncStatus: 'synced',
        version: 1,
      ));
      repository.seedInventory(Inventory(
        id: 'inv-b',
        name: 'Bravo',
        createdAt: t2,
        updatedAt: t2,
        syncStatus: 'synced',
        version: 1,
      ));
      repository.emitInventories();

      // trigger subscription
      container.read(inventoriesControllerProvider);
      await waitForInventories(3);

      final List<Inventory> inventories =
          container.read(inventoriesControllerProvider).inventories;

      expect(inventories[0].id, 'inv-c');
      expect(inventories[1].id, 'inv-b');
      expect(inventories[2].id, 'inv-a');
    });
  });
}

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class FakeInventoryRepository implements InventoryRepository {
  final StreamController<List<Inventory>> _inventoriesController =
      StreamController<List<Inventory>>.broadcast();

  final StreamController<List<InventoryItem>> _itemsController =
      StreamController<List<InventoryItem>>.broadcast();

  final StreamController<List<InventoryEvent>> _eventsController =
      StreamController<List<InventoryEvent>>.broadcast();

  final List<Inventory> _inventories = <Inventory>[];
  final List<InventoryItem> _items = <InventoryItem>[];
  final List<InventoryEvent> _events = <InventoryEvent>[];

  final List<String> deletedInventoryIds = <String>[];
  final List<String> deletedItemIds = <String>[];

  void seedInventory(Inventory inventory) {
    _inventories.add(inventory);
  }

  void emitInventories() {
    _inventoriesController.add(_sortedActiveInventories());
  }

  List<Inventory> _sortedActiveInventories() {
    final List<Inventory> active = _inventories
        .where((Inventory e) => e.deletedAt == null)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List<Inventory>.unmodifiable(active);
  }

  @override
  Stream<List<Inventory>> watchAllInventories() {
    Future<void>.microtask(
      () => _inventoriesController.add(_sortedActiveInventories()),
    );
    return _inventoriesController.stream;
  }

  @override
  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId) {
    final List<InventoryItem> filtered = _items
        .where(
          (InventoryItem item) =>
              item.inventoryId == inventoryId && item.deletedAt == null,
        )
        .toList(growable: false);
    Future<void>.microtask(() => _itemsController.add(filtered));
    return _itemsController.stream;
  }

  @override
  Future<void> saveInventory(Inventory inventory) async {
    final int index =
        _inventories.indexWhere((Inventory e) => e.id == inventory.id);
    if (index >= 0) {
      _inventories[index] = inventory;
    } else {
      _inventories.add(inventory);
    }
    _emitInventories();
  }

  @override
  Future<void> deleteInventory(String id) async {
    deletedInventoryIds.add(id);
    final int index = _inventories.indexWhere((Inventory e) => e.id == id);
    if (index >= 0) {
      _inventories[index] =
          _inventories[index].copyWith(deletedAt: DateTime.now());
    }
    _emitActiveInventories();
  }

  @override
  Future<void> saveInventoryItem(InventoryItem item) async {
    final int index =
        _items.indexWhere((InventoryItem e) => e.id == item.id);
    if (index >= 0) {
      _items[index] = item;
    } else {
      _items.add(item);
    }
    _emitItems();
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    deletedItemIds.add(id);
    final int index = _items.indexWhere((InventoryItem e) => e.id == id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(deletedAt: DateTime.now());
    }
    _emitItems();
  }

  @override
  Future<void> addInventoryEvent(InventoryEvent event) async {
    _events.add(event);
    _eventsController.add(List<InventoryEvent>.unmodifiable(_events));
  }

  void _emitInventories() {
    _inventoriesController
        .add(_sortedActiveInventories());
  }

  void _emitActiveInventories() {
    _inventoriesController.add(_sortedActiveInventories());
  }

  void _emitItems() {
    final List<InventoryItem> active = _items
        .where((InventoryItem item) => item.deletedAt == null)
        .toList(growable: false);
    _itemsController.add(active);
  }

  Future<void> dispose() async {
    await _inventoriesController.close();
    await _itemsController.close();
    await _eventsController.close();
  }
}
