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

  Future<void> waitForActiveList() async {
    for (int i = 0; i < 30; i++) {
      final ShoppingListState state = container.read(shoppingListControllerProvider);
      if (state.activeList != null) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail('Active list was not created automatically.');
  }

  group('ShoppingListController', () {
    test('adding matched product', () async {
      await waitForActiveList();

      final ShoppingListController controller = container.read(shoppingListControllerProvider.notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final ShoppingListState state = container.read(shoppingListControllerProvider);
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.productId, 'p-milk');
      expect(state.pendingItems.first.source, ShoppingListItemSource.suggestion);
    });

    test('adding custom item', () async {
      await waitForActiveList();

      final ShoppingListController controller = container.read(shoppingListControllerProvider.notifier);
      controller.updateQuickAddInput('dragonfruit 2');
      await controller.addCustomItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final ShoppingListState state = container.read(shoppingListControllerProvider);
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.productId, isNull);
      expect(state.pendingItems.first.rawText, 'dragonfruit');
      expect(state.pendingItems.first.quantity, 2);
      expect(state.pendingItems.first.source, ShoppingListItemSource.manual);
    });

    test('purchased status transition', () async {
      await waitForActiveList();

      final ShoppingListController controller = container.read(shoppingListControllerProvider.notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state = container.read(shoppingListControllerProvider);
      await controller.markPurchased(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider);
      expect(state.pendingItems, isEmpty);
      expect(state.purchasedItems.length, 1);
      expect(state.purchasedItems.first.status, ShoppingListItemStatus.purchased);
    });

    test('skipped status transition', () async {
      await waitForActiveList();

      final ShoppingListController controller = container.read(shoppingListControllerProvider.notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state = container.read(shoppingListControllerProvider);
      await controller.markSkipped(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider);
      expect(state.pendingItems, isEmpty);
      expect(state.skippedItems.length, 1);
      expect(state.skippedItems.first.status, ShoppingListItemStatus.skipped);
    });

    test('restore to pending', () async {
      await waitForActiveList();

      final ShoppingListController controller = container.read(shoppingListControllerProvider.notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state = container.read(shoppingListControllerProvider);
      await controller.markSkipped(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider);
      await controller.restorePending(state.skippedItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider);
      expect(state.skippedItems, isEmpty);
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.status, ShoppingListItemStatus.pending);
    });

    test('soft delete', () async {
      await waitForActiveList();

      final ShoppingListController controller = container.read(shoppingListControllerProvider.notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state = container.read(shoppingListControllerProvider);
      final String itemId = state.pendingItems.first.id;
      await controller.softDelete(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider);
      expect(state.pendingItems, isEmpty);
      expect(shoppingListRepository.deletedItemIds.contains(itemId), isTrue);
    });
  });
}

class FakeShoppingListRepository implements ShoppingListRepository {
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

  @override
  Stream<List<ShoppingList>> watchActiveLists() {
    Future<void>.microtask(_emitLists);
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
    _emitLists();
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

  void _emitLists() {
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
