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
    test('piece comparison', () {
      final PackageComparisonResult result = comparisonService.compare(
        first: const PackageOptionInput(
          label: 'Option A',
          price: 12,
          quantity: 20,
          unit: 'piece',
        ),
        second: const PackageOptionInput(
          label: 'Option B',
          price: 26,
          quantity: 40,
          unit: 'piece',
        ),
      );

      expect(result.isComparable, isTrue);
      expect(result.recommendation, PackageRecommendation.first);
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

    test('incompatible units', () {
      final PackageComparisonResult result = comparisonService.compare(
        first: const PackageOptionInput(
          label: 'Option A',
          price: 10,
          quantity: 10,
          unit: 'piece',
        ),
        second: const PackageOptionInput(
          label: 'Option B',
          price: 8,
          quantity: 500,
          unit: 'ml',
        ),
      );

      expect(result.isComparable, isFalse);
      expect(result.recommendation, PackageRecommendation.none);
    });

    test('zero quantity', () {
      final PackageComparisonResult result = comparisonService.compare(
        first: const PackageOptionInput(
          label: 'Option A',
          price: 10,
          quantity: 0,
          unit: 'piece',
        ),
        second: const PackageOptionInput(
          label: 'Option B',
          price: 8,
          quantity: 10,
          unit: 'piece',
        ),
      );

      expect(result.isComparable, isFalse);
      expect(result.recommendation, PackageRecommendation.none);
      expect(result.explanation, contains('greater than zero'));
    });

    test('equal unit price', () {
      final PackageComparisonResult result = comparisonService.compare(
        first: const PackageOptionInput(
          label: 'Option A',
          price: 10,
          quantity: 20,
          unit: 'piece',
        ),
        second: const PackageOptionInput(
          label: 'Option B',
          price: 20,
          quantity: 40,
          unit: 'piece',
        ),
      );

      expect(result.isComparable, isTrue);
      expect(result.recommendation, PackageRecommendation.tie);
    });

    test('cheaper first option', () {
      final PackageComparisonResult result = comparisonService.compare(
        first: const PackageOptionInput(
          label: 'Option A',
          price: 12,
          quantity: 20,
          unit: 'piece',
        ),
        second: const PackageOptionInput(
          label: 'Option B',
          price: 30,
          quantity: 40,
          unit: 'piece',
        ),
      );

      expect(result.recommendation, PackageRecommendation.first);
    });

    test('cheaper second option', () {
      final PackageComparisonResult result = comparisonService.compare(
        first: const PackageOptionInput(
          label: 'Option A',
          price: 30,
          quantity: 20,
          unit: 'piece',
        ),
        second: const PackageOptionInput(
          label: 'Option B',
          price: 12,
          quantity: 20,
          unit: 'piece',
        ),
      );

      expect(result.recommendation, PackageRecommendation.second);
    });
  });
}
