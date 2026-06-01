import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';

enum SuggestionReasonCode {
  exactMatch,
  startsWith,
  contains,
  fuzzy,
  unknownProduct,
  emptyInput,
}

class ProductUsageStat {
  const ProductUsageStat({
    required this.productId,
    required this.frequency,
    this.lastUsedAt,
  });

  final String productId;
  final int frequency;
  final DateTime? lastUsedAt;
}

class ProductSuggestion {
  const ProductSuggestion({
    required this.rawInput,
    required this.normalizedQuery,
    required this.parsedQuantity,
    required this.parsedUnit,
    required this.confidenceScore,
    required this.reasonCode,
    this.suggestedProduct,
  });

  final Product? suggestedProduct;
  final String rawInput;
  final String normalizedQuery;
  final double? parsedQuantity;
  final String? parsedUnit;
  final double confidenceScore;
  final SuggestionReasonCode reasonCode;
}

class ProductSuggestionService {
  const ProductSuggestionService();

  static const Map<String, String> _unitSynonyms = <String, String>{
    'unit': 'unit',
    'units': 'unit',
    'un': 'unit',
    'kg': 'kg',
    'kilo': 'kg',
    'kilos': 'kg',
    'g': 'g',
    'gr': 'g',
    'gram': 'g',
    'grams': 'g',
    'l': 'liter',
    'lt': 'liter',
    'liter': 'liter',
    'liters': 'liter',
    'litre': 'liter',
    'litres': 'liter',
    'litro': 'liter',
    'litros': 'liter',
    'ml': 'ml',
    'milliliter': 'ml',
    'milliliters': 'ml',
    'pack': 'pack',
    'packs': 'pack',
    'gallon': 'gal',
    'gallons': 'gal',
    'gal': 'gal',
  };

  List<ProductSuggestion> suggest({
    required String rawInput,
    required List<Product> availableProducts,
    required List<ProductAlias> aliases,
    required List<ProductUsageStat> usageStats,
    int maxResults = 5,
  }) {
    final _ParsedInput parsed = _parseInput(rawInput);

    if (parsed.normalizedQuery.isEmpty) {
      return <ProductSuggestion>[
        ProductSuggestion(
          rawInput: rawInput,
          normalizedQuery: parsed.normalizedQuery,
          parsedQuantity: parsed.quantity,
          parsedUnit: parsed.unit,
          confidenceScore: 0,
          reasonCode: SuggestionReasonCode.emptyInput,
        ),
      ];
    }

    final Map<String, List<String>> aliasesByProduct =
        _aliasesByProduct(aliases);
    final Map<String, ProductUsageStat> usageByProduct =
        <String, ProductUsageStat>{
      for (final ProductUsageStat stat in usageStats) stat.productId: stat,
    };

    final List<_ScoredSuggestion> scored = availableProducts
        .map(
          (Product product) => _scoreProduct(
            parsedQuery: parsed.normalizedQuery,
            product: product,
            aliases: aliasesByProduct[product.id] ?? const <String>[],
            usage: usageByProduct[product.id],
          ),
        )
        .where((_ScoredSuggestion candidate) => candidate.score > 0)
        .toList(growable: false)
      ..sort(
        (_ScoredSuggestion a, _ScoredSuggestion b) =>
            b.score.compareTo(a.score),
      );

    if (scored.isEmpty) {
      return <ProductSuggestion>[
        ProductSuggestion(
          rawInput: rawInput,
          normalizedQuery: parsed.normalizedQuery,
          parsedQuantity: parsed.quantity,
          parsedUnit: parsed.unit,
          confidenceScore: 0.12,
          reasonCode: SuggestionReasonCode.unknownProduct,
        ),
      ];
    }

    return scored
        .take(maxResults)
        .map(
          (_ScoredSuggestion candidate) => ProductSuggestion(
            suggestedProduct: candidate.product,
            rawInput: rawInput,
            normalizedQuery: parsed.normalizedQuery,
            parsedQuantity: parsed.quantity,
            parsedUnit: parsed.unit,
            confidenceScore: candidate.confidence,
            reasonCode: candidate.reason,
          ),
        )
        .toList(growable: false);
  }

  _ScoredSuggestion _scoreProduct({
    required String parsedQuery,
    required Product product,
    required List<String> aliases,
    required ProductUsageStat? usage,
  }) {
    final String normalizedName = _normalizeText(product.canonicalName);
    final List<String> candidates = <String>[
      normalizedName,
      ...aliases.map(_normalizeText),
    ];

    int matchTier = 0;
    double fuzzyContribution = 0;

    if (candidates.any((String value) => value == parsedQuery)) {
      matchTier = 1000;
    } else if (candidates
        .any((String value) => value.startsWith(parsedQuery))) {
      matchTier = 800;
    } else if (candidates.any((String value) => value.contains(parsedQuery))) {
      matchTier = 600;
    } else {
      final double bestSimilarity = candidates
          .map((String value) => _similarity(parsedQuery, value))
          .fold<double>(
            0,
            (double best, double current) => current > best ? current : best,
          );

      if (bestSimilarity < 0.5) {
        return _ScoredSuggestion.none(product);
      }

      matchTier = 400;
      fuzzyContribution = bestSimilarity * 100;
    }

    final int frequency = usage?.frequency ?? 0;
    final double frequencyContribution = frequency.clamp(0, 1000) * 0.9;

    final DateTime? lastUsedAt = usage?.lastUsedAt;
    final double recencyContribution =
        lastUsedAt == null ? 0 : _recencyScore(lastUsedAt);

    final double totalScore = matchTier +
        fuzzyContribution +
        frequencyContribution +
        recencyContribution;

    final SuggestionReasonCode reason = switch (matchTier) {
      1000 => SuggestionReasonCode.exactMatch,
      800 => SuggestionReasonCode.startsWith,
      600 => SuggestionReasonCode.contains,
      _ => SuggestionReasonCode.fuzzy,
    };

    return _ScoredSuggestion(
      product: product,
      score: totalScore,
      reason: reason,
      confidence: _confidenceFromScore(totalScore),
    );
  }

