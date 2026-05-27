import 'package:cartalyst_mobile/features/price_compare/domain/services/unit_price_calculation_service.dart';

enum PackageRecommendation {
  first,
  second,
  tie,
  none,
}

class PackageOptionInput {
  const PackageOptionInput({
    required this.label,
    required this.price,
    required this.quantity,
    required this.unit,
    this.productId,
  });

  final String label;
  final double price;
  final double quantity;
  final String unit;
  final String? productId;
}

class PackageOptionEvaluation {
  const PackageOptionEvaluation({
    required this.option,
    required this.unitPriceResult,
  });

  final PackageOptionInput option;
  final UnitPriceCalculationResult unitPriceResult;
}

class PackageComparisonResult {
  const PackageComparisonResult({
    required this.isComparable,
    required this.recommendation,
    required this.explanation,
    required this.firstOption,
    required this.secondOption,
    this.recommendedLabel,
    this.normalizedUnit,
  });

  final bool isComparable;
  final PackageRecommendation recommendation;
  final String explanation;
  final PackageOptionEvaluation firstOption;
  final PackageOptionEvaluation secondOption;
  final String? recommendedLabel;
  final String? normalizedUnit;
}

class PackageComparisonService {
  const PackageComparisonService(this._unitPriceService);

  final UnitPriceCalculationService _unitPriceService;

  PackageComparisonResult compare({
    required PackageOptionInput first,
    required PackageOptionInput second,
  }) {
    final UnitPriceCalculationResult firstResult = _unitPriceService.calculate(
      totalPrice: first.price,
      quantity: first.quantity,
      unit: first.unit,
    );

    final UnitPriceCalculationResult secondResult = _unitPriceService.calculate(
      totalPrice: second.price,
      quantity: second.quantity,
      unit: second.unit,
    );

    final PackageOptionEvaluation firstEvaluation = PackageOptionEvaluation(
      option: first,
      unitPriceResult: firstResult,
    );

    final PackageOptionEvaluation secondEvaluation = PackageOptionEvaluation(
      option: second,
      unitPriceResult: secondResult,
    );

    if (!firstResult.isValid || !secondResult.isValid) {
      final String reason = !firstResult.isValid
          ? '${first.label}: ${firstResult.reason}'
          : '${second.label}: ${secondResult.reason}';

      return PackageComparisonResult(
        isComparable: false,
        recommendation: PackageRecommendation.none,
        explanation: reason,
        firstOption: firstEvaluation,
        secondOption: secondEvaluation,
      );
    }

    if (firstResult.family != secondResult.family) {
      return PackageComparisonResult(
        isComparable: false,
        recommendation: PackageRecommendation.none,
        explanation: 'The selected units are incompatible and cannot be compared.',
        firstOption: firstEvaluation,
        secondOption: secondEvaluation,
      );
    }

    final double firstUnitPrice = firstResult.unitPrice!;
    final double secondUnitPrice = secondResult.unitPrice!;
    final double delta = (firstUnitPrice - secondUnitPrice).abs();

    if (delta <= 0.000001) {
      return PackageComparisonResult(
        isComparable: true,
        recommendation: PackageRecommendation.tie,
        explanation:
            'Both options have the same unit price (${firstUnitPrice.toStringAsFixed(4)} per ${firstResult.normalizedUnit}).',
        firstOption: firstEvaluation,
        secondOption: secondEvaluation,
        normalizedUnit: firstResult.normalizedUnit,
      );
    }

    if (firstUnitPrice < secondUnitPrice) {
      return PackageComparisonResult(
        isComparable: true,
        recommendation: PackageRecommendation.first,
        explanation:
            '${first.label} is the better value at ${firstUnitPrice.toStringAsFixed(4)} per ${firstResult.normalizedUnit} versus ${secondUnitPrice.toStringAsFixed(4)}.',
        firstOption: firstEvaluation,
        secondOption: secondEvaluation,
        recommendedLabel: first.label,
        normalizedUnit: firstResult.normalizedUnit,
      );
    }

    return PackageComparisonResult(
      isComparable: true,
      recommendation: PackageRecommendation.second,
      explanation:
          '${second.label} is the better value at ${secondUnitPrice.toStringAsFixed(4)} per ${secondResult.normalizedUnit} versus ${firstUnitPrice.toStringAsFixed(4)}.',
      firstOption: firstEvaluation,
      secondOption: secondEvaluation,
      recommendedLabel: second.label,
      normalizedUnit: firstResult.normalizedUnit,
    );
  }
}
