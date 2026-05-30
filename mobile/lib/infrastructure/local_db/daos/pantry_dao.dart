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

  Stream<List<Inventory>> watchAllInventoriesByRecent() {
    final query = select(inventories)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($InventoriesTable)>[
        (tbl) => OrderingTerm.desc(tbl.updatedAt),
      ]);
    return query.watch();
  }

  Stream<List<InventoryItem>> watchInventoryItemsForInventory(
    String inventoryId,
  ) {
    final query = select(inventoryItems)
      ..where(
        (tbl) =>
            tbl.deletedAt.isNull() & tbl.inventoryId.equals(inventoryId),
      )
      ..orderBy(<OrderingTerm Function($InventoryItemsTable)>[
        (tbl) => OrderingTerm.asc(tbl.status),
        (tbl) => OrderingTerm.desc(tbl.updatedAt),
      ]);
    return query.watch();
  }

  Future<void> softDeleteInventory(String id) async {
    final DateTime now = DateTime.now();
    await (update(inventories)..where((tbl) => tbl.id.equals(id))).write(
      InventoriesCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> softDeleteInventoryItem(String id) async {
    final DateTime now = DateTime.now();
    await (update(inventoryItems)..where((tbl) => tbl.id.equals(id))).write(
      InventoryItemsCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
