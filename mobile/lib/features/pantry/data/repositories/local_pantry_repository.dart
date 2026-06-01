import 'package:cartalyst_mobile/features/pantry/data/mappers/pantry_mapper.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/pantry/domain/repositories/pantry_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart'
    show AppDatabase, defaultInventoryId;

class LocalPantryRepository implements PantryRepository {
  LocalPantryRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Inventory>> watchInventories() {
    return _database.pantryDao.watchInventories().map(
          (rows) => rows.map(toDomainInventory).toList(growable: false),
        );
  }

  @override
  Stream<List<InventoryItem>> watchInventoryItems() {
    return _database.pantryDao.watchInventoryItems().map(
          (rows) => rows.map(toDomainInventoryItem).toList(growable: false),
        );
  }

  @override
  Stream<List<InventoryEvent>> watchInventoryEvents() {
    return _database.pantryDao.watchInventoryEvents().map(
          (rows) => rows.map(toDomainInventoryEvent).toList(growable: false),
        );
  }

  @override
  Future<void> saveInventory(Inventory inventory) {
    return _database.pantryDao.upsertInventory(toInventoryCompanion(inventory));
  }

  @override
  Future<String> ensureDefaultInventoryId() async {
    final List<Inventory> current = await watchInventories().first;
    if (current.isNotEmpty) {
      return current.first.id;
    }

    final DateTime now = DateTime.now();
    final Inventory defaultInventory = Inventory(
      id: defaultInventoryId,
      name: 'Pantry',
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending_sync',
      version: 1,
    );

    await saveInventory(defaultInventory);
    return defaultInventory.id;
  }

  @override
  Future<void> saveInventoryItem(InventoryItem item) {
    return _database.pantryDao
        .upsertInventoryItem(toInventoryItemCompanion(item));
  }

  @override
  Future<void> addInventoryEvent(InventoryEvent event) {
    return _database.pantryDao
        .addInventoryEvent(toInventoryEventCompanion(event));
  }
}
