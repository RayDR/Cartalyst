class ShoppingListCategory {
  const ShoppingListCategory({
    required this.id,
    required this.shoppingListId,
    required this.categoryId,
    this.targetInventoryId,
    this.targetInventoryCategoryId,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.categoryName,
  });

  final String id;
  final String shoppingListId;
  final String categoryId;
  final String? targetInventoryId;
  final String? targetInventoryCategoryId;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? categoryName;
}
