// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pantry_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PantryItem _$PantryItemFromJson(Map<String, dynamic> json) {
  return _PantryItem.fromJson(json);
}

/// @nodoc
mixin _$PantryItem {
  String get id => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get rawName => throw _privateConstructorUsedError;
  double? get quantityEstimated => throw _privateConstructorUsedError;
  Unit? get unit => throw _privateConstructorUsedError;
  PantryItemStatus get status => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;
  DateTime? get lastConfirmedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this PantryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PantryItemCopyWith<PantryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PantryItemCopyWith<$Res> {
  factory $PantryItemCopyWith(
          PantryItem value, $Res Function(PantryItem) then) =
      _$PantryItemCopyWithImpl<$Res, PantryItem>;
  @useResult
  $Res call(
      {String id,
      String? productId,
      String? rawName,
      double? quantityEstimated,
      Unit? unit,
      PantryItemStatus status,
      double confidenceScore,
      DateTime? lastConfirmedAt,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      String syncStatus,
      int version});

  $UnitCopyWith<$Res>? get unit;
}

/// @nodoc
class _$PantryItemCopyWithImpl<$Res, $Val extends PantryItem>
    implements $PantryItemCopyWith<$Res> {
  _$PantryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? rawName = freezed,
    Object? quantityEstimated = freezed,
    Object? unit = freezed,
    Object? status = null,
    Object? confidenceScore = null,
    Object? lastConfirmedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
    Object? version = null,
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
      rawName: freezed == rawName
          ? _value.rawName
          : rawName // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityEstimated: freezed == quantityEstimated
          ? _value.quantityEstimated
          : quantityEstimated // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as Unit?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PantryItemStatus,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      lastConfirmedAt: freezed == lastConfirmedAt
          ? _value.lastConfirmedAt
          : lastConfirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of PantryItem
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
abstract class _$$PantryItemImplCopyWith<$Res>
    implements $PantryItemCopyWith<$Res> {
  factory _$$PantryItemImplCopyWith(
          _$PantryItemImpl value, $Res Function(_$PantryItemImpl) then) =
      __$$PantryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? productId,
      String? rawName,
      double? quantityEstimated,
      Unit? unit,
      PantryItemStatus status,
      double confidenceScore,
      DateTime? lastConfirmedAt,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      String syncStatus,
      int version});

  @override
  $UnitCopyWith<$Res>? get unit;
}

/// @nodoc
class __$$PantryItemImplCopyWithImpl<$Res>
    extends _$PantryItemCopyWithImpl<$Res, _$PantryItemImpl>
    implements _$$PantryItemImplCopyWith<$Res> {
  __$$PantryItemImplCopyWithImpl(
      _$PantryItemImpl _value, $Res Function(_$PantryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? rawName = freezed,
    Object? quantityEstimated = freezed,
    Object? unit = freezed,
    Object? status = null,
    Object? confidenceScore = null,
    Object? lastConfirmedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
    Object? version = null,
  }) {
    return _then(_$PantryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      rawName: freezed == rawName
          ? _value.rawName
          : rawName // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityEstimated: freezed == quantityEstimated
          ? _value.quantityEstimated
          : quantityEstimated // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as Unit?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PantryItemStatus,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      lastConfirmedAt: freezed == lastConfirmedAt
          ? _value.lastConfirmedAt
          : lastConfirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PantryItemImpl implements _PantryItem {
  const _$PantryItemImpl(
      {required this.id,
      this.productId,
      this.rawName,
      this.quantityEstimated,
      this.unit,
      required this.status,
      required this.confidenceScore,
      this.lastConfirmedAt,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});

  factory _$PantryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PantryItemImplFromJson(json);

  @override
  final String id;
  @override
  final String? productId;
  @override
  final String? rawName;
  @override
  final double? quantityEstimated;
  @override
  final Unit? unit;
  @override
  final PantryItemStatus status;
  @override
  final double confidenceScore;
  @override
  final DateTime? lastConfirmedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final String syncStatus;
  @override
  final int version;

  @override
  String toString() {
    return 'PantryItem(id: $id, productId: $productId, rawName: $rawName, quantityEstimated: $quantityEstimated, unit: $unit, status: $status, confidenceScore: $confidenceScore, lastConfirmedAt: $lastConfirmedAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PantryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.rawName, rawName) || other.rawName == rawName) &&
            (identical(other.quantityEstimated, quantityEstimated) ||
                other.quantityEstimated == quantityEstimated) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.lastConfirmedAt, lastConfirmedAt) ||
                other.lastConfirmedAt == lastConfirmedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      rawName,
      quantityEstimated,
      unit,
      status,
      confidenceScore,
      lastConfirmedAt,
      createdAt,
      updatedAt,
      deletedAt,
      syncStatus,
      version);

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PantryItemImplCopyWith<_$PantryItemImpl> get copyWith =>
      __$$PantryItemImplCopyWithImpl<_$PantryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PantryItemImplToJson(
      this,
    );
  }
}

abstract class _PantryItem implements PantryItem {
  const factory _PantryItem(
      {required final String id,
      final String? productId,
      final String? rawName,
      final double? quantityEstimated,
      final Unit? unit,
      required final PantryItemStatus status,
      required final double confidenceScore,
      final DateTime? lastConfirmedAt,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? deletedAt,
      required final String syncStatus,
      required final int version}) = _$PantryItemImpl;

  factory _PantryItem.fromJson(Map<String, dynamic> json) =
      _$PantryItemImpl.fromJson;

  @override
  String get id;
  @override
  String? get productId;
  @override
  String? get rawName;
  @override
  double? get quantityEstimated;
  @override
  Unit? get unit;
  @override
  PantryItemStatus get status;
  @override
  double get confidenceScore;
  @override
  DateTime? get lastConfirmedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  String get syncStatus;
  @override
  int get version;

  /// Create a copy of PantryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PantryItemImplCopyWith<_$PantryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
