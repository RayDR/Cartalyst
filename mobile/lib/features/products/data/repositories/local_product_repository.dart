import 'package:cartalyst_mobile/features/products/data/mappers/product_mapper.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart' as domain;
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart' as domain;
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';

class LocalProductRepository implements ProductRepository {
  LocalProductRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<domain.Product>> watchActiveProducts() {
    return _database.productsDao.watchActiveProducts().map(
        (rows) => rows.map(toDomainProduct).toList(growable: false),
        );
  }

  @override
  Future<List<domain.ProductAlias>> findAliasesForProduct(String productId) async {
    final rows = await _database.productsDao.findAliasesForProduct(productId);
    return rows.map(toDomainProductAlias).toList(growable: false);
  }

  @override
  Future<void> saveProduct(domain.Product product) {
    return _database.productsDao.upsertProduct(toProductCompanion(product));
  }

  @override
  Future<void> saveAlias(domain.ProductAlias alias) {
    return _database.productsDao.upsertAlias(toProductAliasCompanion(alias));
  }
}
