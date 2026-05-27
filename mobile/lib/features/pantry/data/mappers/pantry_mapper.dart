import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart' as domain;
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart' as domain;
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' as local_db;
import 'package:drift/drift.dart';

domain.PantryItem toDomainPantryItem(local_db.PantryItem row) {
  return domain.PantryItem(
    id: row.id,
    productId: row.productId,
    rawName: row.rawName,
    quantityEstimated: row.quantityEstimated,
    unit: row.unit == null ? null : Unit.fromCode(row.unit!),
    status: _pantryStatusFromDb(row.status),
    confidenceScore: row.confidenceScore,
    lastConfirmedAt: row.lastConfirmedAt,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    syncStatus: row.syncStatus,
    version: row.version,
  );
}

domain.InventoryEvent toDomainInventoryEvent(local_db.InventoryEvent row) {
  return domain.InventoryEvent(
    id: row.id,
    productId: row.productId,
    pantryItemId: row.pantryItemId,
    eventType: _inventoryEventTypeFromDb(row.eventType),
    quantity: row.quantity,
    unit: row.unit == null ? null : Unit.fromCode(row.unit!),
    source: _inventoryEventSourceFromDb(row.source),
    occurredAt: row.occurredAt,
    createdAt: row.createdAt,
  );
}

local_db.PantryItemsCompanion toPantryItemCompanion(domain.PantryItem entity) {
  return local_db.PantryItemsCompanion(
    id: Value(entity.id),
    productId: Value(entity.productId),
    rawName: Value(entity.rawName),
    quantityEstimated: Value(entity.quantityEstimated),
    unit: Value(entity.unit?.code),
    status: Value(_pantryStatusToDb(entity.status)),
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
  domain.InventoryEvent entity,
) {
  return local_db.InventoryEventsCompanion(
    id: Value(entity.id),
    productId: Value(entity.productId),
    pantryItemId: Value(entity.pantryItemId),
    eventType: Value(_inventoryEventTypeToDb(entity.eventType)),
    quantity: Value(entity.quantity),
    unit: Value(entity.unit?.code),
    source: Value(_inventoryEventSourceToDb(entity.source)),
    occurredAt: Value(entity.occurredAt),
    createdAt: Value(entity.createdAt),
  );
}

domain.PantryItemStatus _pantryStatusFromDb(String raw) {
  return switch (raw) {
    'unknown' => domain.PantryItemStatus.unknown,
    'in_stock' => domain.PantryItemStatus.inStock,
    'low' => domain.PantryItemStatus.low,
    'out' => domain.PantryItemStatus.out,
    _ => domain.PantryItemStatus.unknown,
  };
}

String _pantryStatusToDb(domain.PantryItemStatus status) {
  return switch (status) {
    domain.PantryItemStatus.unknown => 'unknown',
    domain.PantryItemStatus.inStock => 'in_stock',
    domain.PantryItemStatus.low => 'low',
    domain.PantryItemStatus.out => 'out',
  };
}

domain.InventoryEventType _inventoryEventTypeFromDb(String raw) {
  return switch (raw) {
    'add' => domain.InventoryEventType.add,
    'consume' => domain.InventoryEventType.consume,
    'adjust' => domain.InventoryEventType.adjust,
    'confirm' => domain.InventoryEventType.confirm,
    'discard' => domain.InventoryEventType.discard,
    _ => domain.InventoryEventType.adjust,
  };
}

String _inventoryEventTypeToDb(domain.InventoryEventType type) {
  return switch (type) {
    domain.InventoryEventType.add => 'add',
    domain.InventoryEventType.consume => 'consume',
    domain.InventoryEventType.adjust => 'adjust',
    domain.InventoryEventType.confirm => 'confirm',
    domain.InventoryEventType.discard => 'discard',
  };
}

domain.InventoryEventSource _inventoryEventSourceFromDb(String raw) {
  return switch (raw) {
    'manual' => domain.InventoryEventSource.manual,
    'receipt' => domain.InventoryEventSource.receipt,
    'system' => domain.InventoryEventSource.system,
    _ => domain.InventoryEventSource.manual,
  };
}

String _inventoryEventSourceToDb(domain.InventoryEventSource source) {
  return switch (source) {
    domain.InventoryEventSource.manual => 'manual',
    domain.InventoryEventSource.receipt => 'receipt',
    domain.InventoryEventSource.system => 'system',
  };
}
