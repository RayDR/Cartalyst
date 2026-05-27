// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryEventImpl _$$InventoryEventImplFromJson(Map<String, dynamic> json) =>
    _$InventoryEventImpl(
      id: json['id'] as String,
      productId: json['productId'] as String?,
      pantryItemId: json['pantryItemId'] as String?,
      eventType: $enumDecode(_$InventoryEventTypeEnumMap, json['eventType']),
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      source: $enumDecode(_$InventoryEventSourceEnumMap, json['source']),
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$InventoryEventImplToJson(
        _$InventoryEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'pantryItemId': instance.pantryItemId,
      'eventType': _$InventoryEventTypeEnumMap[instance.eventType]!,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'source': _$InventoryEventSourceEnumMap[instance.source]!,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$InventoryEventTypeEnumMap = {
  InventoryEventType.purchase: 'purchase',
  InventoryEventType.consume: 'consume',
  InventoryEventType.adjust: 'adjust',
  InventoryEventType.finish: 'finish',
  InventoryEventType.discard: 'discard',
};

const _$InventoryEventSourceEnumMap = {
  InventoryEventSource.manual: 'manual',
  InventoryEventSource.receipt: 'receipt',
  InventoryEventSource.system: 'system',
};
