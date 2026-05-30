class Category {
  const Category({
    required this.id,
    required this.name,
    this.color,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
    required this.version,
  });

  final String id;
  final String name;
  final String? color;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String syncStatus;
  final int version;
}
