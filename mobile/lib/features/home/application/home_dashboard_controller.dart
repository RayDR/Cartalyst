import 'dart:async';

import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show appDatabaseProvider;
import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeDashboardControllerProvider =
    NotifierProvider<HomeDashboardController, HomeDashboardState>(
      HomeDashboardController.new,
    );

class HomeDashboardController extends Notifier<HomeDashboardState> {
  late final AppDatabase _database;

  StreamSubscription<List<ShoppingList>>? _listsSubscription;
  StreamSubscription<List<Inventory>>? _inventoriesSubscription;
  StreamSubscription<List<Category>>? _categoriesSubscription;

  @override
  HomeDashboardState build() {
    _database = ref.watch(appDatabaseProvider);

    ref.onDispose(() {
      _listsSubscription?.cancel();
      _inventoriesSubscription?.cancel();
      _categoriesSubscription?.cancel();
    });

    _subscribeLists();
    _subscribeInventories();
    _subscribeCategories();

    return const HomeDashboardState.initial();
  }

  void _subscribeLists() {
    _listsSubscription?.cancel();
    final query = _database.select(_database.shoppingLists)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($ShoppingListsTable)>[
        (tbl) => OrderingTerm.desc(tbl.updatedAt),
      ]);
    _listsSubscription = query.watch().listen((List<ShoppingList> lists) {
      state = state.copyWith(
        greeting: _greetingForNow(),
        lists: lists,
      );
    });
  }

  void _subscribeInventories() {
    _inventoriesSubscription?.cancel();
    final query = _database.select(_database.inventories)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($InventoriesTable)>[
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);
    _inventoriesSubscription =
        query.watch().listen((List<Inventory> inventories) {
      state = state.copyWith(
        greeting: _greetingForNow(),
        inventories: inventories,
      );
    });
  }

  void _subscribeCategories() {
    _categoriesSubscription?.cancel();
    final query = _database.select(_database.categories)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($CategoriesTable)>[
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);
    _categoriesSubscription =
        query.watch().listen((List<Category> categories) {
      state = state.copyWith(
        greeting: _greetingForNow(),
        categories: categories,
      );
    });
  }

  String _greetingForNow() {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 18) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }
}
