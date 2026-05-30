import 'dart:async';

import 'package:cartalyst_mobile/app/app.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_controller.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show shoppingListRepositoryProvider;
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the home shell', (WidgetTester tester) async {
    final _TestShoppingListRepository repository =
        _TestShoppingListRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          homeDashboardControllerProvider.overrideWith(
            _TestHomeDashboardController.new,
          ),
          shoppingListRepositoryProvider.overrideWithValue(repository),
        ],
        child: const CartalystApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Lists'), findsOneWidget);
    expect(find.text('Inventories'), findsOneWidget);
    expect(find.text('Compare'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await repository.dispose();
  });
}

class _TestHomeDashboardController extends HomeDashboardController {
  @override
  HomeDashboardState build() {
    return const HomeDashboardState.initial();
  }
}

class _TestShoppingListRepository implements ShoppingListRepository {
  final StreamController<List<ShoppingList>> _allListsController =
      StreamController<List<ShoppingList>>.broadcast();
  final StreamController<List<ShoppingList>> _activeListsController =
      StreamController<List<ShoppingList>>.broadcast();

  @override
  Stream<List<ShoppingList>> watchActiveLists() {
    Future<void>.microtask(
      () => _activeListsController.add(const <ShoppingList>[]),
    );
    return _activeListsController.stream;
  }

  @override
  Stream<List<ShoppingList>> watchAllLists() {
    Future<void>.microtask(
      () => _allListsController.add(const <ShoppingList>[]),
    );
    return _allListsController.stream;
  }

  @override
  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId) {
    return Stream<List<ShoppingListItem>>.value(const <ShoppingListItem>[]);
  }

  @override
  Future<void> saveShoppingList(ShoppingList shoppingList) async {}

  @override
  Future<void> saveShoppingListItem(ShoppingListItem item) async {}

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

  Future<void> dispose() async {
    await _allListsController.close();
    await _activeListsController.close();
  }
}
