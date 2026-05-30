import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';

class ShoppingListDraft {
  const ShoppingListDraft({
    required this.shoppingListId,
    required this.name,
    required this.items,
    required this.updatedAt,
  });

  final String shoppingListId;
  final String name;
  final List<ShoppingListItem> items;
  final DateTime updatedAt;
}

abstract interface class ShoppingListRepository {
  Stream<List<ShoppingList>> watchActiveLists();

  Stream<List<ShoppingList>> watchAllLists();

  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId);

  Future<void> saveShoppingList(ShoppingList shoppingList);

  Future<void> saveShoppingListItem(ShoppingListItem item);

  Future<void> deleteShoppingList(String id);

  Future<ShoppingListDraft?> readDraft(String shoppingListId);

  Future<void> saveDraft(ShoppingListDraft draft);

  Future<void> deleteDraft(String shoppingListId);
}
