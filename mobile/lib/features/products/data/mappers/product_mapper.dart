import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart' as domain;
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart' as domain;
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' as local_db;
import 'package:drift/drift.dart';

domain.Product toDomainProduct(local_db.Product row) {
  return domain.Product(
    id: row.id,
    canonicalName: row.canonicalName,
    brand: row.brand,
    category: row.category,
    defaultUnit: Unit.fromCode(row.defaultUnit),
    defaultPackageQuantity: row.defaultPackageQuantity,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    syncStatus: row.syncStatus,
    version: row.version,
  );
}

domain.ProductAlias toDomainProductAlias(local_db.ProductAliase row) {
  return domain.ProductAlias(
    id: row.id,
    productId: row.productId,
    alias: row.alias,
    languageCode: row.languageCode,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

local_db.ProductsCompanion toProductCompanion(domain.Product entity) {
  return local_db.ProductsCompanion(
    id: Value(entity.id),
    canonicalName: Value(entity.canonicalName),
    brand: Value(entity.brand),
    category: Value(entity.category),
    defaultUnit: Value(entity.defaultUnit.code),
    defaultPackageQuantity: Value(entity.defaultPackageQuantity),
    createdAt: Value(entity.createdAt),
    updatedAt: Value(entity.updatedAt),
    deletedAt: Value(entity.deletedAt),
    syncStatus: Value(entity.syncStatus),
    version: Value(entity.version),
  );
}

local_db.ProductAliasesCompanion toProductAliasCompanion(domain.ProductAlias alias) {
  return local_db.ProductAliasesCompanion(
    id: Value(alias.id),
    productId: Value(alias.productId),
    alias: Value(alias.alias),
    languageCode: Value(alias.languageCode),
    createdAt: Value(alias.createdAt),
    updatedAt: Value(alias.updatedAt),
  );
}