  double _recencyScore(DateTime date) {
    final int daysAgo = DateTime.now().difference(date).inDays;
    if (daysAgo <= 1) {
      return 80;
    }
    if (daysAgo <= 3) {
      return 50;
    }
    if (daysAgo <= 7) {
      return 30;
    }
    if (daysAgo <= 30) {
      return 10;
    }
    return 0;
  }

  double _confidenceFromScore(double score) {
    if (score >= 1000) {
      return 0.98;
    }
    if (score >= 800) {
      return 0.9;
    }
    if (score >= 600) {
      return 0.8;
    }
    if (score >= 400) {
      return 0.68;
    }
    return 0.4;
  }

  Map<String, List<String>> _aliasesByProduct(List<ProductAlias> aliases) {
    final Map<String, List<String>> byProduct = <String, List<String>>{};
    for (final ProductAlias alias in aliases) {
      byProduct.putIfAbsent(alias.productId, () => <String>[]).add(alias.alias);
    }
    return byProduct;
  }

  _ParsedInput _parseInput(String rawInput) {
    final String normalized = _normalizeText(rawInput);
    if (normalized.isEmpty) {
      return const _ParsedInput(
        normalizedQuery: '',
        quantity: null,
        unit: null,
      );
    }

    final List<String> tokens = normalized
        .split(RegExp(r'\s+'))
        .where((String token) => token.isNotEmpty)
        .toList(growable: true);

    double? quantity;
    String? unit;

    final int firstNumberIndex = tokens.indexWhere(_isNumericToken);
    if (firstNumberIndex >= 0) {
      quantity = double.tryParse(tokens[firstNumberIndex]);

      if (firstNumberIndex + 1 < tokens.length) {
        final String maybeUnit = tokens[firstNumberIndex + 1];
        final String? normalizedUnit = _unitSynonyms[maybeUnit];
        if (normalizedUnit != null) {
          unit = normalizedUnit;
          tokens.removeAt(firstNumberIndex + 1);
        }
      }

      tokens.removeAt(firstNumberIndex);
    }

    if (unit == null) {
      final int trailingUnitIndex = tokens.lastIndexWhere(
        (String token) => _unitSynonyms.containsKey(token),
      );
      if (trailingUnitIndex >= 0) {
        unit = _unitSynonyms[tokens[trailingUnitIndex]];
        tokens.removeAt(trailingUnitIndex);
      }
    }

    final int trailingNumberIndex = tokens.lastIndexWhere(_isNumericToken);
    if (quantity == null && trailingNumberIndex >= 0) {
      quantity = double.tryParse(tokens[trailingNumberIndex]);
      tokens.removeAt(trailingNumberIndex);
    }

    return _ParsedInput(
      normalizedQuery: tokens.join(' ').trim(),
      quantity: quantity,
      unit: unit,
    );
  }

  bool _isNumericToken(String token) {
    return double.tryParse(token) != null;
  }

  double _similarity(String source, String target) {
    if (source == target) {
      return 1;
    }
    if (source.isEmpty || target.isEmpty) {
      return 0;
    }

    final int distance = _levenshteinDistance(source, target);
    final int maxLen =
        source.length > target.length ? source.length : target.length;
    return 1 - (distance / maxLen);
  }

  int _levenshteinDistance(String source, String target) {
    final List<int> previous =
        List<int>.generate(target.length + 1, (int i) => i);
    final List<int> current = List<int>.filled(target.length + 1, 0);

    for (int i = 1; i <= source.length; i++) {
      current[0] = i;
      for (int j = 1; j <= target.length; j++) {
        final int substitution =
            source.codeUnitAt(i - 1) == target.codeUnitAt(j - 1) ? 0 : 1;

        final int deletionCost = previous[j] + 1;
        final int insertionCost = current[j - 1] + 1;
        final int substitutionCost = previous[j - 1] + substitution;

        current[j] = deletionCost < insertionCost
            ? (deletionCost < substitutionCost
                ? deletionCost
                : substitutionCost)
            : (insertionCost < substitutionCost
                ? insertionCost
                : substitutionCost);
      }

      for (int j = 0; j <= target.length; j++) {
        previous[j] = current[j];
      }
    }

    return previous[target.length];
  }

  String _normalizeText(String input) {
    if (input.trim().isEmpty) {
      return '';
    }

    final String lower = input.toLowerCase();
    final String deAccented = lower
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ñ', 'n');

    return deAccented
        .replaceAll(RegExp(r'[^a-z0-9\s\.]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

class _ParsedInput {
  const _ParsedInput({
    required this.normalizedQuery,
    required this.quantity,
    required this.unit,
  });

  final String normalizedQuery;
  final double? quantity;
  final String? unit;
}

class _ScoredSuggestion {
  const _ScoredSuggestion({
    required this.product,
    required this.score,
    required this.reason,
    required this.confidence,
  });

  factory _ScoredSuggestion.none(Product product) {
    return _ScoredSuggestion(
      product: product,
      score: 0,
      reason: SuggestionReasonCode.unknownProduct,
      confidence: 0,
    );
  }

  final Product product;
  final double score;
  final SuggestionReasonCode reason;
  final double confidence;
}
