import 'dart:async';

import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/pantry/data/repositories/local_pantry_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';
import 'package:cartalyst_mobile/features/pantry/domain/repositories/pantry_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/data/repositories/local_shopping_list_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' show AppDatabase;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final homeShoppingListRepositoryProvider = Provider<ShoppingListRepository>((Ref ref) {
  return LocalShoppingListRepository(ref.watch(homeDatabaseProvider));
});

final homePantryRepositoryProvider = Provider<PantryRepository>((Ref ref) {
  return LocalPantryRepository(ref.watch(homeDatabaseProvider));
});

final homeDashboardControllerProvider =
    NotifierProvider<HomeDashboardController, HomeDashboardState>(
      HomeDashboardController.new,
    );

class HomeDashboardController extends Notifier<HomeDashboardState> {
  late final ShoppingListRepository _shoppingListRepository;
  late final PantryRepository _pantryRepository;

  StreamSubscription<List<ShoppingList>>? _listsSubscription;
  StreamSubscription<List<ShoppingListItem>>? _itemsSubscription;
  StreamSubscription<List<PantryItem>>? _pantrySubscription;

  @override
  HomeDashboardState build() {
    _shoppingListRepository = ref.watch(homeShoppingListRepositoryProvider);
    _pantryRepository = ref.watch(homePantryRepositoryProvider);

    ref.onDispose(() {
      _listsSubscription?.cancel();
      _itemsSubscription?.cancel();
      _pantrySubscription?.cancel();
    });

    _subscribeShoppingList();
    _subscribePantry();

    return const HomeDashboardState.initial();
  }

  void _subscribeShoppingList() {
    _listsSubscription?.cancel();
    _listsSubscription = _shoppingListRepository.watchActiveLists().listen((
      List<ShoppingList> lists,
    ) {
      if (lists.isEmpty) {
        state = state.copyWith(
          clearActiveShoppingList: true,
          pendingCount: 0,
          purchasedCount: 0,
          skippedCount: 0,
          rememberToBuyItems: const <ShoppingListItem>[],
        );
        _itemsSubscription?.cancel();
        return;
      }

      final ShoppingList active = lists.first;
      state = state.copyWith(activeShoppingList: active);

      _itemsSubscription?.cancel();
      _itemsSubscription = _shoppingListRepository
          .watchItemsForList(active.id)
          .listen((List<ShoppingListItem> items) {
            final List<ShoppingListItem> pending = items
                .where((ShoppingListItem item) =>
                item.status == ShoppingListItemStatus.pending,
              )
                .toList(growable: false);
            final int purchasedCount = items
                .where((ShoppingListItem item) =>
                item.status == ShoppingListItemStatus.purchased,
              )
                .length;
            final int skippedCount = items
                .where((ShoppingListItem item) =>
                item.status == ShoppingListItemStatus.skipped,
              )
                .length;

            state = state.copyWith(
              pendingCount: pending.length,
              purchasedCount: purchasedCount,
              skippedCount: skippedCount,
              rememberToBuyItems: pending.take(5).toList(growable: false),
            );
          });
    });
  }

  void _subscribePantry() {
    _pantrySubscription?.cancel();
    _pantrySubscription = _pantryRepository.watchInventoryItems().listen((
      List<PantryItem> items,
    ) {
      final List<PantryItem> low = items
          .where((PantryItem item) => item.status == PantryItemStatus.low)
          .toList(growable: false);

      final List<PantryItem> recent = items.toList(growable: false)
        ..sort((PantryItem a, PantryItem b) => b.updatedAt.compareTo(a.updatedAt));

      state = state.copyWith(
        runningLowItems: low.take(5).toList(growable: false),
        recentlyUpdatedPantryItems: recent.take(5).toList(growable: false),
        greeting: _greetingForNow(),
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
