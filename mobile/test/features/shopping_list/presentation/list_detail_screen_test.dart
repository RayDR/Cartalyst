import 'dart:async';

import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/presentation/list_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late _FakeShoppingListRepository shoppingListRepository;
  late _FakeProductRepository productRepository;
  late _FakeInventoryRepository inventoryRepository;

  setUp(() {
    shoppingListRepository = _FakeShoppingListRepository();
    productRepository = _FakeProductRepository();
    inventoryRepository = _FakeInventoryRepository();
  });

  tearDown(() async {
    await shoppingListRepository.dispose();
    await productRepository.dispose();
    await inventoryRepository.dispose();
  });

  testWidgets('renames list from overflow menu', (WidgetTester tester) async {
    final ShoppingList list = _sampleList(name: 'Weekly list');
    shoppingListRepository.seedList(list);

    await _pumpListDetail(
      tester,
      listId: list.id,
      shoppingListRepository: shoppingListRepository,
      productRepository: productRepository,
      inventoryRepository: inventoryRepository,
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rename list'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'Renamed list');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(shoppingListRepository.lists.first.name, 'Renamed list');
  });

  testWidgets('renders quick add near the top before item sections', (
    WidgetTester tester,
  ) async {
    final ShoppingList list = _sampleList(name: 'Top-priority list');
    shoppingListRepository.seedList(list);
    shoppingListRepository.seedItem(
      _sampleItem(
        id: 'item-1',
        listId: list.id,
        name: 'Milk',
      ),
    );

    await _pumpListDetail(
      tester,
      listId: list.id,
      shoppingListRepository: shoppingListRepository,
      productRepository: productRepository,
      inventoryRepository: inventoryRepository,
    );

    final double quickAddY =
        tester.getTopLeft(find.text('Quick product add')).dy;
    final double pendingY = tester.getTopLeft(find.text('Pending').first).dy;

    expect(quickAddY, lessThan(pendingY));
  });

  testWidgets('renders linked inventory in compact chip row', (
    WidgetTester tester,
  ) async {
    final ShoppingList list = _sampleList(
      name: 'Linked list',
      inventoryId: 'inv-1',
    );
    shoppingListRepository.seedList(list);
    inventoryRepository.seedInventory(
      Inventory(
        id: 'inv-1',
        name: 'Pantry',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
        syncStatus: 'local_only',
        version: 1,
      ),
    );

    await _pumpListDetail(
      tester,
      listId: list.id,
      shoppingListRepository: shoppingListRepository,
      productRepository: productRepository,
      inventoryRepository: inventoryRepository,
    );

    expect(find.text('Linked to Pantry'), findsOneWidget);
    expect(
      find.textContaining('Link this list to an inventory'),
      findsNothing,
    );
  });

  testWidgets('archives list from overflow action',
      (WidgetTester tester) async {
    final ShoppingList list = _sampleList(name: 'Archive me');
    shoppingListRepository.seedList(list);

    await _pumpListDetail(
      tester,
      listId: list.id,
      shoppingListRepository: shoppingListRepository,
      productRepository: productRepository,
      inventoryRepository: inventoryRepository,
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archive list'));
    await tester.pumpAndSettle();

    expect(
      shoppingListRepository.lists.first.status,
      ShoppingListStatus.archived,
    );
  });

  testWidgets('deletes list from overflow action', (WidgetTester tester) async {
    final ShoppingList list = _sampleList(name: 'Delete me');
    shoppingListRepository.seedList(list);

    await _pumpListDetail(
      tester,
      listId: list.id,
      shoppingListRepository: shoppingListRepository,
      productRepository: productRepository,
      inventoryRepository: inventoryRepository,
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete list'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(shoppingListRepository.deletedListIds, contains(list.id));
  });
}

Future<void> _pumpListDetail(
  WidgetTester tester, {
  required String listId,
  required _FakeShoppingListRepository shoppingListRepository,
  required _FakeProductRepository productRepository,
  required _FakeInventoryRepository inventoryRepository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        shoppingListRepositoryProvider
            .overrideWithValue(shoppingListRepository),
        productRepositoryProvider.overrideWithValue(productRepository),
        inventoryRepositoryProvider.overrideWithValue(inventoryRepository),
        uuidProvider.overrideWithValue(const Uuid()),
      ],
      child: MaterialApp(
        home: ListDetailScreen(listId: listId),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

ShoppingList _sampleList({
  required String name,
  String? inventoryId,
}) {
  return ShoppingList(
    id: 'list-1',
    inventoryId: inventoryId,
    name: name,
    status: ShoppingListStatus.active,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
    syncStatus: 'local_only',
    version: 1,
  );
}

ShoppingListItem _sampleItem({
  required String id,
  required String listId,
  required String name,
}) {
  return ShoppingListItem(
    id: id,
    shoppingListId: listId,
    rawText: name,
    status: ShoppingListItemStatus.pending,
    source: ShoppingListItemSource.manual,
    priorityScore: 0.5,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
    syncStatus: 'local_only',
    version: 1,
  );
}

class _FakeShoppingListRepository implements ShoppingListRepository {
  final StreamController<List<ShoppingList>> _allListsController =
      StreamController<List<ShoppingList>>.broadcast();
  final StreamController<List<ShoppingList>> _activeListsController =
      StreamController<List<ShoppingList>>.broadcast();
  final Map<String, StreamController<List<ShoppingListItem>>>
      _itemsControllers = <String, StreamController<List<ShoppingListItem>>>{};

  final List<ShoppingList> lists = <ShoppingList>[];
  final List<ShoppingListItem> _items = <ShoppingListItem>[];
  final List<String> deletedListIds = <String>[];

  void seedList(ShoppingList list) {
    lists.add(list);
  }

  void seedItem(ShoppingListItem item) {
    _items.add(item);
  }

  @override
  Stream<List<ShoppingList>> watchActiveLists() {
    Future<void>.microtask(_emitActive);
    return _activeListsController.stream;
  }

  @override
  Stream<List<ShoppingList>> watchAllLists() {
    Future<void>.microtask(_emitAll);
    return _allListsController.stream;
  }

  @override
  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId) {
    final StreamController<List<ShoppingListItem>> controller =
        _itemsControllers.putIfAbsent(
      shoppingListId,
      () => StreamController<List<ShoppingListItem>>.broadcast(),
    );
    Future<void>.microtask(() => _emitItems(shoppingListId));
    return controller.stream;
  }

  @override
  Future<void> saveShoppingList(ShoppingList shoppingList) async {
    final int index =
        lists.indexWhere((ShoppingList item) => item.id == shoppingList.id);
    if (index >= 0) {
      lists[index] = shoppingList;
    } else {
      lists.add(shoppingList);
    }
    _emitAll();
    _emitActive();
  }

  @override
  Future<void> saveShoppingListItem(ShoppingListItem item) async {
    final int index =
        _items.indexWhere((ShoppingListItem value) => value.id == item.id);
    if (index >= 0) {
      _items[index] = item;
    } else {
      _items.add(item);
    }
    _emitItems(item.shoppingListId);
  }

  @override
  Future<void> deleteShoppingList(String id) async {
    final int index = lists.indexWhere((ShoppingList item) => item.id == id);
    if (index >= 0) {
      deletedListIds.add(id);
      final ShoppingList existing = lists[index];
      lists[index] = existing.copyWith(
        deletedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: existing.version + 1,
        syncStatus: 'pending_sync',
      );
    }
    _emitAll();
    _emitActive();
  }

  @override
  Future<ShoppingListDraft?> readDraft(String shoppingListId) async {
    return null;
  }

  @override
  Future<void> saveDraft(ShoppingListDraft draft) async {}

  @override
  Future<void> deleteDraft(String shoppingListId) async {}

  void _emitAll() {
    final List<ShoppingList> visible = lists
        .where((ShoppingList item) => item.deletedAt == null)
        .toList(growable: false);
    _allListsController.add(visible);
  }

  void _emitActive() {
    final List<ShoppingList> visible = lists
        .where(
          (ShoppingList item) =>
              item.deletedAt == null &&
              item.status == ShoppingListStatus.active,
        )
        .toList(growable: false);
    _activeListsController.add(visible);
  }

  void _emitItems(String listId) {
    final StreamController<List<ShoppingListItem>>? controller =
        _itemsControllers[listId];
    if (controller == null) {
      return;
    }
    final List<ShoppingListItem> filtered = _items
        .where(
          (ShoppingListItem item) =>
              item.shoppingListId == listId && item.deletedAt == null,
        )
        .toList(growable: false);
    controller.add(filtered);
  }

  Future<void> dispose() async {
    await _allListsController.close();
    await _activeListsController.close();
    for (final StreamController<List<ShoppingListItem>> controller
        in _itemsControllers.values) {
      await controller.close();
    }
  }
}

class _FakeProductRepository implements ProductRepository {
  final StreamController<List<Product>> _productsController =
      StreamController<List<Product>>.broadcast();

  @override
  Stream<List<Product>> watchActiveProducts() {
    Future<void>.microtask(() => _productsController.add(const <Product>[]));
    return _productsController.stream;
  }

  @override
  Future<List<ProductAlias>> findAliasesForProduct(String productId) async {
    return const <ProductAlias>[];
  }

  @override
  Future<List<ProductAlias>> findAliasesForProducts(
    List<String> productIds,
  ) async {
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

class _FakeInventoryRepository implements InventoryRepository {
  final StreamController<List<Inventory>> _inventoriesController =
      StreamController<List<Inventory>>.broadcast();
  final Map<String, StreamController<List<InventoryItem>>>
      _inventoryItemsControllers =
      <String, StreamController<List<InventoryItem>>>{};

  final List<Inventory> _inventories = <Inventory>[];

  void seedInventory(Inventory inventory) {
    _inventories.add(inventory);
  }

  @override
  Stream<List<Inventory>> watchAllInventories() {
    Future<void>.microtask(_emitInventories);
    return _inventoriesController.stream;
  }

  @override
  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId) {
    return _inventoryItemsControllers
        .putIfAbsent(
          inventoryId,
          () => StreamController<List<InventoryItem>>.broadcast(),
        )
        .stream;
  }

  @override
  Future<void> saveInventory(Inventory inventory) async {
    final int index =
        _inventories.indexWhere((Inventory item) => item.id == inventory.id);
    if (index >= 0) {
      _inventories[index] = inventory;
    } else {
      _inventories.add(inventory);
    }
    _emitInventories();
  }

  @override
  Future<void> deleteInventory(String id) async {
    final int index =
        _inventories.indexWhere((Inventory item) => item.id == id);
    if (index >= 0) {
      final Inventory existing = _inventories[index];
      _inventories[index] = existing.copyWith(
        deletedAt: DateTime.now(),
        updatedAt: DateTime.now(),
        version: existing.version + 1,
        syncStatus: 'pending_sync',
      );
      _emitInventories();
    }
  }

  @override
  Future<void> saveInventoryItem(InventoryItem item) async {}

  @override
  Future<void> deleteInventoryItem(String id) async {}

  @override
  Future<void> addInventoryEvent(InventoryEvent event) async {}

  void _emitInventories() {
    final List<Inventory> visible = _inventories
        .where((Inventory item) => item.deletedAt == null)
        .toList(growable: false);
    _inventoriesController.add(visible);
  }

  Future<void> dispose() async {
    await _inventoriesController.close();
    for (final StreamController<List<InventoryItem>> controller
        in _inventoryItemsControllers.values) {
      await controller.close();
    }
  }
}
