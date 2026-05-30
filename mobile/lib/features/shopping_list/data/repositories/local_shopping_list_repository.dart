import 'dart:convert';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/shopping_list/data/mappers/shopping_list_mapper.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart'
    as domain;
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart'
    as domain;
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:cartalyst_mobile/features/pantry/data/mappers/pantry_mapper.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart'
    as inventory_domain;
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';
import 'package:uuid/uuid.dart';

class LocalShoppingListRepository implements ShoppingListRepository {
  LocalShoppingListRepository(this._database);

  final AppDatabase _database;
  static const Uuid _uuid = Uuid();

  @override
  Stream<List<domain.ShoppingList>> watchActiveLists() {
    return _database.shoppingListsDao.watchActiveLists().map(
          (rows) => rows.map(toDomainShoppingList).toList(growable: false),
        );
  }

  @override
  Stream<List<domain.ShoppingListItem>> watchItemsForList(
    String shoppingListId,
  ) {
    return _database.shoppingListsDao.watchItemsForList(shoppingListId).map(
          (rows) => rows.map(toDomainShoppingListItem).toList(growable: false),
        );
  }

  @override
  Stream<List<domain.ShoppingList>> watchAllLists() {
    return _database.shoppingListsDao.watchAllLists().map(
          (rows) => rows.map(toDomainShoppingList).toList(growable: false),
        );
  }

  @override
  Future<void> saveShoppingList(domain.ShoppingList shoppingList) {
    return _database.shoppingListsDao
        .upsertShoppingList(toShoppingListCompanion(shoppingList));
  }

  @override
  Future<void> saveShoppingListItem(domain.ShoppingListItem item) {
    return _database.shoppingListsDao.upsertListItem(
      toShoppingListItemCompanion(item),
    );
  }

  @override
  Future<void> linkListToInventory({
    required String shoppingListId,
    required String inventoryId,
  }) {
    final DateTime now = DateTime.now();
    return _database.shoppingListsDao.linkListToInventory(
      id: _uuid.v4(),
      shoppingListId: shoppingListId,
      inventoryId: inventoryId,
      createdAt: now,
      syncStatus: 'pending_sync',
      version: 1,
    );
  }

  @override
  Future<void> unlinkListFromInventory({
    required String shoppingListId,
    required String inventoryId,
  }) {
    return _database.shoppingListsDao.unlinkListFromInventory(
      shoppingListId: shoppingListId,
      inventoryId: inventoryId,
    );
  }

  @override
  Stream<List<inventory_domain.Inventory>> watchInventoriesForList(
    String shoppingListId,
  ) {
    return _database.shoppingListsDao
        .watchInventoriesForList(shoppingListId)
        .map(
          (List<Inventory> rows) =>
              rows.map(toDomainInventory).toList(growable: false),
        );
  }

  @override
  Stream<List<domain.ShoppingList>> watchListsForInventory(String inventoryId) {
    return _database.shoppingListsDao.watchListsForInventory(inventoryId).map(
          (List<ShoppingList> rows) =>
              rows.map(toDomainShoppingList).toList(growable: false),
        );
  }

  @override
  Future<void> deleteShoppingList(String id) {
    return _database.shoppingListsDao.softDeleteShoppingList(id);
  }

  @override
  Future<ShoppingListDraft?> readDraft(String shoppingListId) async {
    final String? payload = await _database.shoppingListsDao.readDraftPayload(
      shoppingListId,
    );
    if (payload == null) {
      return null;
    }

    final Map<String, Object?> json =
        jsonDecode(payload) as Map<String, Object?>;

    final List<Object?> rawItems =
        (json['items'] as List<Object?>?) ?? const <Object?>[];

    final List<domain.ShoppingListItem> items = rawItems
        .map(
          (Object? entry) => _draftItemFromJson(entry as Map<String, Object?>),
        )
        .toList(growable: false);

    final String name = (json['name'] as String?)?.trim() ?? '';
    final String updatedAtRaw =
        (json['updatedAt'] as String?) ?? DateTime.now().toIso8601String();

    return ShoppingListDraft(
      shoppingListId: shoppingListId,
      name: name,
      items: items,
      updatedAt: DateTime.tryParse(updatedAtRaw) ?? DateTime.now(),
    );
  }

