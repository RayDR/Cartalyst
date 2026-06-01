import 'dart:async';

import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_category.dart';
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
      final InventoriesState state =
          container.read(inventoriesControllerProvider);
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
      expect(
        container.read(inventoriesControllerProvider).inventories,
        isEmpty,
      );
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

      await controller.createInventory('Pantry');
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
      expect(state.inventories.first.name, 'Pantry');
      expect(state.lastDeletedInventory, isNull);
    });

    test('inventories are sorted by updatedAt desc', () async {
      final DateTime t1 = DateTime(2026);
      final DateTime t2 = DateTime(2026, 1, 2);
      final DateTime t3 = DateTime(2026, 1, 3);

      repository.seedInventory(
        Inventory(
          id: 'inv-a',
          name: 'Alpha',
          createdAt: t1,
          updatedAt: t1,
          syncStatus: 'synced',
          version: 1,
        ),
      );
      repository.seedInventory(
        Inventory(
          id: 'inv-c',
          name: 'Charlie',
          createdAt: t3,
          updatedAt: t3,
          syncStatus: 'synced',
          version: 1,
        ),
      );
      repository.seedInventory(
        Inventory(
          id: 'inv-b',
          name: 'Bravo',
          createdAt: t2,
          updatedAt: t2,
          syncStatus: 'synced',
          version: 1,
        ),
      );
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

    test('createInventoryCategory creates category linked to inventory',
        () async {
      final InventoriesController controller =
          container.read(inventoriesControllerProvider.notifier);

      final String? inventoryId = await controller.createInventory('Pantry');
      expect(inventoryId, isNotNull);

      final String? inventoryCategoryId =
          await controller.createInventoryCategory(
        inventoryId: inventoryId!,
        name: 'Fruits',
      );

      expect(inventoryCategoryId, isNotNull);

      final List<InventoryCategory> categories =
          await repository.watchInventoryCategories(inventoryId).first;
      expect(
        categories.any((InventoryCategory c) => c.name == 'Fruits'),
        isTrue,
      );
    });

    test('saveInventoryItem falls back to Uncategorized when category is null',
        () async {
      final InventoriesController controller =
          container.read(inventoriesControllerProvider.notifier);

      final String? inventoryId = await controller.createInventory('Pantry');
      expect(inventoryId, isNotNull);

      final InventoryItem item = InventoryItem(
        id: 'item-1',
        inventoryId: inventoryId!,
        rawName: 'Loose item',
        status: InventoryItemStatus.inStock,
        confidenceScore: 0.8,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
        syncStatus: 'pending_sync',
        version: 1,
      );

      await repository.saveInventoryItem(item);

      expect(repository.items.single.inventoryCategoryId, isNotNull);
      final String assignedCategoryId =
          repository.items.single.inventoryCategoryId!;
      final List<InventoryCategory> categories =
          await repository.watchInventoryCategories(inventoryId).first;
      final InventoryCategory assigned = categories.firstWhere(
        (InventoryCategory c) => c.id == assignedCategoryId,
      );
      expect(assigned.name, 'Uncategorized');
    });
  });
}

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class FakeInventoryRepository extends InventoryRepository {
  final StreamController<List<Inventory>> _inventoriesController =
      StreamController<List<Inventory>>.broadcast();

  final StreamController<List<InventoryItem>> _itemsController =
      StreamController<List<InventoryItem>>.broadcast();

  final StreamController<List<InventoryEvent>> _eventsController =
      StreamController<List<InventoryEvent>>.broadcast();

  final List<Inventory> _inventories = <Inventory>[];
  final List<InventoryItem> _items = <InventoryItem>[];
  final List<InventoryEvent> _events = <InventoryEvent>[];
  final List<Category> _categories = <Category>[];
  final List<InventoryCategory> _inventoryCategories = <InventoryCategory>[];

  final List<String> deletedInventoryIds = <String>[];
  final List<String> deletedItemIds = <String>[];

  List<InventoryItem> get items => List<InventoryItem>.unmodifiable(_items);

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
    String? resolvedCategoryId = item.inventoryCategoryId;
    resolvedCategoryId ??= await ensureUncategorizedInventoryCategory(
      item.inventoryId,
    );

    final InventoryItem normalized = item.copyWith(
      inventoryCategoryId: resolvedCategoryId,
    );

    final int index = _items.indexWhere((InventoryItem e) => e.id == item.id);
    if (index >= 0) {
      _items[index] = normalized;
    } else {
      _items.add(normalized);
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

  @override
  Stream<List<InventoryCategory>> watchInventoryCategories(String inventoryId) {
    final List<InventoryCategory> categories = _inventoryCategories
        .where(
          (InventoryCategory category) =>
              category.inventoryId == inventoryId && category.deletedAt == null,
        )
        .toList(growable: false)
      ..sort(
        (InventoryCategory a, InventoryCategory b) =>
            a.sortOrder.compareTo(b.sortOrder),
      );
    return Stream<List<InventoryCategory>>.value(categories);
  }

  @override
  Future<void> saveCategory(Category category) async {
    final int index =
        _categories.indexWhere((Category e) => e.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
    } else {
      _categories.add(category);
    }
  }

  @override
  Future<void> saveInventoryCategory(InventoryCategory category) async {
    final int index = _inventoryCategories
        .indexWhere((InventoryCategory e) => e.id == category.id);
    if (index >= 0) {
      _inventoryCategories[index] = category;
    } else {
      _inventoryCategories.add(category);
    }
  }

  @override
  Future<String?> findUncategorizedInventoryCategoryId(
    String inventoryId,
  ) async {
    for (final InventoryCategory category in _inventoryCategories) {
      if (category.inventoryId != inventoryId || category.deletedAt != null) {
        continue;
      }
      if (category.name.toLowerCase() == 'uncategorized') {
        return category.id;
      }
    }
    return null;
  }

  @override
  Future<String> ensureUncategorizedInventoryCategory(
    String inventoryId,
  ) async {
    final String? existing =
        await findUncategorizedInventoryCategoryId(inventoryId);
    if (existing != null) {
      return existing;
    }

    const String categoryId = 'category-uncategorized';
    final DateTime now = DateTime.now();
    await saveCategory(
      Category(
        id: categoryId,
        name: 'Uncategorized',
        createdAt: now,
        updatedAt: now,
        syncStatus: 'pending_sync',
        version: 1,
      ),
    );

    final String inventoryCategoryId = 'invcat-$inventoryId-uncategorized';
    await saveInventoryCategory(
      InventoryCategory(
        id: inventoryCategoryId,
        inventoryId: inventoryId,
        categoryId: categoryId,
        name: 'Uncategorized',
        sortOrder: 0,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return inventoryCategoryId;
  }

  void _emitInventories() {
    _inventoriesController.add(_sortedActiveInventories());
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
