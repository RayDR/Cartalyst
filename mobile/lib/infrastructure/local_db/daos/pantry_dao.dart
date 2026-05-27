part of '../app_database.dart';

@DriftAccessor(tables: <Type>[PantryItems, InventoryEvents])
class PantryDao extends DatabaseAccessor<AppDatabase> with _$PantryDaoMixin {
  PantryDao(super.db);

  Stream<List<PantryItem>> watchPantryItems() {
    final query = select(pantryItems)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($PantryItemsTable)>[
        (tbl) => OrderingTerm.asc(tbl.status),
        (tbl) => OrderingTerm.desc(tbl.updatedAt),
      ]);
    return query.watch();
  }

  Future<void> upsertPantryItem(PantryItemsCompanion item) {
    return into(pantryItems).insertOnConflictUpdate(item);
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
