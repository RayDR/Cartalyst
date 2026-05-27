import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';

class HomeDashboardState {
  const HomeDashboardState({
    required this.greeting,
    required this.identity,
    required this.activeShoppingList,
    required this.pendingCount,
    required this.purchasedCount,
    required this.skippedCount,
    required this.rememberToBuyItems,
    required this.runningLowItems,
    required this.recentlyUpdatedPantryItems,
  });

  const HomeDashboardState.initial()
    : greeting = 'Hello',
      identity = 'Your smart shopping analyst',
      activeShoppingList = null,
      pendingCount = 0,
      purchasedCount = 0,
      skippedCount = 0,
      rememberToBuyItems = const <ShoppingListItem>[],
      runningLowItems = const <PantryItem>[],
      recentlyUpdatedPantryItems = const <PantryItem>[];

  final String greeting;
  final String identity;
  final ShoppingList? activeShoppingList;
  final int pendingCount;
  final int purchasedCount;
  final int skippedCount;
  final List<ShoppingListItem> rememberToBuyItems;
  final List<PantryItem> runningLowItems;
  final List<PantryItem> recentlyUpdatedPantryItems;

  HomeDashboardState copyWith({
    String? greeting,
    String? identity,
    ShoppingList? activeShoppingList,
    bool clearActiveShoppingList = false,
    int? pendingCount,
    int? purchasedCount,
    int? skippedCount,
    List<ShoppingListItem>? rememberToBuyItems,
    List<PantryItem>? runningLowItems,
    List<PantryItem>? recentlyUpdatedPantryItems,
  }) {
    return HomeDashboardState(
      greeting: greeting ?? this.greeting,
      identity: identity ?? this.identity,
      activeShoppingList: clearActiveShoppingList
          ? null
          : (activeShoppingList ?? this.activeShoppingList),
      pendingCount: pendingCount ?? this.pendingCount,
      purchasedCount: purchasedCount ?? this.purchasedCount,
      skippedCount: skippedCount ?? this.skippedCount,
      rememberToBuyItems: rememberToBuyItems ?? this.rememberToBuyItems,
      runningLowItems: runningLowItems ?? this.runningLowItems,
      recentlyUpdatedPantryItems:
          recentlyUpdatedPantryItems ?? this.recentlyUpdatedPantryItems,
    );
  }
}
