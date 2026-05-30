import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';

abstract interface class ShoppingListRepository {
  Stream<List<ShoppingList>> watchActiveLists();

  Stream<List<ShoppingList>> watchAllLists();

  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId);

  Future<void> saveShoppingList(ShoppingList shoppingList);

  Future<void> saveShoppingListItem(ShoppingListItem item);

  Future<void> deleteShoppingList(String id);
}
