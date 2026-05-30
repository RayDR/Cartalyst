// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryEvent _$InventoryEventFromJson(Map<String, dynamic> json) {
  return _InventoryEvent.fromJson(json);
}

/// @nodoc
mixin _$InventoryEvent {
  String get id => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get inventoryId => throw _privateConstructorUsedError;
  String? get inventoryItemId => throw _privateConstructorUsedError;
  @Deprecated('Use inventoryItemId')
  String? get pantryItemId => throw _privateConstructorUsedError;
  InventoryEventType get eventType => throw _privateConstructorUsedError;
  double? get quantity => throw _privateConstructorUsedError;
  Unit? get unit => throw _privateConstructorUsedError;
  InventoryEventSource get source => throw _privateConstructorUsedError;
  DateTime get occurredAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryEventCopyWith<InventoryEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryEventCopyWith<$Res> {
  factory $InventoryEventCopyWith(
          InventoryEvent value, $Res Function(InventoryEvent) then) =
      _$InventoryEventCopyWithImpl<$Res, InventoryEvent>;
  @useResult
  $Res call(
      {String id,
      String? productId,
      String? inventoryId,
      String? inventoryItemId,
      @Deprecated('Use inventoryItemId') String? pantryItemId,
      InventoryEventType eventType,
      double? quantity,
      Unit? unit,
      InventoryEventSource source,
      DateTime occurredAt,
      DateTime createdAt});

  $UnitCopyWith<$Res>? get unit;
}

/// @nodoc
class _$InventoryEventCopyWithImpl<$Res, $Val extends InventoryEvent>
    implements $InventoryEventCopyWith<$Res> {
  _$InventoryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? inventoryId = freezed,
    Object? inventoryItemId = freezed,
    Object? pantryItemId = freezed,
    Object? eventType = null,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? source = null,
    Object? occurredAt = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      inventoryItemId: freezed == inventoryItemId
          ? _value.inventoryItemId
          : inventoryItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      pantryItemId: freezed == pantryItemId
          ? _value.pantryItemId
          : pantryItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as InventoryEventType,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as Unit?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as InventoryEventSource,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of InventoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnitCopyWith<$Res>? get unit {
    if (_value.unit == null) {
      return null;
    }

    return $UnitCopyWith<$Res>(_value.unit!, (value) {
      return _then(_value.copyWith(unit: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InventoryEventImplCopyWith<$Res>
    implements $InventoryEventCopyWith<$Res> {
  factory _$$InventoryEventImplCopyWith(_$InventoryEventImpl value,
          $Res Function(_$InventoryEventImpl) then) =
      __$$InventoryEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? productId,
      String? inventoryId,
      String? inventoryItemId,
      @Deprecated('Use inventoryItemId') String? pantryItemId,
      InventoryEventType eventType,
      double? quantity,
      Unit? unit,
      InventoryEventSource source,
      DateTime occurredAt,
      DateTime createdAt});

  @override
  $UnitCopyWith<$Res>? get unit;
}

/// @nodoc
class __$$InventoryEventImplCopyWithImpl<$Res>
    extends _$InventoryEventCopyWithImpl<$Res, _$InventoryEventImpl>
    implements _$$InventoryEventImplCopyWith<$Res> {
  __$$InventoryEventImplCopyWithImpl(
      _$InventoryEventImpl _value, $Res Function(_$InventoryEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? inventoryId = freezed,
    Object? inventoryItemId = freezed,
    Object? pantryItemId = freezed,
    Object? eventType = null,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? source = null,
    Object? occurredAt = null,
    Object? createdAt = null,
  }) {
    return _then(_$InventoryEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      inventoryItemId: freezed == inventoryItemId
          ? _value.inventoryItemId
          : inventoryItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      pantryItemId: freezed == pantryItemId
          ? _value.pantryItemId
          : pantryItemId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as InventoryEventType,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as Unit?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as InventoryEventSource,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryEventImpl implements _InventoryEvent {
  const _$InventoryEventImpl(
      {required this.id,
      this.productId,
      this.inventoryId,
      this.inventoryItemId,
      @Deprecated('Use inventoryItemId') this.pantryItemId,
      required this.eventType,
      this.quantity,
      this.unit,
      required this.source,
      required this.occurredAt,
      required this.createdAt});

  factory _$InventoryEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryEventImplFromJson(json);

  @override
  final String id;
  @override
  final String? productId;
  @override
  final String? inventoryId;
  @override
  final String? inventoryItemId;
  @override
  @Deprecated('Use inventoryItemId')
  final String? pantryItemId;
  @override
  final InventoryEventType eventType;
  @override
  final double? quantity;
  @override
  final Unit? unit;
  @override
  final InventoryEventSource source;
  @override
  final DateTime occurredAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'InventoryEvent(id: $id, productId: $productId, inventoryId: $inventoryId, inventoryItemId: $inventoryItemId, pantryItemId: $pantryItemId, eventType: $eventType, quantity: $quantity, unit: $unit, source: $source, occurredAt: $occurredAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.inventoryItemId, inventoryItemId) ||
                other.inventoryItemId == inventoryItemId) &&
            (identical(other.pantryItemId, pantryItemId) ||
                other.pantryItemId == pantryItemId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      inventoryId,
      inventoryItemId,
      pantryItemId,
      eventType,
      quantity,
      unit,
      source,
      occurredAt,
      createdAt);

  /// Create a copy of InventoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryEventImplCopyWith<_$InventoryEventImpl> get copyWith =>
      __$$InventoryEventImplCopyWithImpl<_$InventoryEventImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryEventImplToJson(
      this,
    );
  }
}

abstract class _InventoryEvent implements InventoryEvent {
  const factory _InventoryEvent(
      {required final String id,
      final String? productId,
      final String? inventoryId,
      final String? inventoryItemId,
      @Deprecated('Use inventoryItemId') final String? pantryItemId,
      required final InventoryEventType eventType,
      final double? quantity,
      final Unit? unit,
      required final InventoryEventSource source,
      required final DateTime occurredAt,
      required final DateTime createdAt}) = _$InventoryEventImpl;

  factory _InventoryEvent.fromJson(Map<String, dynamic> json) =
      _$InventoryEventImpl.fromJson;

  @override
  String get id;
  @override
  String? get productId;
  @override
  String? get inventoryId;
  @override
  String? get inventoryItemId;
  @override
  @Deprecated('Use inventoryItemId')
  String? get pantryItemId;
  @override
  InventoryEventType get eventType;
  @override
  double? get quantity;
  @override
  Unit? get unit;
  @override
  InventoryEventSource get source;
  @override
  DateTime get occurredAt;
  @override
  DateTime get createdAt;

  /// Create a copy of InventoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryEventImplCopyWith<_$InventoryEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
