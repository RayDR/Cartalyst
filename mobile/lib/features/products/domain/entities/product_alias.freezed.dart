// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_alias.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductAlias _$ProductAliasFromJson(Map<String, dynamic> json) {
  return _ProductAlias.fromJson(json);
}

/// @nodoc
mixin _$ProductAlias {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  String get languageCode => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProductAlias to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductAlias
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductAliasCopyWith<ProductAlias> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductAliasCopyWith<$Res> {
  factory $ProductAliasCopyWith(
          ProductAlias value, $Res Function(ProductAlias) then) =
      _$ProductAliasCopyWithImpl<$Res, ProductAlias>;
  @useResult
  $Res call(
      {String id,
      String productId,
      String alias,
      String languageCode,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ProductAliasCopyWithImpl<$Res, $Val extends ProductAlias>
    implements $ProductAliasCopyWith<$Res> {
  _$ProductAliasCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductAlias
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? alias = null,
    Object? languageCode = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductAliasImplCopyWith<$Res>
    implements $ProductAliasCopyWith<$Res> {
  factory _$$ProductAliasImplCopyWith(
          _$ProductAliasImpl value, $Res Function(_$ProductAliasImpl) then) =
      __$$ProductAliasImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String alias,
      String languageCode,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ProductAliasImplCopyWithImpl<$Res>
    extends _$ProductAliasCopyWithImpl<$Res, _$ProductAliasImpl>
    implements _$$ProductAliasImplCopyWith<$Res> {
  __$$ProductAliasImplCopyWithImpl(
      _$ProductAliasImpl _value, $Res Function(_$ProductAliasImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductAlias
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? alias = null,
    Object? languageCode = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProductAliasImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductAliasImpl implements _ProductAlias {
  const _$ProductAliasImpl(
      {required this.id,
      required this.productId,
      required this.alias,
      required this.languageCode,
      required this.createdAt,
      required this.updatedAt});

  factory _$ProductAliasImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductAliasImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String alias;
  @override
  final String languageCode;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProductAlias(id: $id, productId: $productId, alias: $alias, languageCode: $languageCode, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAliasImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, productId, alias, languageCode, createdAt, updatedAt);

  /// Create a copy of ProductAlias
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductAliasImplCopyWith<_$ProductAliasImpl> get copyWith =>
      __$$ProductAliasImplCopyWithImpl<_$ProductAliasImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductAliasImplToJson(
      this,
    );
  }
}

abstract class _ProductAlias implements ProductAlias {
  const factory _ProductAlias(
      {required final String id,
      required final String productId,
      required final String alias,
      required final String languageCode,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ProductAliasImpl;

  factory _ProductAlias.fromJson(Map<String, dynamic> json) =
      _$ProductAliasImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get alias;
  @override
  String get languageCode;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ProductAlias
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductAliasImplCopyWith<_$ProductAliasImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
