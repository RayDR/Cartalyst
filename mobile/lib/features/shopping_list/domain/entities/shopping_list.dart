import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';
part 'shopping_list.g.dart';

enum ShoppingListStatus {
  active,
  completed,
  archived,
}

enum ShoppingListType {
  simple,
  organized,
}

enum ShoppingListRoutingMode {
  none,
  inventoryCategories,
  categoryAsInventory,
}

@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required String id,
    @Deprecated(
      'Use shopping_list_inventory_links for list-inventory relations.',
    )
    String? inventoryId,
    required String name,
    @Default(ShoppingListType.simple) ShoppingListType listType,
    @Default(ShoppingListRoutingMode.none) ShoppingListRoutingMode routingMode,
    required ShoppingListStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required String syncStatus,
    required int version,
  }) = _ShoppingList;

  factory ShoppingList.fromJson(Map<String, Object?> json) =>
      _$ShoppingListFromJson(json);
}
