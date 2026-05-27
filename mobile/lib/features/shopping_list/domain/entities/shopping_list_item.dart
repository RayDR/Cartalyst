import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list_item.freezed.dart';
part 'shopping_list_item.g.dart';

enum ShoppingListItemStatus {
  pending,
  purchased,
  skipped,
}

enum ShoppingListItemSource {
  manual,
  suggestion,
  import,
}

@freezed
class ShoppingListItem with _$ShoppingListItem {
  const ShoppingListItem._();

  const factory ShoppingListItem({
    required String id,
    required String shoppingListId,
    String? productId,
    required String rawText,
    double? quantity,
    Unit? unit,
    required ShoppingListItemStatus status,
    required ShoppingListItemSource source,
    required double priorityScore,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? purchasedAt,
    DateTime? deletedAt,
    required String syncStatus,
    required int version,
  }) = _ShoppingListItem;

  factory ShoppingListItem.fromJson(Map<String, Object?> json) =>
      _$ShoppingListItemFromJson(json);

  ShoppingListItem transitionTo(
    ShoppingListItemStatus nextStatus, {
    DateTime? transitionedAt,
  }) {
    if (!_canTransition(status, nextStatus)) {
      throw StateError('Invalid status transition: $status -> $nextStatus');
    }

    final DateTime now = transitionedAt ?? DateTime.now();

    return copyWith(
      status: nextStatus,
      updatedAt: now,
      purchasedAt: nextStatus == ShoppingListItemStatus.purchased ? now : null,
      version: version + 1,
      syncStatus: 'pending_sync',
    );
  }

  bool _canTransition(
    ShoppingListItemStatus current,
    ShoppingListItemStatus next,
  ) {
    if (current == next) {
      return true;
    }

    return switch (current) {
      ShoppingListItemStatus.pending =>
        next == ShoppingListItemStatus.purchased ||
            next == ShoppingListItemStatus.skipped,
      ShoppingListItemStatus.purchased => next == ShoppingListItemStatus.pending,
      ShoppingListItemStatus.skipped => next == ShoppingListItemStatus.pending,
    };
  }
}
