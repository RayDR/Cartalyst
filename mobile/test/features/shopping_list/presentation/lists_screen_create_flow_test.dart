import 'dart:async';

import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show shoppingListRepositoryProvider, uuidProvider;
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/presentation/lists_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

void main() {
  late _FakeShoppingListRepository shoppingRepository;

  setUp(() {
    shoppingRepository = _FakeShoppingListRepository();
  });

  tearDown(() async {
    await shoppingRepository.dispose();
  });

  testWidgets('create flow creates a Simple list', (WidgetTester tester) async {
    await tester.pumpWidget(
      _buildApp(
        overrides: <Override>[
          shoppingListRepositoryProvider.overrideWithValue(shoppingRepository),
          inventoryRepositoryProvider.overrideWithValue(
            _EmptyInventoryRepository(),
          ),
          uuidProvider.overrideWithValue(const Uuid()),
        ],
      ),
    );

    await tester.tap(find.text('New list'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Weekend groceries');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simple list'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create list'));
    await tester.pumpAndSettle();

    expect(shoppingRepository.savedLists, hasLength(1));
    expect(shoppingRepository.savedLists.first.name, 'Weekend groceries');
    expect(
        shoppingRepository.savedLists.first.listType, ShoppingListType.simple);
    expect(
      shoppingRepository.savedLists.first.routingMode,
      ShoppingListRoutingMode.none,
    );
    expect(shoppingRepository.uncategorizedSeededListIds, isEmpty);
  });

  testWidgets('create flow creates an Organized list with routing mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _buildApp(
        overrides: <Override>[
          shoppingListRepositoryProvider.overrideWithValue(shoppingRepository),
          inventoryRepositoryProvider.overrideWithValue(
            _EmptyInventoryRepository(),
          ),
          uuidProvider.overrideWithValue(const Uuid()),
        ],
      ),
    );

    await tester.tap(find.text('New list'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Master list');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Organized list'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Organize across inventories'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create list'));
    await tester.pumpAndSettle();

    expect(shoppingRepository.savedLists, hasLength(1));
    final ShoppingList saved = shoppingRepository.savedLists.first;
    expect(saved.name, 'Master list');
    expect(saved.listType, ShoppingListType.organized);
    expect(saved.routingMode, ShoppingListRoutingMode.categoryAsInventory);
    expect(shoppingRepository.uncategorizedSeededListIds, contains(saved.id));
  });
}

Widget _buildApp({required List<Override> overrides}) {
  final GoRouter router = GoRouter(
    initialLocation: '/lists',
    routes: <RouteBase>[
      GoRoute(
        path: '/lists',
        builder: (BuildContext context, GoRouterState state) {
          return const ListsScreen();
        },
      ),
      GoRoute(
        path: '/lists/:id',
        builder: (BuildContext context, GoRouterState state) {
          return Scaffold(
            body: Text('List ${state.pathParameters['id']}'),
          );
        },
      ),
    ],
  );

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(routerConfig: router),
  );
}

class _FakeShoppingListRepository extends ShoppingListRepository {
  final StreamController<List<ShoppingList>> _allListsController =
      StreamController<List<ShoppingList>>.broadcast();

  final List<ShoppingList> savedLists = <ShoppingList>[];
  final List<String> uncategorizedSeededListIds = <String>[];

  @override
  Stream<List<ShoppingList>> watchActiveLists() {
    Future<void>.microtask(() => _allListsController.add(savedLists));
    return _allListsController.stream;
  }

  @override
  Stream<List<ShoppingList>> watchAllLists() {
    Future<void>.microtask(() => _allListsController.add(savedLists));
    return _allListsController.stream;
  }

  @override
  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId) {
    return Stream<List<ShoppingListItem>>.value(const <ShoppingListItem>[]);
  }

  @override
  Future<void> saveShoppingList(ShoppingList shoppingList) async {
    savedLists.add(shoppingList);
    _allListsController.add(List<ShoppingList>.from(savedLists));
  }

  @override
  Future<void> saveShoppingListItem(ShoppingListItem item) async {}

  @override
  Future<void> linkListToInventory({
    required String shoppingListId,
    required String inventoryId,
  }) async {}

  @override
  Future<void> unlinkListFromInventory({
    required String shoppingListId,
    required String inventoryId,
  }) async {}

  @override
  Stream<List<Inventory>> watchInventoriesForList(String shoppingListId) {
    return Stream<List<Inventory>>.value(const <Inventory>[]);
  }

  @override
  Stream<List<ShoppingList>> watchListsForInventory(String inventoryId) {
    return Stream<List<ShoppingList>>.value(const <ShoppingList>[]);
  }

  @override
  Future<void> deleteShoppingList(String id) async {}

  @override
  Future<ShoppingListDraft?> readDraft(String shoppingListId) async {
    return null;
  }

  @override
  Future<void> saveDraft(ShoppingListDraft draft) async {}

  @override
  Future<void> deleteDraft(String shoppingListId) async {}

  @override
  Future<void> ensureUncategorizedCategoryForList(String shoppingListId) async {
    uncategorizedSeededListIds.add(shoppingListId);
  }

  Future<void> dispose() async {
    await _allListsController.close();
  }
}

class _EmptyInventoryRepository extends InventoryRepository {
  @override
  Stream<List<Inventory>> watchAllInventories() {
    return Stream<List<Inventory>>.value(const <Inventory>[]);
  }

  @override
  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId) {
    return Stream<List<InventoryItem>>.value(const <InventoryItem>[]);
  }

  @override
  Future<void> saveInventory(Inventory inventory) async {}

  @override
  Future<void> deleteInventory(String id) async {}

  @override
  Future<void> saveInventoryItem(InventoryItem item) async {}

  @override
  Future<void> deleteInventoryItem(String id) async {}

  @override
  Future<void> addInventoryEvent(InventoryEvent event) async {}
}
