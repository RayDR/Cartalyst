// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_alias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductAliasImpl _$$ProductAliasImplFromJson(Map<String, dynamic> json) =>
    _$ProductAliasImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      alias: json['alias'] as String,
      languageCode: json['languageCode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProductAliasImplToJson(_$ProductAliasImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'alias': instance.alias,
      'languageCode': instance.languageCode,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
