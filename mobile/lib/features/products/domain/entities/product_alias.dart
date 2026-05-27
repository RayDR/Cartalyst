import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_alias.freezed.dart';
part 'product_alias.g.dart';

@freezed
class ProductAlias with _$ProductAlias {
  const factory ProductAlias({
    required String id,
    required String productId,
    required String alias,
    required String languageCode,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProductAlias;

  factory ProductAlias.fromJson(Map<String, Object?> json) =>
      _$ProductAliasFromJson(json);
}
