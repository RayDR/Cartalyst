part of '../app_database.dart';

@DriftAccessor(tables: <Type>[Inventories, InventoryItems, InventoryEvents])
class PantryDao extends DatabaseAccessor<AppDatabase> with _$PantryDaoMixin {
  PantryDao(super.db);

  Stream<List<Inventory>> watchInventories() {
    final query = select(inventories)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($InventoriesTable)>[
        (tbl) => OrderingTerm.asc(tbl.name),
      ]);
    return query.watch();
  }

  Stream<List<InventoryItem>> watchInventoryItems() {
    final query = select(inventoryItems)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($InventoryItemsTable)>[
        (tbl) => OrderingTerm.asc(tbl.status),
        (tbl) => OrderingTerm.desc(tbl.updatedAt),
      ]);
    return query.watch();
  }

  Future<void> upsertInventory(InventoriesCompanion inventory) {
    return into(inventories).insertOnConflictUpdate(inventory);
  }

  Future<void> upsertInventoryItem(InventoryItemsCompanion item) {
    return into(inventoryItems).insertOnConflictUpdate(item);
  }

  Future<void> addInventoryEvent(InventoryEventsCompanion event) {
    return into(inventoryEvents).insert(event);
  }

  Stream<List<InventoryEvent>> watchInventoryEvents() {
    final query = select(inventoryEvents)
      ..orderBy(<OrderingTerm Function($InventoryEventsTable)>[
        (tbl) => OrderingTerm.desc(tbl.occurredAt),
      ]);
    return query.watch();
  }
}
