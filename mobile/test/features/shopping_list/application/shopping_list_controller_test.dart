import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeShoppingListRepository shoppingListRepository;
  late FakeProductRepository productRepository;
  late ProviderContainer container;

  const String testListId = 'test-list-id';

  setUp(() {
    shoppingListRepository = FakeShoppingListRepository();
    productRepository = FakeProductRepository(
      products: <Product>[
        Product(
          id: 'p-milk',
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
          id: 'a-1',
          productId: 'p-milk',
          alias: 'leche',
          languageCode: 'es',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ],
    );

    // Pre-seed a list so the controller has items to work with.
    shoppingListRepository.seedList(ShoppingList(
      id: testListId,
      name: 'Test list',
      status: ShoppingListStatus.active,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      syncStatus: 'local_only',
      version: 1,
    ));

    container = ProviderContainer(
      overrides: <Override>[
        shoppingListRepositoryProvider.overrideWithValue(shoppingListRepository),
        productRepositoryProvider.overrideWithValue(productRepository),
      ],
    );

    addTearDown(container.dispose);
    addTearDown(shoppingListRepository.dispose);
    addTearDown(productRepository.dispose);
  });

  group('ShoppingListController', () {
    test('adding matched product', () async {
      // Give the products stream time to deliver before matching.
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.productId, 'p-milk');
      expect(state.pendingItems.first.source, ShoppingListItemSource.suggestion);
    });

    test('adding custom item', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('dragonfruit 2');
      await controller.addCustomItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.productId, isNull);
      expect(state.pendingItems.first.rawText, 'dragonfruit');
      expect(state.pendingItems.first.quantity, 2);
      expect(state.pendingItems.first.source, ShoppingListItemSource.manual);
    });

    test('quick add preserves gal unit for gallon variants', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);

      controller.updateQuickAddInput('1 gallon milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.unit?.code, 'gal');
      expect(state.pendingItems.first.quantity, 1);

      controller.updateQuickAddInput('1 gal leche');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 2);
      expect(state.pendingItems[1].unit?.code, 'gal');
      expect(state.pendingItems[1].quantity, 1);

      controller.updateQuickAddInput('2 gallons milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 3);
      expect(state.pendingItems[2].unit?.code, 'gal');
      expect(state.pendingItems[2].quantity, 2);
    });

    test('purchased status transition', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markPurchased(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems, isEmpty);
      expect(state.purchasedItems.length, 1);
      expect(state.purchasedItems.first.status, ShoppingListItemStatus.purchased);
    });

    test('skipped status transition', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markSkipped(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems, isEmpty);
      expect(state.skippedItems.length, 1);
      expect(state.skippedItems.first.status, ShoppingListItemStatus.skipped);
    });

    test('restore to pending', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markSkipped(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      await controller.restorePending(state.skippedItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.skippedItems, isEmpty);
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.status, ShoppingListItemStatus.pending);
    });

    test('soft delete', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      final String itemId = state.pendingItems.first.id;
      await controller.softDelete(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems, isEmpty);
      expect(shoppingListRepository.deletedItemIds.contains(itemId), isTrue);
    });
  });
}

class FakeShoppingListRepository implements ShoppingListRepository {
  final StreamController<List<ShoppingList>> _allListsController =
      StreamController<List<ShoppingList>>.broadcast();

  final StreamController<List<ShoppingList>> _activeListsController =
      StreamController<List<ShoppingList>>.broadcast();

  final Map<String, StreamController<List<ShoppingListItem>>> _itemsControllers =
      <String, StreamController<List<ShoppingListItem>>>{};

  final List<ShoppingList> _lists = <ShoppingList>[];
  final List<ShoppingListItem> _items = <ShoppingListItem>[];

  List<String> get deletedItemIds => _items
      .where((ShoppingListItem item) => item.deletedAt != null)
      .map((ShoppingListItem item) => item.id)
      .toList(growable: false);

  void seedList(ShoppingList list) {
    _lists.add(list);
  }

  @override
  Stream<List<ShoppingList>> watchAllLists() {
    Future<void>.microtask(_emitAllLists);
    return _allListsController.stream;
  }

  @override
  Stream<List<ShoppingList>> watchActiveLists() {
    Future<void>.microtask(_emitActiveLists);
    return _activeListsController.stream;
  }

