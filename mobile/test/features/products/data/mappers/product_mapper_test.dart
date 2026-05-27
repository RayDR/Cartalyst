import 'package:cartalyst_mobile/features/products/data/mappers/product_mapper.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' as local_db;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps drift product to domain product', () {
    final DateTime now = DateTime(2026);
    final local_db.Product row = local_db.Product(
      id: 'p1',
      canonicalName: 'milk',
      brand: 'Acme',
      category: 'dairy',
      defaultUnit: 'liter',
      defaultPackageQuantity: 1,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'synced',
      version: 3,
    );

    final domain = toDomainProduct(row);

    expect(domain.id, 'p1');
    expect(domain.defaultUnit.code, 'liter');
    expect(domain.syncStatus, 'synced');
    expect(domain.version, 3);
  });
}
