import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';
part 'daos/pantry_dao.dart';
part 'daos/price_observations_dao.dart';
part 'daos/products_dao.dart';
part 'daos/shopping_lists_dao.dart';
part 'migrations/app_migrations.dart';
part 'tables/inventory_events.dart';
part 'tables/pantry_items.dart';
part 'tables/price_observations.dart';
part 'tables/product_aliases.dart';
part 'tables/products.dart';
part 'tables/shopping_list_items.dart';
part 'tables/shopping_lists.dart';

@DriftDatabase(
  tables: <Type>[
    Products,
    ProductAliases,
    ShoppingLists,
    ShoppingListItems,
    PantryItems,
    InventoryEvents,
    PriceObservations,
  ],
  daos: <Type>[
    ProductsDao,
    ShoppingListsDao,
    PantryDao,
    PriceObservationsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => buildMigrationStrategy(this);

  Future<void> developmentReset() async {
    if (kReleaseMode) {
      throw StateError('developmentReset is disabled in release builds.');
    }

    await transaction(() async {
      for (final TableInfo<Table, Object?> table in allTables.toList().reversed) {
        await delete(table).go();
      }
      await seedCommonProductsAndAliases();
    });
  }

  Future<void> seedCommonProductsAndAliases() async {
    final int existingProducts = await (selectOnly(products)
          ..addColumns(<Expression<Object>>[products.id.count()]))
        .map((TypedResult row) => row.read(products.id.count()) ?? 0)
        .getSingle();

    if (existingProducts > 0) {
      return;
    }

    final DateTime now = DateTime.now();
    const List<_SeedProduct> seeds = <_SeedProduct>[
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98101',
        canonicalName: 'eggs',
        category: 'protein',
        defaultUnit: 'unit',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'eggs', languageCode: 'en'),
          _SeedAlias(alias: 'huevos', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98102',
        canonicalName: 'milk',
        category: 'dairy',
        defaultUnit: 'liter',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'milk', languageCode: 'en'),
          _SeedAlias(alias: 'leche', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98103',
        canonicalName: 'bananas',
        category: 'produce',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'bananas', languageCode: 'en'),
          _SeedAlias(alias: 'platanos', languageCode: 'es'),
          _SeedAlias(alias: 'plátanos', languageCode: 'es'),
          _SeedAlias(alias: 'platano', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98104',
        canonicalName: 'apples',
        category: 'produce',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'apples', languageCode: 'en'),
          _SeedAlias(alias: 'manzanas', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98105',
        canonicalName: 'bread',
        category: 'bakery',
        defaultUnit: 'unit',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'bread', languageCode: 'en'),
          _SeedAlias(alias: 'pan', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98106',
        canonicalName: 'rice',
        category: 'grains',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'rice', languageCode: 'en'),
          _SeedAlias(alias: 'arroz', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98107',
        canonicalName: 'beans',
        category: 'grains',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'beans', languageCode: 'en'),
          _SeedAlias(alias: 'frijoles', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98108',
        canonicalName: 'chicken',
        category: 'protein',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'chicken', languageCode: 'en'),
          _SeedAlias(alias: 'pollo', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98109',
        canonicalName: 'toilet paper',
        category: 'household',
        defaultUnit: 'unit',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'toilet paper', languageCode: 'en'),
          _SeedAlias(alias: 'papel de bano', languageCode: 'es'),
          _SeedAlias(alias: 'papel de baño', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98110',
        canonicalName: 'paper towels',
        category: 'household',
        defaultUnit: 'unit',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'paper towels', languageCode: 'en'),
          _SeedAlias(alias: 'servitoallas', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98111',
        canonicalName: 'tomatoes',
        category: 'produce',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'tomatoes', languageCode: 'en'),
          _SeedAlias(alias: 'tomates', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98112',
        canonicalName: 'onions',
        category: 'produce',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'onions', languageCode: 'en'),
          _SeedAlias(alias: 'cebollas', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98113',
        canonicalName: 'potatoes',
        category: 'produce',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'potatoes', languageCode: 'en'),
          _SeedAlias(alias: 'papas', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98114',
        canonicalName: 'cheese',
        category: 'dairy',
        defaultUnit: 'kg',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'cheese', languageCode: 'en'),
          _SeedAlias(alias: 'queso', languageCode: 'es'),
        ],
      ),
      _SeedProduct(
        id: '0f7b5fd7-e2d3-4292-9a75-b74ec7c98115',
        canonicalName: 'yogurt',
        category: 'dairy',
        defaultUnit: 'unit',
        aliases: <_SeedAlias>[
          _SeedAlias(alias: 'yogurt', languageCode: 'en'),
          _SeedAlias(alias: 'yogur', languageCode: 'es'),
        ],
      ),
    ];

    const Uuid uuid = Uuid();

    await batch((Batch batch) {
      batch.insertAll(
        products,
        seeds
            .map(
              (_SeedProduct seed) => ProductsCompanion.insert(
                id: seed.id,
                canonicalName: seed.canonicalName,
                category: Value(seed.category),
                defaultUnit: Value(seed.defaultUnit),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value('local_only'),
                version: const Value(1),
              ),
            )
            .toList(growable: false),
      );

      final List<ProductAliasesCompanion> aliasRows =
          <ProductAliasesCompanion>[];
      for (final _SeedProduct seed in seeds) {
        for (final _SeedAlias alias in seed.aliases) {
          aliasRows.add(
            ProductAliasesCompanion.insert(
              id: uuid.v4(),
              productId: seed.id,
              alias: alias.alias,
              languageCode: alias.languageCode,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
        }
      }

      batch.insertAll(productAliases, aliasRows);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dir.path, 'cartalyst.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

class _SeedProduct {
  const _SeedProduct({
    required this.id,
    required this.canonicalName,
    required this.category,
    required this.defaultUnit,
    required this.aliases,
  });

  final String id;
  final String canonicalName;
  final String category;
  final String defaultUnit;
  final List<_SeedAlias> aliases;
}

class _SeedAlias {
  const _SeedAlias({
    required this.alias,
    required this.languageCode,
  });

  final String alias;
  final String languageCode;
}
