class InventoryCategory {
  const InventoryCategory({
    required this.id,
    required this.inventoryId,
    required this.categoryId,
    required this.name,
    this.color,
    this.icon,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String inventoryId;
  final String categoryId;
  final String name;
  final String? color;
  final String? icon;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
