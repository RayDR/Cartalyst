import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

enum InventoryItemStatus {
  unknown,
  inStock,
  low,
  out,
}

@freezed
class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String id,
    required String inventoryId,
    String? productId,
    String? rawName,
    double? quantityEstimated,
    Unit? unit,
    required InventoryItemStatus status,
    required double confidenceScore,
    DateTime? lastConfirmedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required String syncStatus,
    required int version,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, Object?> json) =>
      _$InventoryItemFromJson(json);
}
