import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_category.dart';
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

abstract class ShoppingListRepository {
  Stream<List<ShoppingList>> watchActiveLists();

  Stream<List<ShoppingList>> watchAllLists();

  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId);

  Future<void> saveShoppingList(ShoppingList shoppingList);

  Future<void> saveShoppingListItem(ShoppingListItem item);

  Future<void> linkListToInventory({
    required String shoppingListId,
    required String inventoryId,
  });

  Future<void> unlinkListFromInventory({
    required String shoppingListId,
    required String inventoryId,
  });

  Stream<List<Inventory>> watchInventoriesForList(String shoppingListId);

  Stream<List<ShoppingList>> watchListsForInventory(String inventoryId);

  Future<void> deleteShoppingList(String id);

  Future<ShoppingListDraft?> readDraft(String shoppingListId);

  Future<void> saveDraft(ShoppingListDraft draft);

  Future<void> deleteDraft(String shoppingListId);

  Stream<List<ShoppingListCategory>> watchCategoriesForList(
    String shoppingListId,
  ) {
    return const Stream<List<ShoppingListCategory>>.empty();
  }

  Future<void> saveShoppingListCategory(ShoppingListCategory category) {
    throw UnsupportedError('saveShoppingListCategory is not implemented.');
  }

  Future<void> ensureUncategorizedCategoryForList(String shoppingListId) {
    return Future<void>.value();
  }

  Future<String?> createCategoryForList({
    required String shoppingListId,
    required String name,
  }) {
    return Future<String?>.value();
  }

  Future<void> restartList(String listId) {
    throw UnsupportedError('restartList is not implemented.');
  }

  Future<void> markListCompleted(String listId) {
    return Future<void>.value();
  }
}
