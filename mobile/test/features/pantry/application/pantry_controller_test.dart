import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/pantry/application/pantry_controller.dart';
import 'package:cartalyst_mobile/features/pantry/application/pantry_state.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';
import 'package:cartalyst_mobile/features/pantry/domain/repositories/pantry_repository.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakePantryRepository pantryRepository;
  late FakeProductRepository productRepository;
  late ProviderContainer container;

  setUp(() {
    pantryRepository = FakePantryRepository();
    productRepository = FakeProductRepository(
      products: <Product>[
        Product(
          id: 'product-eggs',
          canonicalName: 'eggs',
          category: 'protein',
          defaultUnit: Unit.fromCode('unit'),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
          syncStatus: 'synced',
          version: 1,
        ),
      ],
    );

    container = ProviderContainer(
      overrides: <Override>[
        pantryRepositoryProvider.overrideWithValue(pantryRepository),
        pantryProductRepositoryProvider.overrideWithValue(productRepository),
      ],
    );

    addTearDown(container.dispose);
    addTearDown(pantryRepository.dispose);
    addTearDown(productRepository.dispose);
  });

  Future<void> waitForProducts() async {
    for (int i = 0; i < 30; i++) {
      final PantryState state = container.read(pantryControllerProvider);
      if (state.products.isNotEmpty) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail('Products were not loaded.');
  }

  group('PantryController', () {
    test('adding pantry item', () async {
      await waitForProducts();

      final PantryController controller = container.read(pantryControllerProvider.notifier);
      controller.updateNameInput('Farm eggs');
      controller.updateSelectedProduct('product-eggs');
      controller.updateQuantityInput('2');
      controller.updateUnitCode('unit');

      await controller.addPantryItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final PantryState state = container.read(pantryControllerProvider);
      expect(state.inStockItems.length, 1);
      expect(state.inStockItems.first.productId, 'product-eggs');
      expect(state.inStockItems.first.status, PantryItemStatus.inStock);
    });

    test('marking running low', () async {
      await waitForProducts();

      final PantryController controller = container.read(pantryControllerProvider.notifier);
      controller.updateNameInput('Milk');
      controller.updateQuantityInput('1');
      controller.updateUnitCode('liter');
      await controller.addPantryItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final PantryState state = container.read(pantryControllerProvider);
      await controller.markRunningLow(state.inStockItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final PantryState updatedState = container.read(pantryControllerProvider);
      expect(updatedState.lowItems.length, 1);
      expect(updatedState.lowItems.first.status, PantryItemStatus.low);
    });

    test('marking finished', () async {
      await waitForProducts();

      final PantryController controller = container.read(pantryControllerProvider.notifier);
      controller.updateNameInput('Bread');
      controller.updateQuantityInput('1');
      controller.updateUnitCode('unit');
      await controller.addPantryItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      PantryState state = container.read(pantryControllerProvider);
      await controller.markFinished(state.inStockItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(pantryControllerProvider);
      expect(state.finishedItems.length, 1);
      expect(state.finishedItems.first.status, PantryItemStatus.out);
      expect(state.finishedItems.first.quantityEstimated, 0);
    });

    test('inventory event creation', () async {
      await waitForProducts();

      final PantryController controller = container.read(pantryControllerProvider.notifier);
      controller.updateNameInput('Rice');
      controller.updateQuantityInput('1');
      controller.updateUnitCode('kg');
      await controller.addPantryItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final PantryState state = container.read(pantryControllerProvider);
      await controller.markRunningLow(state.inStockItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(pantryRepository.events.length, greaterThanOrEqualTo(2));
      expect(pantryRepository.events.first.eventType, InventoryEventType.purchase);
      expect(
        pantryRepository.events.any((InventoryEvent event) => event.eventType == InventoryEventType.consume),
        isTrue,
      );
    });

    test('soft delete', () async {
      await waitForProducts();

      final PantryController controller = container.read(pantryControllerProvider.notifier);
      controller.updateNameInput('Beans');
      controller.updateQuantityInput('1');
      controller.updateUnitCode('kg');
      await controller.addPantryItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      PantryState state = container.read(pantryControllerProvider);
      final String itemId = state.inStockItems.first.id;
      await controller.softDelete(state.inStockItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(pantryControllerProvider);
      expect(state.inStockItems, isEmpty);
      expect(pantryRepository.deletedItemIds.contains(itemId), isTrue);
      expect(
        pantryRepository.events.any((InventoryEvent event) => event.eventType == InventoryEventType.discard),
        isTrue,
      );
    });
  });
}

class FakePantryRepository implements PantryRepository {
  final StreamController<List<PantryItem>> _itemsController =
      StreamController<List<PantryItem>>.broadcast();

  final StreamController<List<InventoryEvent>> _eventsController =
      StreamController<List<InventoryEvent>>.broadcast();

  final List<PantryItem> _items = <PantryItem>[];
  final List<InventoryEvent> events = <InventoryEvent>[];

  List<String> get deletedItemIds => _items
      .where((PantryItem item) => item.deletedAt != null)
      .map((PantryItem item) => item.id)
      .toList(growable: false);

  @override
  Stream<List<PantryItem>> watchPantryItems() {
    Future<void>.microtask(_emitItems);
    return _itemsController.stream;
  }

  @override
  Stream<List<InventoryEvent>> watchInventoryEvents() {
    Future<void>.microtask(() => _eventsController.add(events));
    return _eventsController.stream;
  }

  @override
  Future<void> savePantryItem(PantryItem item) async {
    final int index = _items.indexWhere((PantryItem element) => element.id == item.id);
    if (index >= 0) {
      _items[index] = item;
    } else {
      _items.add(item);
    }
    _emitItems();
  }

  @override
  Future<void> addInventoryEvent(InventoryEvent event) async {
    events.add(event);
    _eventsController.add(events);
  }

  void _emitItems() {
    final List<PantryItem> active = _items
        .where((PantryItem item) => item.deletedAt == null)
        .toList(growable: false);
    _itemsController.add(active);
  }

  Future<void> dispose() async {
    await _itemsController.close();
    await _eventsController.close();
  }
}

class FakeProductRepository implements ProductRepository {
  FakeProductRepository({required List<Product> products}) : _products = products;

  final List<Product> _products;

  final StreamController<List<Product>> _productsController =
      StreamController<List<Product>>.broadcast();

  @override
  Stream<List<Product>> watchActiveProducts() {
    Future<void>.microtask(() => _productsController.add(_products));
    return _productsController.stream;
  }

  @override
  Future<List<ProductAlias>> findAliasesForProduct(String productId) async {
    return const <ProductAlias>[];
  }

  @override
  Future<List<ProductAlias>> findAliasesForProducts(List<String> productIds) async {
    return const <ProductAlias>[];
  }

  @override
  Future<void> saveProduct(Product product) async {}

  @override
  Future<void> saveAlias(ProductAlias alias) async {}

  Future<void> dispose() async {
    await _productsController.close();
  }
}
