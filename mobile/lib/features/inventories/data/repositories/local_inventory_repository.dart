import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/data/mappers/pantry_mapper.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart'
    hide Category, Inventory, InventoryCategory, InventoryEvent, InventoryItem;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:uuid/uuid.dart';

class LocalInventoryRepository implements InventoryRepository {
  LocalInventoryRepository(this._database);

  final AppDatabase _database;
  static const Uuid _uuid = Uuid();

  @override
  Stream<List<Inventory>> watchAllInventories() {
    return _database.pantryDao.watchAllInventoriesByRecent().map(
          (rows) => rows.map(toDomainInventory).toList(growable: false),
        );
  }

  @override
  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId) {
    return _database.pantryDao
        .watchInventoryItemsForInventory(inventoryId)
        .map((rows) => rows.map(toDomainInventoryItem).toList(growable: false));
  }

  @override
  Future<void> saveInventory(Inventory inventory) {
    return _database.pantryDao.upsertInventory(toInventoryCompanion(inventory));
  }

  @override
  Future<void> deleteInventory(String id) {
    return _database.pantryDao.softDeleteInventory(id);
  }

  @override
  Future<void> saveInventoryItem(InventoryItem item) {
    return _saveInventoryItemWithFallback(item);
  }

  Future<void> _saveInventoryItemWithFallback(InventoryItem item) async {
    final String categoryId = item.inventoryCategoryId ??
        await ensureUncategorizedInventoryCategory(item.inventoryId);
    await _database.pantryDao.upsertInventoryItem(
      toInventoryItemCompanion(
        item.copyWith(inventoryCategoryId: categoryId),
      ),
    );
  }

  @override
  Future<void> deleteInventoryItem(String id) {
    return _database.pantryDao.softDeleteInventoryItem(id);
  }

  @override
  Future<void> addInventoryEvent(InventoryEvent event) {
    return _database.pantryDao
        .addInventoryEvent(toInventoryEventCompanion(event));
  }

  @override
  Stream<List<InventoryCategory>> watchInventoryCategories(String inventoryId) {
    return _database.pantryDao
        .watchInventoryCategoriesWithDetails(inventoryId)
        .map(
          (List<TypedResult> rows) => rows
              .map(
                (TypedResult row) => toDomainInventoryCategory(
                  link: row.readTable(_database.pantryDao.inventoryCategories),
                  category: row.readTable(_database.pantryDao.categories),
                ),
              )
              .toList(growable: false),
        );
  }

  @override
  Future<void> saveCategory(Category category) {
    return _database.pantryDao.upsertCategory(toCategoryCompanion(category));
  }

  @override
  Future<void> saveInventoryCategory(InventoryCategory category) {
    return _database.pantryDao.upsertInventoryCategory(
      toInventoryCategoryCompanion(category),
    );
  }

  @override
  Future<String?> findUncategorizedInventoryCategoryId(String inventoryId) {
    return _database.pantryDao
        .findUncategorizedInventoryCategoryId(inventoryId);
  }

  @override
  Future<String> ensureUncategorizedInventoryCategory(
    String inventoryId,
  ) async {
    debugPrint(
      '[LocalInventoryRepository] ensureUncategorizedInventoryCategory start inventoryId=$inventoryId',
    );
    try {
      final String? existing =
          await _database.pantryDao.findUncategorizedInventoryCategoryId(
        inventoryId,
      );
      if (existing != null) {
        debugPrint(
          '[LocalInventoryRepository] ensureUncategorizedInventoryCategory already exists id=$existing',
        );
        return existing;
      }

      final DateTime now = DateTime.now();
      final String categoryId = _uuid.v4();
      final String inventoryCategoryId = _uuid.v4();
      final int sortOrder =
          await _database.pantryDao.nextInventoryCategorySortOrder(inventoryId);

      await _database.pantryDao.upsertCategory(
        CategoriesCompanion.insert(
          id: categoryId,
          name: 'Uncategorized',
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value(null),
          syncStatus: const Value('pending_sync'),
          version: const Value(1),
        ),
      );

      await _database.pantryDao.upsertInventoryCategory(
        InventoryCategoriesCompanion.insert(
          id: inventoryCategoryId,
          inventoryId: inventoryId,
          categoryId: categoryId,
          sortOrder: Value(sortOrder),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value(null),
        ),
      );

      debugPrint(
        '[LocalInventoryRepository] ensureUncategorizedInventoryCategory success inventoryCategoryId=$inventoryCategoryId',
      );
      return inventoryCategoryId;
    } catch (error, stackTrace) {
      debugPrint(
        '[LocalInventoryRepository] ensureUncategorizedInventoryCategory FAILED inventoryId=$inventoryId error=$error',
      );
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }
}
