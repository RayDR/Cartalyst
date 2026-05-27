import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/services/product_suggestion_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ProductSuggestionService service = ProductSuggestionService();

  final DateTime baseTime = DateTime(2026);

  Product product({
    required String id,
    required String name,
    String category = 'produce',
    String unitCode = 'unit',
  }) {
    return Product(
      id: id,
      canonicalName: name,
      category: category,
      defaultUnit: Unit.fromCode(unitCode),
      createdAt: baseTime,
      updatedAt: baseTime,
      syncStatus: 'synced',
      version: 1,
    );
  }

  ProductAlias alias({
    required String id,
    required String productId,
    required String value,
    required String language,
  }) {
    return ProductAlias(
      id: id,
      productId: productId,
      alias: value,
      languageCode: language,
      createdAt: baseTime,
      updatedAt: baseTime,
    );
  }

  final Product milk = product(id: 'p1', name: 'milk', category: 'dairy', unitCode: 'liter');
  final Product eggs = product(id: 'p2', name: 'eggs', category: 'protein');
  final Product bananas = product(id: 'p3', name: 'bananas', unitCode: 'kg');
  final Product paperTowels = product(
    id: 'p4',
    name: 'paper towels',
    category: 'household',
    unitCode: 'pack',
  );

  final List<Product> products = <Product>[milk, eggs, bananas, paperTowels];

  final List<ProductAlias> aliases = <ProductAlias>[
    alias(id: 'a1', productId: milk.id, value: 'leche', language: 'es'),
    alias(id: 'a2', productId: eggs.id, value: 'huevos', language: 'es'),
    alias(id: 'a3', productId: bananas.id, value: 'platanos', language: 'es'),
    alias(id: 'a4', productId: paperTowels.id, value: 'servitoallas', language: 'es'),
  ];

  group('ProductSuggestionService', () {
    test('exact product match', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: 'milk',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.first.suggestedProduct?.id, milk.id);
      expect(result.first.reasonCode, SuggestionReasonCode.exactMatch);
    });

    test('exact alias match', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: 'huevos',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.first.suggestedProduct?.id, eggs.id);
      expect(result.first.reasonCode, SuggestionReasonCode.exactMatch);
    });

    test('spanish alias with accent normalization', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: 'plátanos 6',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.first.suggestedProduct?.id, bananas.id);
      expect(result.first.parsedQuantity, 6);
      expect(result.first.normalizedQuery, 'platanos');
    });

    test('fuzzy typo match', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: 'mlik',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.first.suggestedProduct?.id, milk.id);
      expect(result.first.reasonCode, SuggestionReasonCode.fuzzy);
    });

    test('parses quantity before product', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: '12 eggs',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.first.suggestedProduct?.id, eggs.id);
      expect(result.first.parsedQuantity, 12);
      expect(result.first.parsedUnit, isNull);
    });

    test('parses quantity after product', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: 'huevos 18',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.first.suggestedProduct?.id, eggs.id);
      expect(result.first.parsedQuantity, 18);
    });

    test('parses unit and quantity', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: 'paper towels 12 pack',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.first.suggestedProduct?.id, paperTowels.id);
      expect(result.first.parsedQuantity, 12);
      expect(result.first.parsedUnit, 'pack');
    });

    test('ranks by frequency when match tier is equal', () {
      final List<Product> localProducts = <Product>[
        product(id: 'p10', name: 'milk a', category: 'dairy', unitCode: 'liter'),
        product(id: 'p11', name: 'milk b', category: 'dairy', unitCode: 'liter'),
      ];

      final List<ProductSuggestion> result = service.suggest(
        rawInput: 'milk',
        availableProducts: localProducts,
        aliases: const <ProductAlias>[],
        usageStats: const <ProductUsageStat>[
          ProductUsageStat(productId: 'p11', frequency: 9),
          ProductUsageStat(productId: 'p10', frequency: 1),
        ],
      );

      expect(result.first.suggestedProduct?.id, 'p11');
    });

    test('empty input returns empty-input fallback', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: '  ',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.length, 1);
      expect(result.first.suggestedProduct, isNull);
      expect(result.first.reasonCode, SuggestionReasonCode.emptyInput);
    });

    test('unknown product fallback', () {
      final List<ProductSuggestion> result = service.suggest(
        rawInput: 'dragonfruit',
        availableProducts: products,
        aliases: aliases,
        usageStats: const <ProductUsageStat>[],
      );

      expect(result.length, 1);
      expect(result.first.suggestedProduct, isNull);
      expect(result.first.reasonCode, SuggestionReasonCode.unknownProduct);
    });
  });
}
