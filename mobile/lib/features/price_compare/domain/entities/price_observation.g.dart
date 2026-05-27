// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_observation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceObservationImpl _$$PriceObservationImplFromJson(
        Map<String, dynamic> json) =>
    _$PriceObservationImpl(
      id: json['id'] as String,
      productId: json['productId'] as String?,
      storeName: json['storeName'] as String?,
      packageQuantity: (json['packageQuantity'] as num).toDouble(),
      packageUnit: Unit.fromJson(json['packageUnit'] as Map<String, dynamic>),
      price: Money.fromJson(json['price'] as Map<String, dynamic>),
      unitPrice: Money.fromJson(json['unitPrice'] as Map<String, dynamic>),
      observedAt: DateTime.parse(json['observedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PriceObservationImplToJson(
        _$PriceObservationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'storeName': instance.storeName,
      'packageQuantity': instance.packageQuantity,
      'packageUnit': instance.packageUnit,
      'price': instance.price,
      'unitPrice': instance.unitPrice,
      'observedAt': instance.observedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
