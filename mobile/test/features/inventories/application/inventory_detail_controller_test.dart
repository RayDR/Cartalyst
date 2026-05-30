import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_state.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_category.dart';
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
      aliases: <ProductAlias>[
        ProductAlias(
          id: 'alias-milk-es',
          productId: 'product-milk',
          alias: 'leche',
          languageCode: 'es',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
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
    test('addItem works with only custom name', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('oatmeal jar');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final InventoryItem saved = repository.items.last;
      expect(saved.rawName, 'oatmeal jar');
      expect(saved.productId, isNull);
    });

    test('addItem links known product suggestion from typed name', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('milk');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final InventoryItem saved = repository.items.last;
      expect(saved.productId, 'product-milk');
      expect(saved.rawName, isNull);
    });

    test('addItem links known product from Spanish alias', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('leche');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final InventoryItem saved = repository.items.last;
      expect(saved.productId, 'product-milk');
      expect(saved.rawName, isNull);
    });

    test('addItem allows missing quantity and unit', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('custom spice');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final InventoryItem saved = repository.items.last;
      expect(saved.quantityEstimated, isNull);
      expect(saved.unit, isNull);
    });

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

    test('assignItemToCategory persists selected category id', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      controller.updateNameInput('Apples');
      controller.updateQuantityInput('4');
      controller.updateUnitCode('unit');
      await controller.addItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      InventoryDetailState state =
          container.read(inventoryDetailControllerProvider(_inventoryId));
      final InventoryItem created = state.inStockItems.first;

      await controller.assignItemToCategory(
        item: created,
        inventoryCategoryId: 'invcat-fruits',
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(inventoryDetailControllerProvider(_inventoryId));
      expect(state.inStockItems.first.inventoryCategoryId, 'invcat-fruits');
    });

    test('createCategory creates inventory category', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      final String? id = await controller.createCategory('Produce');

      expect(id, isNotNull);
      expect(
        repository.categories
            .any((InventoryCategory category) => category.id == id),
        isTrue,
      );
    });

    test('addItemWithDetails supports explicit category', () async {
      await waitForProducts();

      final String? categoryId = await repository.createCategoryForTest(
        inventoryId: _inventoryId,
        name: 'Dairy',
      );

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      await controller.addItemWithDetails(
        name: 'milk',
        inventoryCategoryId: categoryId,
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(repository.items.last.inventoryCategoryId, categoryId);
    });

    test('addItemWithDetails falls back to Uncategorized category', () async {
      await waitForProducts();

      final InventoryDetailController controller = container
          .read(inventoryDetailControllerProvider(_inventoryId).notifier);

      await controller.addItemWithDetails(name: 'random ingredient');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final String? uncategorizedId =
          await repository.findUncategorizedInventoryCategoryId(_inventoryId);
      expect(uncategorizedId, isNotNull);
      expect(repository.items.last.inventoryCategoryId, uncategorizedId);
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

  final List<Inventory> _inventories = <Inventory>[];
  final List<InventoryItem> _items = <InventoryItem>[];
  final List<Category> _categories = <Category>[];
  final List<InventoryCategory> _inventoryCategories = <InventoryCategory>[];
  final List<InventoryEvent> events = <InventoryEvent>[];

  List<InventoryItem> get items => List<InventoryItem>.unmodifiable(_items);
  List<InventoryCategory> get categories =>
      List<InventoryCategory>.unmodifiable(_inventoryCategories);

  List<String> get deletedItemIds => _items
      .where((InventoryItem item) => item.deletedAt != null)
      .map((InventoryItem item) => item.id)
      .toList(growable: false);

  @override
  Stream<List<Inventory>> watchAllInventories() {
    Future<void>.microtask(
      () => _inventoriesController
          .add(List<Inventory>.unmodifiable(_inventories)),
    );
    return _inventoriesController.stream;
  }

  @override
  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId) {
    Future<void>.microtask(_emitItems);
    return _itemsController.stream;
  }

  @override
  Stream<List<InventoryCategory>> watchInventoryCategories(String inventoryId) {
    return Stream<List<InventoryCategory>>.value(
      _inventoryCategories
          .where((InventoryCategory category) =>
              category.inventoryId == inventoryId)
          .toList(growable: false),
    );
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
    final int index = _items.indexWhere((InventoryItem e) => e.id == item.id);
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

  @override
  Future<void> saveCategory(Category category) async {
    final int index =
        _categories.indexWhere((Category c) => c.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
    } else {
      _categories.add(category);
    }
  }

  @override
  Future<void> saveInventoryCategory(InventoryCategory category) async {
    final int index = _inventoryCategories
        .indexWhere((InventoryCategory c) => c.id == category.id);
    if (index >= 0) {
      _inventoryCategories[index] = category;
    } else {
      _inventoryCategories.add(category);
    }
  }

  @override
  Future<String?> findUncategorizedInventoryCategoryId(
      String inventoryId) async {
    for (final InventoryCategory category in _inventoryCategories) {
      if (category.inventoryId == inventoryId &&
          category.name.toLowerCase() == 'uncategorized') {
        return category.id;
      }
    }
    return null;
  }

  @override
  Future<String> ensureUncategorizedInventoryCategory(
      String inventoryId) async {
    final String? existing =
        await findUncategorizedInventoryCategoryId(inventoryId);
    if (existing != null) {
      return existing;
    }

    final DateTime now = DateTime.now();
    const String categoryId = 'cat-uncategorized';
    final String inventoryCategoryId = 'invcat-uncategorized-$inventoryId';

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

    await saveInventoryCategory(
      InventoryCategory(
        id: inventoryCategoryId,
        inventoryId: inventoryId,
        categoryId: categoryId,
        name: 'Uncategorized',
        sortOrder: _inventoryCategories.length,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return inventoryCategoryId;
  }

  Future<String?> createCategoryForTest({
    required String inventoryId,
    required String name,
  }) async {
    final DateTime now = DateTime.now();
    final String categoryId = 'cat-${name.toLowerCase()}';
    final String inventoryCategoryId = 'invcat-${name.toLowerCase()}';
    await saveCategory(
      Category(
        id: categoryId,
        name: name,
        createdAt: now,
        updatedAt: now,
        syncStatus: 'pending_sync',
        version: 1,
      ),
    );
    await saveInventoryCategory(
      InventoryCategory(
        id: inventoryCategoryId,
        inventoryId: inventoryId,
        categoryId: categoryId,
        name: name,
        sortOrder: _inventoryCategories.length,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return inventoryCategoryId;
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
  FakeProductRepository({
    required List<Product> products,
    required List<ProductAlias> aliases,
  })  : _products = products,
        _aliases = aliases;

  final List<Product> _products;
  final List<ProductAlias> _aliases;
  final StreamController<List<Product>> _controller =
      StreamController<List<Product>>.broadcast();

  @override
  Stream<List<Product>> watchActiveProducts() {
    Future<void>.microtask(() => _controller.add(_products));
    return _controller.stream;
  }

  @override
  Future<List<ProductAlias>> findAliasesForProduct(String productId) async {
    return _aliases
        .where((ProductAlias alias) => alias.productId == productId)
        .toList(growable: false);
  }

  @override
  Future<List<ProductAlias>> findAliasesForProducts(
    List<String> productIds,
  ) async {
    return _aliases
        .where((ProductAlias alias) => productIds.contains(alias.productId))
        .toList(growable: false);
  }

  @override
  Future<void> saveProduct(Product product) async {}

  @override
  Future<void> saveAlias(ProductAlias alias) async {}

  Future<void> dispose() async {
    await _controller.close();
  }
}
