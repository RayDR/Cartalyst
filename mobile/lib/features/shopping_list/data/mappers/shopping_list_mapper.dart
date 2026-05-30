import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart' as domain;
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart' as domain;
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' as local_db;
import 'package:drift/drift.dart';

domain.ShoppingList toDomainShoppingList(local_db.ShoppingList row) {
  return domain.ShoppingList(
    id: row.id,
    inventoryId: row.inventoryId,
    name: row.name,
    status: _shoppingListStatusFromDb(row.status),
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    syncStatus: row.syncStatus,
    version: row.version,
  );
}

domain.ShoppingListItem toDomainShoppingListItem(local_db.ShoppingListItem row) {
  return domain.ShoppingListItem(
    id: row.id,
    shoppingListId: row.shoppingListId,
    productId: row.productId,
    rawText: row.rawText,
    quantity: row.quantity,
    unit: row.unit == null ? null : Unit.fromCode(row.unit!),
    status: _shoppingListItemStatusFromDb(row.status),
    source: _shoppingListItemSourceFromDb(row.source),
    priorityScore: row.priorityScore,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    purchasedAt: row.purchasedAt,
    deletedAt: row.deletedAt,
    syncStatus: row.syncStatus,
    version: row.version,
  );
}

local_db.ShoppingListsCompanion toShoppingListCompanion(domain.ShoppingList entity) {
  return local_db.ShoppingListsCompanion(
    id: Value(entity.id),
    inventoryId: Value(entity.inventoryId),
    name: Value(entity.name),
    status: Value(entity.status.name),
    createdAt: Value(entity.createdAt),
    updatedAt: Value(entity.updatedAt),
    deletedAt: Value(entity.deletedAt),
    syncStatus: Value(entity.syncStatus),
    version: Value(entity.version),
  );
}

local_db.ShoppingListItemsCompanion toShoppingListItemCompanion(
  domain.ShoppingListItem entity,
) {
  return local_db.ShoppingListItemsCompanion(
    id: Value(entity.id),
    shoppingListId: Value(entity.shoppingListId),
    productId: Value(entity.productId),
    rawText: Value(entity.rawText),
    quantity: Value(entity.quantity),
    unit: Value(entity.unit?.code),
    status: Value(entity.status.name),
    source: Value(entity.source.name),
    priorityScore: Value(entity.priorityScore),
    createdAt: Value(entity.createdAt),
    updatedAt: Value(entity.updatedAt),
    purchasedAt: Value(entity.purchasedAt),
    deletedAt: Value(entity.deletedAt),
    syncStatus: Value(entity.syncStatus),
    version: Value(entity.version),
  );
}

domain.ShoppingListStatus _shoppingListStatusFromDb(String raw) {
  return switch (raw) {
    'active' => domain.ShoppingListStatus.active,
    'completed' => domain.ShoppingListStatus.completed,
    'archived' => domain.ShoppingListStatus.archived,
    _ => domain.ShoppingListStatus.active,
  };
}

domain.ShoppingListItemStatus _shoppingListItemStatusFromDb(String raw) {
  return switch (raw) {
    'pending' => domain.ShoppingListItemStatus.pending,
    'purchased' => domain.ShoppingListItemStatus.purchased,
    'skipped' => domain.ShoppingListItemStatus.skipped,
    _ => domain.ShoppingListItemStatus.pending,
  };
}

domain.ShoppingListItemSource _shoppingListItemSourceFromDb(String raw) {
  return switch (raw) {
    'manual' => domain.ShoppingListItemSource.manual,
    'suggestion' => domain.ShoppingListItemSource.suggestion,
    'import' => domain.ShoppingListItemSource.import,
    _ => domain.ShoppingListItemSource.manual,
  };
}
