import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' as local_db;
import 'package:drift/drift.dart';

Inventory toDomainInventory(local_db.Inventory row) {
  return Inventory(
    id: row.id,
    name: row.name,
    description: row.description,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    syncStatus: row.syncStatus,
    version: row.version,
  );
}

InventoryItem toDomainInventoryItem(local_db.InventoryItem row) {
  return InventoryItem(
    id: row.id,
    inventoryId: row.inventoryId,
    productId: row.productId,
    rawName: row.rawName,
    quantityEstimated: row.quantityEstimated,
    unit: row.unit == null ? null : Unit.fromCode(row.unit!),
    status: _inventoryItemStatusFromDb(row.status),
    confidenceScore: row.confidenceScore,
    lastConfirmedAt: row.lastConfirmedAt,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    syncStatus: row.syncStatus,
    version: row.version,
  );
}

InventoryEvent toDomainInventoryEvent(local_db.InventoryEvent row) {
  return InventoryEvent(
    id: row.id,
    inventoryId: row.inventoryId,
    productId: row.productId,
    inventoryItemId: row.inventoryItemId,
    pantryItemId: row.inventoryItemId,
    eventType: _inventoryEventTypeFromDb(row.eventType),
    quantity: row.quantity,
    unit: row.unit == null ? null : Unit.fromCode(row.unit!),
    source: _inventoryEventSourceFromDb(row.source),
    occurredAt: row.occurredAt,
    createdAt: row.createdAt,
  );
}

local_db.InventoriesCompanion toInventoryCompanion(Inventory entity) {
  return local_db.InventoriesCompanion(
    id: Value(entity.id),
    name: Value(entity.name),
    description: Value(entity.description),
    createdAt: Value(entity.createdAt),
    updatedAt: Value(entity.updatedAt),
    deletedAt: Value(entity.deletedAt),
    syncStatus: Value(entity.syncStatus),
    version: Value(entity.version),
  );
}

local_db.InventoryItemsCompanion toInventoryItemCompanion(InventoryItem entity) {
  return local_db.InventoryItemsCompanion(
    id: Value(entity.id),
    inventoryId: Value(entity.inventoryId),
    productId: Value(entity.productId),
    rawName: Value(entity.rawName),
    quantityEstimated: Value(entity.quantityEstimated),
    unit: Value(entity.unit?.code),
    status: Value(_inventoryItemStatusToDb(entity.status)),
    confidenceScore: Value(entity.confidenceScore),
    lastConfirmedAt: Value(entity.lastConfirmedAt),
    createdAt: Value(entity.createdAt),
    updatedAt: Value(entity.updatedAt),
    deletedAt: Value(entity.deletedAt),
    syncStatus: Value(entity.syncStatus),
    version: Value(entity.version),
  );
}

local_db.InventoryEventsCompanion toInventoryEventCompanion(
  InventoryEvent entity,
) {
  return local_db.InventoryEventsCompanion(
    id: Value(entity.id),
    inventoryId: Value(entity.inventoryId),
    productId: Value(entity.productId),
    inventoryItemId: Value(entity.inventoryItemId ?? entity.pantryItemId),
    eventType: Value(_inventoryEventTypeToDb(entity.eventType)),
    quantity: Value(entity.quantity),
    unit: Value(entity.unit?.code),
    source: Value(_inventoryEventSourceToDb(entity.source)),
    occurredAt: Value(entity.occurredAt),
    createdAt: Value(entity.createdAt),
  );
}

InventoryItemStatus _inventoryItemStatusFromDb(String raw) {
  return switch (raw) {
    'unknown' => InventoryItemStatus.unknown,
    'in_stock' => InventoryItemStatus.inStock,
    'low' => InventoryItemStatus.low,
    'out' => InventoryItemStatus.out,
    _ => InventoryItemStatus.unknown,
  };
}

String _inventoryItemStatusToDb(InventoryItemStatus status) {
  return switch (status) {
    InventoryItemStatus.unknown => 'unknown',
    InventoryItemStatus.inStock => 'in_stock',
    InventoryItemStatus.low => 'low',
    InventoryItemStatus.out => 'out',
  };
}

// Backwards-compatible aliases to keep existing feature code compiling during migration.
InventoryItem toDomainPantryItem(local_db.InventoryItem row) =>
    toDomainInventoryItem(row);

local_db.InventoryItemsCompanion toPantryItemCompanion(InventoryItem entity) =>
    toInventoryItemCompanion(entity);

InventoryEventType _inventoryEventTypeFromDb(String raw) {
  return switch (raw) {
    'add' || 'purchase' => InventoryEventType.purchase,
    'consume' => InventoryEventType.consume,
    'adjust' => InventoryEventType.adjust,
    'confirm' || 'finish' => InventoryEventType.finish,
    'discard' => InventoryEventType.discard,
    _ => InventoryEventType.adjust,
  };
}

String _inventoryEventTypeToDb(InventoryEventType type) {
  return switch (type) {
    InventoryEventType.purchase => 'purchase',
    InventoryEventType.consume => 'consume',
    InventoryEventType.adjust => 'adjust',
    InventoryEventType.finish => 'finish',
    InventoryEventType.discard => 'discard',
  };
}

InventoryEventSource _inventoryEventSourceFromDb(String raw) {
  return switch (raw) {
    'manual' => InventoryEventSource.manual,
    'receipt' => InventoryEventSource.receipt,
    'system' => InventoryEventSource.system,
    _ => InventoryEventSource.manual,
  };
}

String _inventoryEventSourceToDb(InventoryEventSource source) {
  return switch (source) {
    InventoryEventSource.manual => 'manual',
    InventoryEventSource.receipt => 'receipt',
    InventoryEventSource.system => 'system',
  };
}
