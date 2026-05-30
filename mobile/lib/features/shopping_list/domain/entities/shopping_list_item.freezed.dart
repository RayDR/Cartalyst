// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) {
  return _ShoppingListItem.fromJson(json);
}

/// @nodoc
mixin _$ShoppingListItem {
  String get id => throw _privateConstructorUsedError;
  String get shoppingListId => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get targetInventoryId => throw _privateConstructorUsedError;
  String? get targetInventoryCategoryId => throw _privateConstructorUsedError;
  String get rawText => throw _privateConstructorUsedError;
  double? get quantity => throw _privateConstructorUsedError;
  Unit? get unit => throw _privateConstructorUsedError;
  ShoppingListItemStatus get status => throw _privateConstructorUsedError;
  ShoppingListItemSource get source => throw _privateConstructorUsedError;
  double get priorityScore => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get purchasedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this ShoppingListItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingListItemCopyWith<ShoppingListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingListItemCopyWith<$Res> {
  factory $ShoppingListItemCopyWith(
          ShoppingListItem value, $Res Function(ShoppingListItem) then) =
      _$ShoppingListItemCopyWithImpl<$Res, ShoppingListItem>;
  @useResult
  $Res call(
      {String id,
      String shoppingListId,
      String? productId,
      String? categoryId,
      String? targetInventoryId,
      String? targetInventoryCategoryId,
      String rawText,
      double? quantity,
      Unit? unit,
      ShoppingListItemStatus status,
      ShoppingListItemSource source,
      double priorityScore,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? purchasedAt,
      DateTime? deletedAt,
      String syncStatus,
      int version});

  $UnitCopyWith<$Res>? get unit;
}

/// @nodoc
class _$ShoppingListItemCopyWithImpl<$Res, $Val extends ShoppingListItem>
    implements $ShoppingListItemCopyWith<$Res> {
  _$ShoppingListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shoppingListId = null,
    Object? productId = freezed,
    Object? categoryId = freezed,
    Object? targetInventoryId = freezed,
    Object? targetInventoryCategoryId = freezed,
    Object? rawText = null,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? status = null,
    Object? source = null,
    Object? priorityScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? purchasedAt = freezed,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shoppingListId: null == shoppingListId
          ? _value.shoppingListId
          : shoppingListId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetInventoryId: freezed == targetInventoryId
          ? _value.targetInventoryId
          : targetInventoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetInventoryCategoryId: freezed == targetInventoryCategoryId
          ? _value.targetInventoryCategoryId
          : targetInventoryCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      rawText: null == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as Unit?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShoppingListItemStatus,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ShoppingListItemSource,
      priorityScore: null == priorityScore
          ? _value.priorityScore
          : priorityScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      purchasedAt: freezed == purchasedAt
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

  /// Create a copy of ShoppingListItem
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
abstract class _$$ShoppingListItemImplCopyWith<$Res>
    implements $ShoppingListItemCopyWith<$Res> {
  factory _$$ShoppingListItemImplCopyWith(_$ShoppingListItemImpl value,
          $Res Function(_$ShoppingListItemImpl) then) =
      __$$ShoppingListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String shoppingListId,
      String? productId,
      String? categoryId,
      String? targetInventoryId,
      String? targetInventoryCategoryId,
      String rawText,
      double? quantity,
      Unit? unit,
      ShoppingListItemStatus status,
      ShoppingListItemSource source,
      double priorityScore,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? purchasedAt,
      DateTime? deletedAt,
      String syncStatus,
      int version});

  @override
  $UnitCopyWith<$Res>? get unit;
}

