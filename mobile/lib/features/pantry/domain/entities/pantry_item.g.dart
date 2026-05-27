// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PantryItemImpl _$$PantryItemImplFromJson(Map<String, dynamic> json) =>
    _$PantryItemImpl(
      id: json['id'] as String,
      productId: json['productId'] as String?,
      rawName: json['rawName'] as String?,
      quantityEstimated: (json['quantityEstimated'] as num?)?.toDouble(),
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      status: $enumDecode(_$PantryItemStatusEnumMap, json['status']),
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

Map<String, dynamic> _$$PantryItemImplToJson(_$PantryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'rawName': instance.rawName,
      'quantityEstimated': instance.quantityEstimated,
      'unit': instance.unit,
      'status': _$PantryItemStatusEnumMap[instance.status]!,
      'confidenceScore': instance.confidenceScore,
      'lastConfirmedAt': instance.lastConfirmedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'syncStatus': instance.syncStatus,
      'version': instance.version,
    };

const _$PantryItemStatusEnumMap = {
  PantryItemStatus.unknown: 'unknown',
  PantryItemStatus.inStock: 'inStock',
  PantryItemStatus.low: 'low',
  PantryItemStatus.out: 'out',
};
