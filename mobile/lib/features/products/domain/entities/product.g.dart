// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      canonicalName: json['canonicalName'] as String,
      brand: json['brand'] as String?,
      category: json['category'] as String,
      defaultUnit: Unit.fromJson(json['defaultUnit'] as Map<String, dynamic>),
      defaultPackageQuantity:
          (json['defaultPackageQuantity'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      syncStatus: json['syncStatus'] as String,
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'canonicalName': instance.canonicalName,
      'brand': instance.brand,
      'category': instance.category,
      'defaultUnit': instance.defaultUnit,
      'defaultPackageQuantity': instance.defaultPackageQuantity,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'syncStatus': instance.syncStatus,
      'version': instance.version,
    };
