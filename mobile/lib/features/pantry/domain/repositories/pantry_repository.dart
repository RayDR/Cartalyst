import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';

abstract interface class PantryRepository {
  Stream<List<Inventory>> watchInventories();

  Stream<List<InventoryItem>> watchInventoryItems();

  Stream<List<InventoryEvent>> watchInventoryEvents();

  Future<void> saveInventory(Inventory inventory);

  Future<String> ensureDefaultInventoryId();

  Future<void> saveInventoryItem(InventoryItem item);

  Future<void> addInventoryEvent(InventoryEvent event);
}
