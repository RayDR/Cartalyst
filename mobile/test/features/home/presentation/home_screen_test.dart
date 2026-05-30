import 'dart:async';

import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/features/home/presentation/home_screen.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show shoppingListRepositoryProvider;
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeShoppingListRepository repository;

  setUp(() {
    repository = FakeShoppingListRepository();
  });

  tearDown(() async {
    await repository.dispose();
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: <Override>[
        shoppingListRepositoryProvider.overrideWithValue(repository),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  group('HomeScreen', () {
    testWidgets('shows empty state when there are no lists', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Cartalyst'), findsOneWidget);
      expect(find.text('Create shopping list'), findsOneWidget);
      expect(
        find.text('Keep your shopping lists local, organized, and ready whenever you are.'),
        findsOneWidget,
      );
      expect(find.text('Recent lists'), findsNothing);
      expect(find.text('Compare package value'), findsNothing);
    });

    testWidgets('shows recent lists when data exists', (WidgetTester tester) async {
      repository.seedList(
        ShoppingList(
          id: 'list-1',
          name: 'Weekend groceries',
          status: ShoppingListStatus.active,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1, 10),
          syncStatus: 'local_only',
          version: 1,
        ),
      );
      repository.seedList(
        ShoppingList(
          id: 'list-2',
          name: 'Party snacks',
          status: ShoppingListStatus.active,
          createdAt: DateTime(2026, 1, 2),
          updatedAt: DateTime(2026, 1, 2, 10),
          syncStatus: 'local_only',
          version: 1,
        ),
      );
      repository.seedList(
        ShoppingList(
          id: 'list-3',
          name: 'House restock',
          status: ShoppingListStatus.active,
          createdAt: DateTime(2026, 1, 3),
          updatedAt: DateTime(2026, 1, 3, 10),
          syncStatus: 'local_only',
          version: 1,
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Recent lists'), findsOneWidget);
      expect(find.text('Create shopping list'), findsOneWidget);
      expect(find.text('Party snacks'), findsOneWidget);
      expect(find.text('House restock'), findsOneWidget);
      expect(find.text('Weekend groceries'), findsOneWidget);

      final Finder firstListCard = find.ancestor(
        of: find.text('House restock'),
        matching: find.byType(AppCard),
      );
      expect(firstListCard, findsOneWidget);
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
    Future<void>.microtask(() => controller.add(<ShoppingListItem>[]));
    return controller.stream;
  }

  @override
  Future<void> saveShoppingList(ShoppingList shoppingList) async {
    final int index = _lists.indexWhere((ShoppingList item) => item.id == shoppingList.id);
    if (index >= 0) {
      _lists[index] = shoppingList;
    } else {
      _lists.add(shoppingList);
    }
    _emitAllLists();
    _emitActiveLists();
  }

  @override
  Future<void> saveShoppingListItem(ShoppingListItem item) async {}

  @override
  Future<void> deleteShoppingList(String id) async {
    _lists.removeWhere((ShoppingList item) => item.id == id);
    _emitAllLists();
    _emitActiveLists();
  }

  void _emitAllLists() {
    final List<ShoppingList> lists = _lists
        .where((ShoppingList item) => item.deletedAt == null)
        .toList(growable: false)
      ..sort((ShoppingList a, ShoppingList b) => b.updatedAt.compareTo(a.updatedAt));
    _allListsController.add(lists);
  }

  void _emitActiveLists() {
    final List<ShoppingList> lists = _lists
        .where(
          (ShoppingList item) => item.deletedAt == null && item.status == ShoppingListStatus.active,
        )
        .toList(growable: false)
      ..sort((ShoppingList a, ShoppingList b) => b.updatedAt.compareTo(a.updatedAt));
    _activeListsController.add(lists);
  }

  Future<void> dispose() async {
    await _allListsController.close();
    await _activeListsController.close();
    for (final StreamController<List<ShoppingListItem>> controller in _itemsControllers.values) {
      await controller.close();
    }
  }
}
