part of '../app_database.dart';

@DriftAccessor(tables: <Type>[Products, ProductAliases])
class ProductsDao extends DatabaseAccessor<AppDatabase> with _$ProductsDaoMixin {
  ProductsDao(super.db);

  Future<List<Product>> getActiveProducts() {
    final query = select(products)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($ProductsTable)>[
        (tbl) => OrderingTerm.asc(tbl.canonicalName),
      ]);
    return query.get();
  }

  Stream<List<Product>> watchActiveProducts() {
    final query = select(products)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..orderBy(<OrderingTerm Function($ProductsTable)>[
        (tbl) => OrderingTerm.asc(tbl.canonicalName),
      ]);
    return query.watch();
  }

  Future<void> upsertProduct(ProductsCompanion product) {
    return into(products).insertOnConflictUpdate(product);
  }

  Future<void> upsertAlias(ProductAliasesCompanion alias) {
    return into(productAliases).insertOnConflictUpdate(alias);
  }

  Future<List<ProductAliase>> findAliasesForProduct(String productId) {
    final query = select(productAliases)
      ..where((tbl) => tbl.productId.equals(productId));
    return query.get();
  }

  Future<List<ProductAliase>> findAliasesForProducts(List<String> productIds) {
    final query = select(productAliases)
      ..where((tbl) => tbl.productId.isIn(productIds));
    return query.get();
  }
}
