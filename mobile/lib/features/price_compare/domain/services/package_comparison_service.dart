import 'package:cartalyst_mobile/features/price_compare/domain/services/unit_conversion_service.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/services/unit_price_calculation_service.dart';

enum PackageRecommendation {
  winner,
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
    this.productName,
    this.store,
    this.notes,
  });

  final String label;
  final double price;
  final double quantity;
  final String unit;
  final String? productId;
  final String? productName;
  final String? store;
  final String? notes;
}

class PackageOptionEvaluation {
  const PackageOptionEvaluation({
    required this.option,
    required this.unitPriceResult,
    this.rank,
  });

  final PackageOptionInput option;
  final UnitPriceCalculationResult unitPriceResult;
  final int? rank;
}

class PackageComparisonResult {
  const PackageComparisonResult({
    required this.isComparable,
    required this.recommendation,
    required this.explanation,
    required this.options,
    this.recommendedLabel,
    this.normalizedUnit,
  });

  final bool isComparable;
  final PackageRecommendation recommendation;
  final String explanation;
  final List<PackageOptionEvaluation> options;
  final String? recommendedLabel;
  final String? normalizedUnit;

  List<PackageOptionEvaluation> get rankedOptions {
    final List<PackageOptionEvaluation> ranked = options
        .where((PackageOptionEvaluation evaluation) => evaluation.rank != null)
        .toList(growable: false);
    final List<PackageOptionEvaluation> sorted =
        List<PackageOptionEvaluation>.from(ranked);
    sorted.sort((PackageOptionEvaluation a, PackageOptionEvaluation b) {
      final int rankCompare = (a.rank ?? 999).compareTo(b.rank ?? 999);
      if (rankCompare != 0) {
        return rankCompare;
      }
      return a.option.label.compareTo(b.option.label);
    });
    return sorted;
  }
}

class PackageComparisonService {
  const PackageComparisonService(this._unitPriceService);

  final UnitPriceCalculationService _unitPriceService;

  PackageComparisonResult compare({
    required PackageOptionInput first,
    required PackageOptionInput second,
  }) {
    return compareAll(<PackageOptionInput>[first, second]);
  }

  PackageComparisonResult compareAll(List<PackageOptionInput> options) {
    if (options.length < 2) {
      return const PackageComparisonResult(
        isComparable: false,
        recommendation: PackageRecommendation.none,
        explanation: 'Add at least two options to compare.',
        options: <PackageOptionEvaluation>[],
      );
    }

    final List<PackageOptionEvaluation> evaluations = options
        .map(
          (PackageOptionInput option) => PackageOptionEvaluation(
            option: option,
            unitPriceResult: _unitPriceService.calculate(
              totalPrice: option.price,
              quantity: option.quantity,
              unit: option.unit,
            ),
          ),
        )
        .toList(growable: false);

    final PackageOptionEvaluation? invalidEvaluation =
        evaluations.cast<PackageOptionEvaluation?>().firstWhere(
              (PackageOptionEvaluation? evaluation) =>
                  evaluation != null && !evaluation.unitPriceResult.isValid,
              orElse: () => null,
            );

    if (invalidEvaluation != null) {
      return PackageComparisonResult(
        isComparable: false,
        recommendation: PackageRecommendation.none,
        explanation:
            '${invalidEvaluation.option.label}: ${invalidEvaluation.unitPriceResult.reason}',
        options: evaluations,
      );
    }

    final UnitFamily? referenceFamily =
        evaluations.first.unitPriceResult.family;
    final bool hasIncompatibleUnits = evaluations.any(
      (PackageOptionEvaluation evaluation) =>
          evaluation.unitPriceResult.family != referenceFamily,
    );

    if (hasIncompatibleUnits) {
      return PackageComparisonResult(
        isComparable: false,
        recommendation: PackageRecommendation.none,
        explanation:
            'The selected units are incompatible and cannot be compared.',
        options: evaluations,
      );
    }

    final List<PackageOptionEvaluation> ranked =
        List<PackageOptionEvaluation>.from(evaluations)
          ..sort((PackageOptionEvaluation a, PackageOptionEvaluation b) {
            return a.unitPriceResult.unitPrice!
                .compareTo(b.unitPriceResult.unitPrice!);
          });

    int currentRank = 1;
    double? previousPrice;
    final Map<String, int> ranksByLabel = <String, int>{};
    for (int index = 0; index < ranked.length; index++) {
      final PackageOptionEvaluation evaluation = ranked[index];
      final double price = evaluation.unitPriceResult.unitPrice!;
      if (previousPrice != null && (price - previousPrice).abs() > 0.000001) {
        currentRank += 1;
      }
      ranksByLabel[evaluation.option.label] = currentRank;
      previousPrice = price;
    }

    final List<PackageOptionEvaluation> withRanks = evaluations
        .map(
          (PackageOptionEvaluation evaluation) => PackageOptionEvaluation(
            option: evaluation.option,
            unitPriceResult: evaluation.unitPriceResult,
            rank: ranksByLabel[evaluation.option.label],
          ),
        )
        .toList(growable: false);

    final double winningPrice = ranked.first.unitPriceResult.unitPrice!;
    final List<PackageOptionEvaluation> leaders = ranked
        .where(
          (PackageOptionEvaluation evaluation) =>
              (evaluation.unitPriceResult.unitPrice! - winningPrice).abs() <=
              0.000001,
        )
        .toList(growable: false);
    final String normalizedUnit =
        ranked.first.unitPriceResult.normalizedUnit ?? '-';

    if (leaders.length > 1) {
      final String labels = leaders
          .map((PackageOptionEvaluation evaluation) => evaluation.option.label)
          .join(', ');
      return PackageComparisonResult(
        isComparable: true,
        recommendation: PackageRecommendation.tie,
        explanation:
            '$labels are tied at ${winningPrice.toStringAsFixed(4)} per $normalizedUnit.',
        options: withRanks,
        normalizedUnit: normalizedUnit,
      );
    }

    final PackageOptionEvaluation winner = ranked.first;
    final PackageOptionEvaluation runnerUp = ranked[1];
    return PackageComparisonResult(
      isComparable: true,
      recommendation: PackageRecommendation.winner,
      explanation:
          '${winner.option.label} wins at ${winner.unitPriceResult.unitPrice!.toStringAsFixed(4)} per $normalizedUnit. Next best is ${runnerUp.option.label} at ${runnerUp.unitPriceResult.unitPrice!.toStringAsFixed(4)}.',
      options: withRanks,
      recommendedLabel: winner.option.label,
      normalizedUnit: normalizedUnit,
    );
  }
}
