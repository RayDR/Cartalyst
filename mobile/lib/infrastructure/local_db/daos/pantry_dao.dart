part of '../app_database.dart';

@DriftAccessor(
  tables: <Type>[
    Categories,
    Inventories,
    InventoryCategories,
    InventoryItems,
    InventoryEvents,
  ],
)
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

  Future<void> upsertCategory(CategoriesCompanion category) {
    return into(categories).insertOnConflictUpdate(category);
  }

  Future<void> upsertInventoryCategory(InventoryCategoriesCompanion category) {
    return into(inventoryCategories).insertOnConflictUpdate(category);
  }

  Future<void> upsertInventoryItem(InventoryItemsCompanion item) {
    return into(inventoryItems).insertOnConflictUpdate(item);
  }

  Future<void> addInventoryEvent(InventoryEventsCompanion event) {
    return into(inventoryEvents).insert(event);
  }

  Future<int> nextInventoryCategorySortOrder(String inventoryId) async {
    final Expression<int> maxOrder = inventoryCategories.sortOrder.max();
    final TypedResult row = await (selectOnly(inventoryCategories)
          ..addColumns(<Expression<Object>>[maxOrder])
          ..where(
            inventoryCategories.inventoryId.equals(inventoryId) &
                inventoryCategories.deletedAt.isNull(),
          ))
        .getSingle();
    final int currentMax = row.read(maxOrder) ?? -1;
    return currentMax + 1;
  }

  Future<String?> findUncategorizedInventoryCategoryId(
    String inventoryId,
  ) async {
    final query = select(inventoryCategories).join([
      innerJoin(
        categories,
        categories.id.equalsExp(inventoryCategories.categoryId) &
            categories.deletedAt.isNull(),
      ),
    ])
      ..where(
        inventoryCategories.inventoryId.equals(inventoryId) &
            inventoryCategories.deletedAt.isNull() &
            (categories.name.equals('Uncategorized') |
                categories.name.equals('uncategorized')),
      )
      ..limit(1);

    final List<TypedResult> rows = await query.get();
    if (rows.isEmpty) {
      return null;
    }
    return rows.first.readTable(inventoryCategories).id;
  }

  Stream<List<TypedResult>> watchInventoryCategoriesWithDetails(
    String inventoryId,
  ) {
    final query = select(inventoryCategories).join([
      innerJoin(
        categories,
        categories.id.equalsExp(inventoryCategories.categoryId) &
            categories.deletedAt.isNull(),
      ),
    ])
      ..where(
        inventoryCategories.inventoryId.equals(inventoryId) &
            inventoryCategories.deletedAt.isNull(),
      )
      ..orderBy(<OrderingTerm>[
        OrderingTerm.asc(inventoryCategories.sortOrder),
        OrderingTerm.asc(categories.name),
      ]);

    return query.watch();
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
        (tbl) => tbl.deletedAt.isNull() & tbl.inventoryId.equals(inventoryId),
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
