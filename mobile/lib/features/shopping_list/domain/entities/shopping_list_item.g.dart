// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingListItemImpl _$$ShoppingListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ShoppingListItemImpl(
      id: json['id'] as String,
      shoppingListId: json['shoppingListId'] as String,
      productId: json['productId'] as String?,
      rawText: json['rawText'] as String,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      status: $enumDecode(_$ShoppingListItemStatusEnumMap, json['status']),
      source: $enumDecode(_$ShoppingListItemSourceEnumMap, json['source']),
      priorityScore: (json['priorityScore'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      purchasedAt: json['purchasedAt'] == null
          ? null
          : DateTime.parse(json['purchasedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      syncStatus: json['syncStatus'] as String,
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$$ShoppingListItemImplToJson(
        _$ShoppingListItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shoppingListId': instance.shoppingListId,
      'productId': instance.productId,
      'rawText': instance.rawText,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'status': _$ShoppingListItemStatusEnumMap[instance.status]!,
      'source': _$ShoppingListItemSourceEnumMap[instance.source]!,
      'priorityScore': instance.priorityScore,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'purchasedAt': instance.purchasedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'syncStatus': instance.syncStatus,
      'version': instance.version,
    };

const _$ShoppingListItemStatusEnumMap = {
  ShoppingListItemStatus.pending: 'pending',
  ShoppingListItemStatus.purchased: 'purchased',
  ShoppingListItemStatus.skipped: 'skipped',
};

const _$ShoppingListItemSourceEnumMap = {
  ShoppingListItemSource.manual: 'manual',
  ShoppingListItemSource.suggestion: 'suggestion',
  ShoppingListItemSource.import: 'import',
};
