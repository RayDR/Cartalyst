import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String canonicalName,
    String? brand,
    required String category,
    required Unit defaultUnit,
    double? defaultPackageQuantity,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required String syncStatus,
    required int version,
  }) = _Product;

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);
}
