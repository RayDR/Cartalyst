import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_state.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show productRepositoryProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const String _inventoryId = 'test-inventory-1';

void main() {
  late FakeInventoryRepository repository;
  late FakeProductRepository productRepository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeInventoryRepository();
    productRepository = FakeProductRepository(
      products: <Product>[
        Product(
          id: 'product-milk',
          canonicalName: 'milk',
          category: 'dairy',
          defaultUnit: Unit.fromCode('liter'),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
          syncStatus: 'synced',
          version: 1,
        ),
      ],
    );

    container = ProviderContainer(
      overrides: <Override>[
        inventoryRepositoryProvider.overrideWithValue(repository),
        productRepositoryProvider.overrideWithValue(productRepository),
      ],
    );

    addTearDown(container.dispose);
    addTearDown(repository.dispose);
    addTearDown(productRepository.dispose);
  });

  Future<void> waitForProducts() async {
    for (int i = 0; i < 30; i++) {
      final InventoryDetailState state =
          container.read(inventoryDetailControllerProvider(_inventoryId));
      if (state.products.isNotEmpty) return;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail('Products were not loaded.');
  }

  group('InventoryDetailController', () {
    test('items are displayed grouped by status', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('Eggs');
      controller.updateQuantityInput('12');
      controller.updateUnitCode('unit');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      controller.updateNameInput('Milk');
      controller.updateQuantityInput('1');
      controller.updateUnitCode('liter');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final InventoryDetailState state =
          container.read(inventoryDetailControllerProvider(_inventoryId));
      expect(state.inStockItems.length, 2);
      expect(state.lowItems, isEmpty);
      expect(state.finishedItems, isEmpty);
    });

    test('markRunningLow moves item to lowItems', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('Cheese');
      controller.updateQuantityInput('3');
      controller.updateUnitCode('unit');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      InventoryDetailState state =
          container.read(inventoryDetailControllerProvider(_inventoryId));
      await controller.markRunningLow(state.inStockItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(inventoryDetailControllerProvider(_inventoryId));
      expect(state.inStockItems, isEmpty);
      expect(state.lowItems.length, 1);
      expect(state.lowItems.first.status, InventoryItemStatus.low);
    });

    test('markFinished moves item to finishedItems', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('Bread');
      controller.updateQuantityInput('1');
      controller.updateUnitCode('unit');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      InventoryDetailState state =
          container.read(inventoryDetailControllerProvider(_inventoryId));
      await controller.markFinished(state.inStockItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(inventoryDetailControllerProvider(_inventoryId));
      expect(state.inStockItems, isEmpty);
      expect(state.finishedItems.length, 1);
      expect(state.finishedItems.first.quantityEstimated, 0);
    });

    test('softDelete removes item from view', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('Rice');
      controller.updateQuantityInput('2');
      controller.updateUnitCode('kg');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      InventoryDetailState state =
          container.read(inventoryDetailControllerProvider(_inventoryId));
      final String itemId = state.inStockItems.first.id;
      await controller.softDelete(state.inStockItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(inventoryDetailControllerProvider(_inventoryId));
      expect(state.inStockItems, isEmpty);
      expect(repository.deletedItemIds.contains(itemId), isTrue);
    });

    test('addItem creates inventory event of type purchase', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('Flour');
      controller.updateQuantityInput('1');
      controller.updateUnitCode('kg');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(repository.events.length, 1);
      expect(repository.events.first.eventType, InventoryEventType.purchase);
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

  final List<Inventory> _inventories = <Inventory>[];
  final List<InventoryItem> _items = <InventoryItem>[];
  final List<InventoryEvent> events = <InventoryEvent>[];

  List<String> get deletedItemIds => _items
      .where((InventoryItem item) => item.deletedAt != null)
      .map((InventoryItem item) => item.id)
      .toList(growable: false);

  @override
  Stream<List<Inventory>> watchAllInventories() {
    Future<void>.microtask(
      () => _inventoriesController.add(List<Inventory>.unmodifiable(_inventories)),
    );
    return _inventoriesController.stream;
  }

  @override
  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId) {
    Future<void>.microtask(_emitItems);
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
    _inventoriesController.add(List<Inventory>.unmodifiable(_inventories));
  }

  @override
  Future<void> deleteInventory(String id) async {
    final int index = _inventories.indexWhere((Inventory e) => e.id == id);
    if (index >= 0) {
      _inventories[index] =
          _inventories[index].copyWith(deletedAt: DateTime.now());
    }
    final List<Inventory> active = _inventories
        .where((Inventory e) => e.deletedAt == null)
        .toList(growable: false);
    _inventoriesController.add(active);
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
    final int index = _items.indexWhere((InventoryItem e) => e.id == id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(deletedAt: DateTime.now());
    }
    _emitItems();
  }

  @override
  Future<void> addInventoryEvent(InventoryEvent event) async {
    events.add(event);
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
  }
}

class FakeProductRepository implements ProductRepository {
  FakeProductRepository({required List<Product> products})
      : _products = products;

  final List<Product> _products;
  final StreamController<List<Product>> _controller =
      StreamController<List<Product>>.broadcast();

  @override
  Stream<List<Product>> watchActiveProducts() {
    Future<void>.microtask(() => _controller.add(_products));
    return _controller.stream;
  }

  @override
  Future<List<ProductAlias>> findAliasesForProduct(String productId) async {
    return const <ProductAlias>[];
  }

  @override
  Future<List<ProductAlias>> findAliasesForProducts(
      List<String> productIds) async {
    return const <ProductAlias>[];
  }

  @override
  Future<void> saveProduct(Product product) async {}

  @override
  Future<void> saveAlias(ProductAlias alias) async {}

  Future<void> dispose() async {
    await _controller.close();
  }
}
