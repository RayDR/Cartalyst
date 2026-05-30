// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemImpl _$$InventoryItemImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemImpl(
      id: json['id'] as String,
      inventoryId: json['inventoryId'] as String,
      productId: json['productId'] as String?,
      rawName: json['rawName'] as String?,
      quantityEstimated: (json['quantityEstimated'] as num?)?.toDouble(),
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      status: $enumDecode(_$InventoryItemStatusEnumMap, json['status']),
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      lastConfirmedAt: json['lastConfirmedAt'] == null
          ? null
          : DateTime.parse(json['lastConfirmedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      syncStatus: json['syncStatus'] as String,
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$$InventoryItemImplToJson(_$InventoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inventoryId': instance.inventoryId,
      'productId': instance.productId,
      'rawName': instance.rawName,
      'quantityEstimated': instance.quantityEstimated,
      'unit': instance.unit,
      'status': _$InventoryItemStatusEnumMap[instance.status]!,
      'confidenceScore': instance.confidenceScore,
      'lastConfirmedAt': instance.lastConfirmedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'syncStatus': instance.syncStatus,
      'version': instance.version,
    };

const _$InventoryItemStatusEnumMap = {
  InventoryItemStatus.unknown: 'unknown',
  InventoryItemStatus.inStock: 'inStock',
  InventoryItemStatus.low: 'low',
  InventoryItemStatus.out: 'out',
};
