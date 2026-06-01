import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';

class HomeDashboardState {
  const HomeDashboardState({
    required this.greeting,
    required this.identity,
    required this.lists,
    required this.inventories,
    required this.categories,
  });

  const HomeDashboardState.initial()
      : greeting = 'Hello',
        identity = 'Your smart shopping analyst',
        lists = const <ShoppingList>[],
        inventories = const <Inventory>[],
        categories = const <Category>[];

  final String greeting;
  final String identity;
  final List<ShoppingList> lists;
  final List<Inventory> inventories;
  final List<Category> categories;

  HomeDashboardState copyWith({
    String? greeting,
    String? identity,
    List<ShoppingList>? lists,
    List<Inventory>? inventories,
    List<Category>? categories,
  }) {
    return HomeDashboardState(
      greeting: greeting ?? this.greeting,
      identity: identity ?? this.identity,
      lists: lists ?? this.lists,
      inventories: inventories ?? this.inventories,
      categories: categories ?? this.categories,
    );
  }
}