/// @nodoc
class __$$ShoppingListItemImplCopyWithImpl<$Res>
    extends _$ShoppingListItemCopyWithImpl<$Res, _$ShoppingListItemImpl>
    implements _$$ShoppingListItemImplCopyWith<$Res> {
  __$$ShoppingListItemImplCopyWithImpl(_$ShoppingListItemImpl _value,
      $Res Function(_$ShoppingListItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shoppingListId = null,
    Object? productId = freezed,
    Object? categoryId = freezed,
    Object? targetInventoryId = freezed,
    Object? targetInventoryCategoryId = freezed,
    Object? rawText = null,
    Object? quantity = freezed,
    Object? unit = freezed,
    Object? status = null,
    Object? source = null,
    Object? priorityScore = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? purchasedAt = freezed,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
    Object? version = null,
  }) {
    return _then(_$ShoppingListItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shoppingListId: null == shoppingListId
          ? _value.shoppingListId
          : shoppingListId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetInventoryId: freezed == targetInventoryId
          ? _value.targetInventoryId
          : targetInventoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      targetInventoryCategoryId: freezed == targetInventoryCategoryId
          ? _value.targetInventoryCategoryId
          : targetInventoryCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      rawText: null == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as Unit?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ShoppingListItemStatus,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ShoppingListItemSource,
      priorityScore: null == priorityScore
          ? _value.priorityScore
          : priorityScore // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      purchasedAt: freezed == purchasedAt
          ? _value.purchasedAt
          : purchasedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$ShoppingListItemImpl extends _ShoppingListItem {
  const _$ShoppingListItemImpl(
      {required this.id,
      required this.shoppingListId,
      this.productId,
      this.categoryId,
      this.targetInventoryId,
      this.targetInventoryCategoryId,
      required this.rawText,
      this.quantity,
      this.unit,
      required this.status,
      required this.source,
      required this.priorityScore,
      required this.createdAt,
      required this.updatedAt,
      this.purchasedAt,
      this.deletedAt,
      required this.syncStatus,
      required this.version})
      : super._();

  factory _$ShoppingListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingListItemImplFromJson(json);

  @override
  final String id;
  @override
  final String shoppingListId;
  @override
  final String? productId;
  @override
  final String? categoryId;
  @override
  final String? targetInventoryId;
  @override
  final String? targetInventoryCategoryId;
  @override
  final String rawText;
  @override
  final double? quantity;
  @override
  final Unit? unit;
  @override
  final ShoppingListItemStatus status;
  @override
  final ShoppingListItemSource source;
  @override
  final double priorityScore;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? purchasedAt;
  @override
  final DateTime? deletedAt;
  @override
  final String syncStatus;
  @override
  final int version;

  @override
  String toString() {
    return 'ShoppingListItem(id: $id, shoppingListId: $shoppingListId, productId: $productId, categoryId: $categoryId, targetInventoryId: $targetInventoryId, targetInventoryCategoryId: $targetInventoryCategoryId, rawText: $rawText, quantity: $quantity, unit: $unit, status: $status, source: $source, priorityScore: $priorityScore, createdAt: $createdAt, updatedAt: $updatedAt, purchasedAt: $purchasedAt, deletedAt: $deletedAt, syncStatus: $syncStatus, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingListItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shoppingListId, shoppingListId) ||
                other.shoppingListId == shoppingListId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.targetInventoryId, targetInventoryId) ||
                other.targetInventoryId == targetInventoryId) &&
            (identical(other.targetInventoryCategoryId,
                    targetInventoryCategoryId) ||
                other.targetInventoryCategoryId == targetInventoryCategoryId) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.priorityScore, priorityScore) ||
                other.priorityScore == priorityScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.purchasedAt, purchasedAt) ||
                other.purchasedAt == purchasedAt) &&
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
      shoppingListId,
      productId,
      categoryId,
      targetInventoryId,
      targetInventoryCategoryId,
      rawText,
      quantity,
      unit,
      status,
      source,
      priorityScore,
      createdAt,
      updatedAt,
      purchasedAt,
      deletedAt,
      syncStatus,
      version);

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingListItemImplCopyWith<_$ShoppingListItemImpl> get copyWith =>
      __$$ShoppingListItemImplCopyWithImpl<_$ShoppingListItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingListItemImplToJson(
      this,
    );
  }
}

abstract class _ShoppingListItem extends ShoppingListItem {
  const factory _ShoppingListItem(
      {required final String id,
      required final String shoppingListId,
      final String? productId,
      final String? categoryId,
      final String? targetInventoryId,
      final String? targetInventoryCategoryId,
      required final String rawText,
      final double? quantity,
      final Unit? unit,
      required final ShoppingListItemStatus status,
      required final ShoppingListItemSource source,
      required final double priorityScore,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? purchasedAt,
      final DateTime? deletedAt,
      required final String syncStatus,
      required final int version}) = _$ShoppingListItemImpl;
  const _ShoppingListItem._() : super._();

  factory _ShoppingListItem.fromJson(Map<String, dynamic> json) =
      _$ShoppingListItemImpl.fromJson;

  @override
  String get id;
  @override
  String get shoppingListId;
  @override
  String? get productId;
  @override
  String? get categoryId;
  @override
  String? get targetInventoryId;
  @override
  String? get targetInventoryCategoryId;
  @override
  String get rawText;
  @override
  double? get quantity;
  @override
  Unit? get unit;
  @override
  ShoppingListItemStatus get status;
  @override
  ShoppingListItemSource get source;
  @override
  double get priorityScore;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get purchasedAt;
  @override
  DateTime? get deletedAt;
  @override
  String get syncStatus;
  @override
  int get version;

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingListItemImplCopyWith<_$ShoppingListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