  @override
  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId) {
    final StreamController<List<ShoppingListItem>> controller =
        _itemsControllers.putIfAbsent(
      shoppingListId,
      () => StreamController<List<ShoppingListItem>>.broadcast(),
    );
    Future<void>.microtask(() => _emitItemsForList(shoppingListId));
    return controller.stream;
  }

  @override
  Future<void> saveShoppingList(ShoppingList shoppingList) async {
    final int index = _lists.indexWhere((ShoppingList element) => element.id == shoppingList.id);
    if (index >= 0) {
      _lists[index] = shoppingList;
    } else {
      _lists.add(shoppingList);
    }
    _emitAllLists();
    _emitActiveLists();
  }

  @override
  Future<void> saveShoppingListItem(ShoppingListItem item) async {
    final int index = _items.indexWhere((ShoppingListItem element) => element.id == item.id);
    if (index >= 0) {
      _items[index] = item;
    } else {
      _items.add(item);
    }
    _emitItemsForList(item.shoppingListId);
  }

  @override
  Future<void> deleteShoppingList(String id) async {
    final int index = _lists.indexWhere((ShoppingList l) => l.id == id);
    if (index >= 0) {
      _lists[index] = ShoppingList(
        id: _lists[index].id,
        inventoryId: _lists[index].inventoryId,
        name: _lists[index].name,
        status: _lists[index].status,
        createdAt: _lists[index].createdAt,
        updatedAt: DateTime.now(),
        deletedAt: DateTime.now(),
        syncStatus: 'pending_sync',
        version: _lists[index].version + 1,
      );
    }
    _emitAllLists();
    _emitActiveLists();
  }

  void _emitAllLists() {
    final List<ShoppingList> nonDeleted = _lists
        .where((ShoppingList l) => l.deletedAt == null)
        .toList(growable: false);
    _allListsController.add(nonDeleted);
  }

  void _emitActiveLists() {
    final List<ShoppingList> active = _lists
        .where(
          (ShoppingList list) =>
              list.deletedAt == null && list.status == ShoppingListStatus.active,
        )
        .toList(growable: false);
    _activeListsController.add(active);
  }

  void _emitItemsForList(String shoppingListId) {
    final StreamController<List<ShoppingListItem>>? controller =
        _itemsControllers[shoppingListId];
    if (controller == null) {
      return;
    }

    final List<ShoppingListItem> items = _items
        .where(
          (ShoppingListItem item) =>
              item.shoppingListId == shoppingListId && item.deletedAt == null,
        )
        .toList(growable: false);

    controller.add(items);
  }

  Future<void> dispose() async {
    await _allListsController.close();
    await _activeListsController.close();
    for (final StreamController<List<ShoppingListItem>> controller in _itemsControllers.values) {
      await controller.close();
    }
  }
}

class FakeProductRepository implements ProductRepository {
  FakeProductRepository({
    required List<Product> products,
    required List<ProductAlias> aliases,
  })  : _products = products,
        _aliases = aliases;

  final StreamController<List<Product>> _productsController =
      StreamController<List<Product>>.broadcast();

  final List<Product> _products;
  final List<ProductAlias> _aliases;

  @override
  Stream<List<Product>> watchActiveProducts() {
    Future<void>.microtask(() => _productsController.add(_products));
    return _productsController.stream;
  }

  @override
  Future<List<ProductAlias>> findAliasesForProduct(String productId) async {
    return _aliases
        .where((ProductAlias alias) => alias.productId == productId)
        .toList(growable: false);
  }

  @override
  Future<List<ProductAlias>> findAliasesForProducts(List<String> productIds) async {
    return _aliases
        .where((ProductAlias alias) => productIds.contains(alias.productId))
        .toList(growable: false);
  }

  @override
  Future<void> saveProduct(Product product) async {
    final int index = _products.indexWhere((Product element) => element.id == product.id);
    if (index >= 0) {
      _products[index] = product;
    } else {
      _products.add(product);
    }
    _productsController.add(_products);
  }

  @override
  Future<void> saveAlias(ProductAlias alias) async {
    _aliases.add(alias);
  }

  Future<void> dispose() async {
    await _productsController.close();
  }
}