  @override
  Future<void> saveDraft(ShoppingListDraft draft) {
    final Map<String, Object?> payload = <String, Object?>{
      'name': draft.name,
      'updatedAt': draft.updatedAt.toIso8601String(),
      'items': draft.items.map(_draftItemToJson).toList(growable: false),
    };

    return _database.shoppingListsDao.upsertDraftPayload(
      shoppingListId: draft.shoppingListId,
      payload: jsonEncode(payload),
      updatedAt: draft.updatedAt,
    );
  }

  @override
  Future<void> deleteDraft(String shoppingListId) {
    return _database.shoppingListsDao.deleteDraft(shoppingListId);
  }

  Map<String, Object?> _draftItemToJson(domain.ShoppingListItem item) {
    return <String, Object?>{
      'id': item.id,
      'shoppingListId': item.shoppingListId,
      'productId': item.productId,
      'rawText': item.rawText,
      'quantity': item.quantity,
      'unit': item.unit?.code,
      'status': item.status.name,
      'source': item.source.name,
      'priorityScore': item.priorityScore,
      'createdAt': item.createdAt.toIso8601String(),
      'updatedAt': item.updatedAt.toIso8601String(),
      'purchasedAt': item.purchasedAt?.toIso8601String(),
      'deletedAt': item.deletedAt?.toIso8601String(),
      'syncStatus': item.syncStatus,
      'version': item.version,
    };
  }

  domain.ShoppingListItem _draftItemFromJson(Map<String, Object?> json) {
    return domain.ShoppingListItem(
      id: (json['id'] as String?) ?? '',
      shoppingListId: (json['shoppingListId'] as String?) ?? '',
      productId: json['productId'] as String?,
      rawText: (json['rawText'] as String?) ?? '',
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: _unitFromCode(json['unit'] as String?),
      status: _statusFromRaw(json['status'] as String?),
      source: _sourceFromRaw(json['source'] as String?),
      priorityScore: (json['priorityScore'] as num?)?.toDouble() ?? 0,
      createdAt: _parseDate(json['createdAt'] as String?),
      updatedAt: _parseDate(json['updatedAt'] as String?),
      purchasedAt: _parseNullableDate(json['purchasedAt'] as String?),
      deletedAt: _parseNullableDate(json['deletedAt'] as String?),
      syncStatus: (json['syncStatus'] as String?) ?? 'local_only',
      version: (json['version'] as num?)?.toInt() ?? 1,
    );
  }

  DateTime _parseDate(String? raw) {
    return DateTime.tryParse(raw ?? '') ?? DateTime.now();
  }

  DateTime? _parseNullableDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  Unit? _unitFromCode(String? code) {
    if (code == null || code.trim().isEmpty) {
      return null;
    }
    final String normalized = code.trim().toLowerCase();
    if (!Unit.supportedCodes.contains(normalized)) {
      return null;
    }
    return Unit.fromCode(normalized);
  }

  domain.ShoppingListItemStatus _statusFromRaw(String? raw) {
    return switch (raw) {
      'pending' => domain.ShoppingListItemStatus.pending,
      'purchased' => domain.ShoppingListItemStatus.purchased,
      'skipped' => domain.ShoppingListItemStatus.skipped,
      _ => domain.ShoppingListItemStatus.pending,
    };
  }

  domain.ShoppingListItemSource _sourceFromRaw(String? raw) {
    return switch (raw) {
      'manual' => domain.ShoppingListItemSource.manual,
      'suggestion' => domain.ShoppingListItemSource.suggestion,
      'import' => domain.ShoppingListItemSource.import,
      _ => domain.ShoppingListItemSource.manual,
    };
  }
}
