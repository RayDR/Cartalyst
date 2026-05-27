// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_observation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PriceObservation _$PriceObservationFromJson(Map<String, dynamic> json) {
  return _PriceObservation.fromJson(json);
}

/// @nodoc
mixin _$PriceObservation {
  String get id => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get storeName => throw _privateConstructorUsedError;
  double get packageQuantity => throw _privateConstructorUsedError;
  Unit get packageUnit => throw _privateConstructorUsedError;
  Money get price => throw _privateConstructorUsedError;
  Money get unitPrice => throw _privateConstructorUsedError;
  DateTime get observedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PriceObservation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriceObservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceObservationCopyWith<PriceObservation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceObservationCopyWith<$Res> {
  factory $PriceObservationCopyWith(
          PriceObservation value, $Res Function(PriceObservation) then) =
      _$PriceObservationCopyWithImpl<$Res, PriceObservation>;
  @useResult
  $Res call(
      {String id,
      String? productId,
      String? storeName,
      double packageQuantity,
      Unit packageUnit,
      Money price,
      Money unitPrice,
      DateTime observedAt,
      DateTime createdAt});

  $UnitCopyWith<$Res> get packageUnit;
  $MoneyCopyWith<$Res> get price;
  $MoneyCopyWith<$Res> get unitPrice;
}

/// @nodoc
class _$PriceObservationCopyWithImpl<$Res, $Val extends PriceObservation>
    implements $PriceObservationCopyWith<$Res> {
  _$PriceObservationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceObservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? storeName = freezed,
    Object? packageQuantity = null,
    Object? packageUnit = null,
    Object? price = null,
    Object? unitPrice = null,
    Object? observedAt = null,
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
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      packageQuantity: null == packageQuantity
          ? _value.packageQuantity
          : packageQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      packageUnit: null == packageUnit
          ? _value.packageUnit
          : packageUnit // ignore: cast_nullable_to_non_nullable
              as Unit,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as Money,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as Money,
      observedAt: null == observedAt
          ? _value.observedAt
          : observedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of PriceObservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UnitCopyWith<$Res> get packageUnit {
    return $UnitCopyWith<$Res>(_value.packageUnit, (value) {
      return _then(_value.copyWith(packageUnit: value) as $Val);
    });
  }

  /// Create a copy of PriceObservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyCopyWith<$Res> get price {
    return $MoneyCopyWith<$Res>(_value.price, (value) {
      return _then(_value.copyWith(price: value) as $Val);
    });
  }

  /// Create a copy of PriceObservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoneyCopyWith<$Res> get unitPrice {
    return $MoneyCopyWith<$Res>(_value.unitPrice, (value) {
      return _then(_value.copyWith(unitPrice: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PriceObservationImplCopyWith<$Res>
    implements $PriceObservationCopyWith<$Res> {
  factory _$$PriceObservationImplCopyWith(_$PriceObservationImpl value,
          $Res Function(_$PriceObservationImpl) then) =
      __$$PriceObservationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? productId,
      String? storeName,
      double packageQuantity,
      Unit packageUnit,
      Money price,
      Money unitPrice,
      DateTime observedAt,
      DateTime createdAt});

  @override
  $UnitCopyWith<$Res> get packageUnit;
  @override
  $MoneyCopyWith<$Res> get price;
  @override
  $MoneyCopyWith<$Res> get unitPrice;
}

/// @nodoc
class __$$PriceObservationImplCopyWithImpl<$Res>
    extends _$PriceObservationCopyWithImpl<$Res, _$PriceObservationImpl>
    implements _$$PriceObservationImplCopyWith<$Res> {
  __$$PriceObservationImplCopyWithImpl(_$PriceObservationImpl _value,
      $Res Function(_$PriceObservationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriceObservation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = freezed,
    Object? storeName = freezed,
    Object? packageQuantity = null,
    Object? packageUnit = null,
    Object? price = null,
    Object? unitPrice = null,
    Object? observedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_$PriceObservationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      packageQuantity: null == packageQuantity
          ? _value.packageQuantity
          : packageQuantity // ignore: cast_nullable_to_non_nullable
              as double,
      packageUnit: null == packageUnit
          ? _value.packageUnit
          : packageUnit // ignore: cast_nullable_to_non_nullable
              as Unit,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as Money,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as Money,
      observedAt: null == observedAt
          ? _value.observedAt
          : observedAt // ignore: cast_nullable_to_non_nullable
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
class _$PriceObservationImpl implements _PriceObservation {
  const _$PriceObservationImpl(
      {required this.id,
      this.productId,
      this.storeName,
      required this.packageQuantity,
      required this.packageUnit,
      required this.price,
      required this.unitPrice,
      required this.observedAt,
      required this.createdAt});

  factory _$PriceObservationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceObservationImplFromJson(json);

  @override
  final String id;
  @override
  final String? productId;
  @override
  final String? storeName;
  @override
  final double packageQuantity;
  @override
  final Unit packageUnit;
  @override
  final Money price;
  @override
  final Money unitPrice;
  @override
  final DateTime observedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PriceObservation(id: $id, productId: $productId, storeName: $storeName, packageQuantity: $packageQuantity, packageUnit: $packageUnit, price: $price, unitPrice: $unitPrice, observedAt: $observedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceObservationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.packageQuantity, packageQuantity) ||
                other.packageQuantity == packageQuantity) &&
            (identical(other.packageUnit, packageUnit) ||
                other.packageUnit == packageUnit) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.observedAt, observedAt) ||
                other.observedAt == observedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, productId, storeName,
      packageQuantity, packageUnit, price, unitPrice, observedAt, createdAt);

  /// Create a copy of PriceObservation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceObservationImplCopyWith<_$PriceObservationImpl> get copyWith =>
      __$$PriceObservationImplCopyWithImpl<_$PriceObservationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceObservationImplToJson(
      this,
    );
  }
}

abstract class _PriceObservation implements PriceObservation {
  const factory _PriceObservation(
      {required final String id,
      final String? productId,
      final String? storeName,
      required final double packageQuantity,
      required final Unit packageUnit,
      required final Money price,
      required final Money unitPrice,
      required final DateTime observedAt,
      required final DateTime createdAt}) = _$PriceObservationImpl;

  factory _PriceObservation.fromJson(Map<String, dynamic> json) =
      _$PriceObservationImpl.fromJson;

  @override
  String get id;
  @override
  String? get productId;
  @override
  String? get storeName;
  @override
  double get packageQuantity;
  @override
  Unit get packageUnit;
  @override
  Money get price;
  @override
  Money get unitPrice;
  @override
  DateTime get observedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of PriceObservation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceObservationImplCopyWith<_$PriceObservationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
