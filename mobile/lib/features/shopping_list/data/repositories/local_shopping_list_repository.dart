import 'package:cartalyst_mobile/features/shopping_list/data/mappers/shopping_list_mapper.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart' as domain;
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart' as domain;
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';

class LocalShoppingListRepository implements ShoppingListRepository {
  LocalShoppingListRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<domain.ShoppingList>> watchActiveLists() {
    return _database.shoppingListsDao.watchActiveLists().map(
          (rows) => rows.map(toDomainShoppingList).toList(growable: false),
        );
  }

  @override
  Stream<List<domain.ShoppingListItem>> watchItemsForList(String shoppingListId) {
    return _database.shoppingListsDao.watchItemsForList(shoppingListId).map(
          (rows) => rows.map(toDomainShoppingListItem).toList(growable: false),
        );
  }

  @override
  Stream<List<domain.ShoppingList>> watchAllLists() {
    return _database.shoppingListsDao.watchAllLists().map(
          (rows) => rows.map(toDomainShoppingList).toList(growable: false),
        );
  }

  @override
  Future<void> saveShoppingList(domain.ShoppingList shoppingList) {
    return _database.shoppingListsDao
        .upsertShoppingList(toShoppingListCompanion(shoppingList));
  }

  @override
  Future<void> saveShoppingListItem(domain.ShoppingListItem item) {
    return _database.shoppingListsDao.upsertListItem(
      toShoppingListItemCompanion(item),
    );
  }

  @override
  Future<void> deleteShoppingList(String id) {
    return _database.shoppingListsDao.softDeleteShoppingList(id);
  }
}
