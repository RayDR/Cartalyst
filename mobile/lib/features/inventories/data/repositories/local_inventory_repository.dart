import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/data/mappers/pantry_mapper.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' show AppDatabase;

class LocalInventoryRepository implements InventoryRepository {
  LocalInventoryRepository(this._database);

  final AppDatabase _database;

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
    return _database.pantryDao.upsertInventoryItem(toInventoryItemCompanion(item));
  }

  @override
  Future<void> deleteInventoryItem(String id) {
    return _database.pantryDao.softDeleteInventoryItem(id);
  }

  @override
  Future<void> addInventoryEvent(InventoryEvent event) {
    return _database.pantryDao.addInventoryEvent(toInventoryEventCompanion(event));
  }
}
