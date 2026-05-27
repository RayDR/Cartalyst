// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoneyImpl _$$MoneyImplFromJson(Map<String, dynamic> json) => _$MoneyImpl(
      amountMinor: (json['amountMinor'] as num).toInt(),
      currencyCode: json['currencyCode'] as String? ?? 'USD',
    );

Map<String, dynamic> _$$MoneyImplToJson(_$MoneyImpl instance) =>
    <String, dynamic>{
      'amountMinor': instance.amountMinor,
      'currencyCode': instance.currencyCode,
    };
