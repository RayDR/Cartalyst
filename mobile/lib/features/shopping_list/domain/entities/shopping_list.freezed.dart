// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) {
  return _ShoppingList.fromJson(json);
}

/// @nodoc
mixin _$ShoppingList {
  String get id => throw _privateConstructorUsedError;
  @Deprecated('Use shopping_list_inventory_links for list-inventory relations.')
  String? get inventoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ShoppingListStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this ShoppingList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingListCopyWith<ShoppingList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingListCopyWith<$Res> {
  factory $ShoppingListCopyWith(
          ShoppingList value, $Res Function(ShoppingList) then) =
      _$ShoppingListCopyWithImpl<$Res, ShoppingList>;
  @useResult
  $Res call(
      {String id,
      @Deprecated(
          'Use shopping_list_inventory_links for list-inventory relations.')
      String? inventoryId,
      String name,
      ShoppingListStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      String syncStatus,
      int version});
}

/// @nodoc
class _$ShoppingListCopyWithImpl<$Res, $Val extends ShoppingList>
    implements $ShoppingListCopyWith<$Res> {
  _$ShoppingListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = freezed,
    Object? name = null,
    Object? status = null,
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
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShoppingListStatus,
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
}

/// @nodoc
abstract class _$$ShoppingListImplCopyWith<$Res>
    implements $ShoppingListCopyWith<$Res> {
  factory _$$ShoppingListImplCopyWith(
          _$ShoppingListImpl value, $Res Function(_$ShoppingListImpl) then) =
      __$$ShoppingListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @Deprecated(
          'Use shopping_list_inventory_links for list-inventory relations.')
      String? inventoryId,
      String name,
      ShoppingListStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt,
      String syncStatus,
      int version});
}

/// @nodoc
class __$$ShoppingListImplCopyWithImpl<$Res>
    extends _$ShoppingListCopyWithImpl<$Res, _$ShoppingListImpl>
    implements _$$ShoppingListImplCopyWith<$Res> {
  __$$ShoppingListImplCopyWithImpl(
      _$ShoppingListImpl _value, $Res Function(_$ShoppingListImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = freezed,
    Object? name = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
    Object? version = null,
  }) {
    return _then(_$ShoppingListImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShoppingListStatus,
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
class _$ShoppingListImpl implements _ShoppingList {
  const _$ShoppingListImpl(
      {required this.id,
      @Deprecated(
          'Use shopping_list_inventory_links for list-inventory relations.')
      this.inventoryId,
      required this.name,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version});

  factory _$ShoppingListImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingListImplFromJson(json);

  @override
  final String id;
  @override
  @Deprecated('Use shopping_list_inventory_links for list-inventory relations.')
  final String? inventoryId;
  @override
  final String name;
  @override
  final ShoppingListStatus status;
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
    return 'ShoppingList(id: $id, inventoryId: $inventoryId, name: $name, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
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
  int get hashCode => Object.hash(runtimeType, id, inventoryId, name, status,
      createdAt, updatedAt, deletedAt, syncStatus, version);

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingListImplCopyWith<_$ShoppingListImpl> get copyWith =>
      __$$ShoppingListImplCopyWithImpl<_$ShoppingListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingListImplToJson(
      this,
    );
  }
}

abstract class _ShoppingList implements ShoppingList {
  const factory _ShoppingList(
      {required final String id,
      @Deprecated(
          'Use shopping_list_inventory_links for list-inventory relations.')
      final String? inventoryId,
      required final String name,
      required final ShoppingListStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? deletedAt,
      required final String syncStatus,
      required final int version}) = _$ShoppingListImpl;

  factory _ShoppingList.fromJson(Map<String, dynamic> json) =
      _$ShoppingListImpl.fromJson;

  @override
  String get id;
  @override
  @Deprecated('Use shopping_list_inventory_links for list-inventory relations.')
  String? get inventoryId;
  @override
  String get name;
  @override
  ShoppingListStatus get status;
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

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingListImplCopyWith<_$ShoppingListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
