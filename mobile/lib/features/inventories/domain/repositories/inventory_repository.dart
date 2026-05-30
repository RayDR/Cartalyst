import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';

abstract interface class InventoryRepository {
  Stream<List<Inventory>> watchAllInventories();

  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId);

  Future<void> saveInventory(Inventory inventory);

  Future<void> deleteInventory(String id);

  Future<void> saveInventoryItem(InventoryItem item);

  Future<void> deleteInventoryItem(String id);

  Future<void> addInventoryEvent(InventoryEvent event);
}
