import 'package:cartalyst_mobile/features/pantry/domain/entities/category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';

abstract class InventoryRepository {
  Stream<List<Inventory>> watchAllInventories();

  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId);

  Future<void> saveInventory(Inventory inventory);

  Future<void> deleteInventory(String id);

  Future<void> saveInventoryItem(InventoryItem item);

  Future<void> deleteInventoryItem(String id);

  Future<void> addInventoryEvent(InventoryEvent event);

  Stream<List<InventoryCategory>> watchInventoryCategories(String inventoryId) {
    return const Stream<List<InventoryCategory>>.empty();
  }

  Future<void> saveCategory(Category category) {
    throw UnsupportedError('saveCategory is not implemented.');
  }

  Future<void> saveInventoryCategory(InventoryCategory category) {
    throw UnsupportedError('saveInventoryCategory is not implemented.');
  }

  Future<String?> findUncategorizedInventoryCategoryId(String inventoryId) {
    return Future<String?>.value();
  }

  Future<String> ensureUncategorizedInventoryCategory(String inventoryId) {
    throw UnsupportedError(
      'ensureUncategorizedInventoryCategory is not implemented.',
    );
  }
}
