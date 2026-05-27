import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';

abstract interface class ProductRepository {
  Stream<List<Product>> watchActiveProducts();

  Future<List<ProductAlias>> findAliasesForProduct(String productId);

  Future<List<ProductAlias>> findAliasesForProducts(List<String> productIds);

  Future<void> saveProduct(Product product);

  Future<void> saveAlias(ProductAlias alias);
}
