// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingListImpl _$$ShoppingListImplFromJson(Map<String, dynamic> json) =>
    _$ShoppingListImpl(
      id: json['id'] as String,
      inventoryId: json['inventoryId'] as String?,
      name: json['name'] as String,
      listType:
          $enumDecodeNullable(_$ShoppingListTypeEnumMap, json['listType']) ??
              ShoppingListType.simple,
      routingMode: $enumDecodeNullable(
              _$ShoppingListRoutingModeEnumMap, json['routingMode']) ??
          ShoppingListRoutingMode.none,
      status: $enumDecode(_$ShoppingListStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      syncStatus: json['syncStatus'] as String,
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$$ShoppingListImplToJson(_$ShoppingListImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inventoryId': instance.inventoryId,
      'name': instance.name,
      'listType': _$ShoppingListTypeEnumMap[instance.listType]!,
      'routingMode': _$ShoppingListRoutingModeEnumMap[instance.routingMode]!,
      'status': _$ShoppingListStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'syncStatus': instance.syncStatus,
      'version': instance.version,
    };

const _$ShoppingListTypeEnumMap = {
  ShoppingListType.simple: 'simple',
  ShoppingListType.organized: 'organized',
};

const _$ShoppingListRoutingModeEnumMap = {
  ShoppingListRoutingMode.none: 'none',
  ShoppingListRoutingMode.inventoryCategories: 'inventoryCategories',
  ShoppingListRoutingMode.categoryAsInventory: 'categoryAsInventory',
};

const _$ShoppingListStatusEnumMap = {
  ShoppingListStatus.active: 'active',
  ShoppingListStatus.completed: 'completed',
  ShoppingListStatus.archived: 'archived',
};
