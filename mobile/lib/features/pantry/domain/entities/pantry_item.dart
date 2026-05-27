import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pantry_item.freezed.dart';
part 'pantry_item.g.dart';

enum PantryItemStatus {
  unknown,
  inStock,
  low,
  out,
}

@freezed
class PantryItem with _$PantryItem {
  const factory PantryItem({
    required String id,
    String? productId,
    String? rawName,
    double? quantityEstimated,
    Unit? unit,
    required PantryItemStatus status,
    required double confidenceScore,
    DateTime? lastConfirmedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required String syncStatus,
    required int version,
  }) = _PantryItem;

  factory PantryItem.fromJson(Map<String, Object?> json) =>
      _$PantryItemFromJson(json);
}
