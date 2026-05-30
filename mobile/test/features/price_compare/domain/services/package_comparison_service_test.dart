import 'package:cartalyst_mobile/features/price_compare/domain/services/package_comparison_service.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/services/unit_conversion_service.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/services/unit_price_calculation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const UnitConversionService conversionService = UnitConversionService();
  const UnitPriceCalculationService unitPriceService =
      UnitPriceCalculationService(conversionService);
  const PackageComparisonService comparisonService =
      PackageComparisonService(unitPriceService);

  group('Price compare services', () {
    test('2 options compares and picks winner', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: 12,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 26,
            quantity: 40,
            unit: 'piece',
          ),
        ],
      );

      expect(result.isComparable, isTrue);
      expect(result.recommendation, PackageRecommendation.winner);
      expect(result.recommendedLabel, 'Option A');
    });

    test('oz/lb conversion', () {
      final UnitConversionResult result = conversionService.convert(
        quantity: 16,
        fromUnit: 'oz',
        toUnit: 'lb',
      );

      expect(result.isValid, isTrue);
      expect(result.convertedQuantity, closeTo(1, 0.000001));
    });

    test('g/kg conversion', () {
      final UnitConversionResult result = conversionService.convert(
        quantity: 1000,
        fromUnit: 'g',
        toUnit: 'kg',
      );

      expect(result.isValid, isTrue);
      expect(result.convertedQuantity, closeTo(1, 0.000001));
    });

    test('ml/l conversion', () {
      final UnitConversionResult result = conversionService.convert(
        quantity: 1500,
        fromUnit: 'ml',
        toUnit: 'l',
      );

      expect(result.isValid, isTrue);
      expect(result.convertedQuantity, closeTo(1.5, 0.000001));
    });

    test('gal/l conversion', () {
      final UnitConversionResult result = conversionService.convert(
        quantity: 1,
        fromUnit: 'gal',
        toUnit: 'l',
      );

      expect(result.isValid, isTrue);
      expect(result.convertedQuantity, closeTo(3.785411784, 0.000001));
    });

    test('3 options compare and rank correctly', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: 12,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 18,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option C',
            price: 8,
            quantity: 20,
            unit: 'piece',
          ),
        ],
      );

      expect(result.isComparable, isTrue);
      expect(result.options.length, 3);
      expect(result.recommendedLabel, 'Option C');
      expect(result.rankedOptions.first.option.label, 'Option C');
    });

    test('4 options compare and rank correctly', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: 12,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 18,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option C',
            price: 8,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option D',
            price: 25,
            quantity: 40,
            unit: 'piece',
          ),
        ],
      );

      expect(result.isComparable, isTrue);
      expect(result.options.length, 4);
      expect(result.recommendedLabel, 'Option C');
      expect(result.rankedOptions.first.option.label, 'Option C');
    });

    test('5 options compare and rank correctly', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: 12,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 18,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option C',
            price: 8,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option D',
            price: 25,
            quantity: 40,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option E',
            price: 40,
            quantity: 50,
            unit: 'piece',
          ),
        ],
      );

      expect(result.isComparable, isTrue);
      expect(result.options.length, 5);
      expect(result.recommendedLabel, 'Option C');
      expect(result.rankedOptions.first.option.label, 'Option C');
      expect(result.rankedOptions.last.option.label, 'Option B');
    });

    test('invalid option returns non-comparable result', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: double.nan,
            quantity: 10,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 8,
            quantity: 10,
            unit: 'piece',
          ),
        ],
      );

      expect(result.isComparable, isFalse);
      expect(result.recommendation, PackageRecommendation.none);
      expect(result.explanation, contains('Option A'));
    });

    test('incompatible units', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: 10,
            quantity: 10,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 8,
            quantity: 500,
            unit: 'ml',
          ),
          PackageOptionInput(
            label: 'Option C',
            price: 15,
            quantity: 15,
            unit: 'piece',
          ),
        ],
      );

      expect(result.isComparable, isFalse);
      expect(result.recommendation, PackageRecommendation.none);
    });

    test('zero quantity', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: 10,
            quantity: 0,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 8,
            quantity: 10,
            unit: 'piece',
          ),
        ],
      );

      expect(result.isComparable, isFalse);
      expect(result.recommendation, PackageRecommendation.none);
      expect(result.explanation, contains('greater than zero'));
    });

    test('equal unit price', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: 10,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 20,
            quantity: 40,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option C',
            price: 15,
            quantity: 20,
            unit: 'piece',
          ),
        ],
      );

      expect(result.isComparable, isTrue);
      expect(result.recommendation, PackageRecommendation.tie);
    });

    test('winner selection prefers lowest normalized unit price', () {
      final PackageComparisonResult result = comparisonService.compareAll(
        const <PackageOptionInput>[
          PackageOptionInput(
            label: 'Option A',
            price: 30,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option B',
            price: 12,
            quantity: 20,
            unit: 'piece',
          ),
          PackageOptionInput(
            label: 'Option C',
            price: 20,
            quantity: 25,
            unit: 'piece',
          ),
        ],
      );

      expect(result.recommendation, PackageRecommendation.winner);
      expect(result.recommendedLabel, 'Option B');
    });
  });
}
