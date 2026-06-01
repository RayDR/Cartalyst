import 'dart:async';

import 'package:cartalyst_mobile/core/debug/debug_diagnostics.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/money.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/price_compare/application/price_compare_state.dart';
import 'package:cartalyst_mobile/features/price_compare/data/repositories/local_price_observation_repository.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/entities/price_observation.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/repositories/price_observation_repository.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/services/package_comparison_service.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/services/unit_conversion_service.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/services/unit_price_calculation_service.dart';
import 'package:cartalyst_mobile/features/products/data/repositories/local_product_repository.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
  show appDatabaseProvider, uuidProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final priceCompareProductRepositoryProvider =
    Provider<ProductRepository>((Ref ref) {
  return LocalProductRepository(ref.watch(appDatabaseProvider));
});

final priceObservationRepositoryProvider =
    Provider<PriceObservationRepository>((Ref ref) {
  return LocalPriceObservationRepository(
    ref.watch(appDatabaseProvider),
  );
});

final unitConversionServiceProvider =
    Provider<UnitConversionService>((Ref ref) {
  return const UnitConversionService();
});

final unitPriceCalculationServiceProvider =
    Provider<UnitPriceCalculationService>((Ref ref) {
  return UnitPriceCalculationService(ref.watch(unitConversionServiceProvider));
});

final packageComparisonServiceProvider =
    Provider<PackageComparisonService>((Ref ref) {
  return PackageComparisonService(
    ref.watch(unitPriceCalculationServiceProvider),
  );
});

final priceCompareControllerProvider =
    NotifierProvider<PriceCompareController, PriceCompareState>(
  PriceCompareController.new,
);

class PriceCompareController extends Notifier<PriceCompareState> {
  late final ProductRepository _productRepository;
  late final PriceObservationRepository _priceObservationRepository;
  late final PackageComparisonService _comparisonService;
  late final UnitConversionService _conversionService;
  late final Uuid _uuid;

  StreamSubscription<List<Product>>? _productsSubscription;

  static const List<String> unitOptions = UnitConversionService.supportedUnits;
  static const int minOptions = 2;
  static const int maxOptions = 5;

  @override
  PriceCompareState build() {
    _productRepository = ref.watch(priceCompareProductRepositoryProvider);
    _priceObservationRepository = ref.watch(priceObservationRepositoryProvider);
    _comparisonService = ref.watch(packageComparisonServiceProvider);
    _conversionService = ref.watch(unitConversionServiceProvider);
    _uuid = ref.watch(uuidProvider);
    _logDebug('controller initialized');

    ref.onDispose(() {
      _productsSubscription?.cancel();
    });

    _logDebug('products stream subscribed');
    _productsSubscription = _productRepository
        .watchActiveProducts()
        .listen((List<Product> products) {
      _logDebug('products stream emitted count=${products.length}');
      state = state.copyWith(products: products);
    }, onError: (Object error, StackTrace stackTrace) {
      _logDebugError(
        'products stream error',
        error,
        stackTrace,
      );
      state = state.copyWith(message: 'Unable to load products.');
    });

    return const PriceCompareState.initial();
  }

  void addOption() {
    if (!state.canAddMoreOptions) {
      return;
    }

    final List<PriceCompareOptionDraft> nextOptions = state.options
        .map(
          (PriceCompareOptionDraft option) => option.copyWith(
            isExpanded: option.hasRequiredFields ? false : option.isExpanded,
          ),
        )
        .toList(growable: true)
      ..add(
        PriceCompareOptionDraft.initial(
          id: _uuid.v4(),
          label: _labelForIndex(state.options.length),
        ),
      );

    state = state.copyWith(
      options: nextOptions,
      clearComparison: true,
      clearMessage: true,
    );
  }

  void removeOption(String optionId) {
    if (!state.canRemoveOptions) {
      return;
    }

    final List<PriceCompareOptionDraft> nextOptions = state.options
        .where((PriceCompareOptionDraft option) => option.id != optionId)
        .toList(growable: false);

    state = state.copyWith(
      options: _renumberOptions(nextOptions),
      clearComparison: true,
      clearMessage: true,
    );
  }

  void editOption(String optionId) {
    state = state.copyWith(
      options: state.options
          .map(
            (PriceCompareOptionDraft option) => option.copyWith(
              isExpanded: option.id == optionId,
            ),
          )
          .toList(growable: false),
      clearMessage: true,
    );
  }

  void collapseOption(String optionId) {
    state = state.copyWith(
      options: state.options
          .map(
            (PriceCompareOptionDraft option) =>
                option.id == optionId && option.hasRequiredFields
                    ? option.copyWith(isExpanded: false)
                    : option,
          )
          .toList(growable: false),
      clearMessage: true,
    );
  }

  void updateOptionPrice(String optionId, String value) {
    _updateOption(
      optionId,
      (PriceCompareOptionDraft option) => option.copyWith(price: value),
    );
  }

  void updateOptionQuantity(String optionId, String value) {
    _updateOption(
      optionId,
      (PriceCompareOptionDraft option) => option.copyWith(quantity: value),
    );
  }

  void updateOptionUnit(String optionId, String? unit) {
    _updateOption(
      optionId,
      (PriceCompareOptionDraft option) => unit == null
          ? option.copyWith(clearUnit: true)
          : option.copyWith(unit: unit),
    );
  }

  void updateOptionProduct(String optionId, String? productId) {
    _updateOption(
      optionId,
      (PriceCompareOptionDraft option) => productId == null
          ? option.copyWith(clearProductId: true)
          : option.copyWith(productId: productId),
    );
  }

  void updateOptionProductName(String optionId, String value) {
    _updateOption(
      optionId,
      (PriceCompareOptionDraft option) => option.copyWith(productName: value),
    );
  }

  void updateOptionStore(String optionId, String value) {
    _updateOption(
      optionId,
      (PriceCompareOptionDraft option) => option.copyWith(store: value),
    );
  }

  void updateOptionNotes(String optionId, String value) {
    _updateOption(
      optionId,
      (PriceCompareOptionDraft option) => option.copyWith(notes: value),
    );
  }

  Future<void> compare() async {
    _logDebug('compare started; options=${state.options.length}');

    if (state.options.length < minOptions) {
      _logDebug(
        'compare missing required option: need at least $minOptions options, found ${state.options.length}',
      );
      state = state.copyWith(
        clearComparison: true,
        message: 'Add at least two options to compare.',
      );
      return;
    }

    final PriceCompareOptionDraft? missingRequired =
        state.options.cast<PriceCompareOptionDraft?>().firstWhere(
              (PriceCompareOptionDraft? option) =>
                  option != null && !option.hasRequiredFields,
              orElse: () => null,
            );

    if (missingRequired != null) {
      _logDebug(
        'compare missing required option: ${missingRequired.label}',
      );
      state = state.copyWith(
        clearComparison: true,
        message:
            '${missingRequired.label} needs price, quantity, and unit before comparing.',
        options: state.options
            .map(
              (PriceCompareOptionDraft option) => option.copyWith(
                isExpanded: option.id == missingRequired.id,
              ),
            )
            .toList(growable: false),
      );
      return;
    }

    final List<PackageOptionInput> inputs = state.options
        .map(
          (PriceCompareOptionDraft option) => PackageOptionInput(
            label: option.label,
            price: double.tryParse(option.price.trim()) ?? double.nan,
            quantity: double.tryParse(option.quantity.trim()) ?? double.nan,
            unit: option.unit ?? '',
            productId: option.productId,
            productName: option.productName.trim().isEmpty
                ? null
                : option.productName.trim(),
            store: option.store.trim().isEmpty ? null : option.store.trim(),
            notes: option.notes.trim().isEmpty ? null : option.notes.trim(),
          ),
        )
        .toList(growable: false);

    try {
      final PackageComparisonResult result =
          _comparisonService.compareAll(inputs);

      _logDebug(
        'comparison result recommendation=${_recommendationLabel(result.recommendation)}',
      );

      state = state.copyWith(
        comparisonResult: result,
        message: result.explanation,
        options: state.options
            .map(
              (PriceCompareOptionDraft option) => option.copyWith(
                isExpanded:
                    option.hasRequiredFields ? false : option.isExpanded,
              ),
            )
            .toList(growable: false),
      );

      for (final PackageOptionInput option in inputs) {
        await _saveObservationIfPossible(option);
      }
    } catch (error, stackTrace) {
      _logDebugError('comparison failed', error, stackTrace);
      state = state.copyWith(
        clearComparison: true,
        message: 'Unable to compare options right now. Please try again.',
      );
    }
  }

  void reset() {
    state = state.copyWith(
      options: const <PriceCompareOptionDraft>[
        PriceCompareOptionDraft.initial(id: 'option-1', label: 'Option A'),
        PriceCompareOptionDraft.initial(id: 'option-2', label: 'Option B'),
      ],
      clearComparison: true,
      clearMessage: true,
    );
  }

  void _updateOption(
    String optionId,
    PriceCompareOptionDraft Function(PriceCompareOptionDraft option) transform,
  ) {
    state = state.copyWith(
      options: state.options
          .map(
            (PriceCompareOptionDraft option) => option.id == optionId
                ? transform(option).copyWith(isExpanded: true)
                : option,
          )
          .toList(growable: false),
      clearComparison: true,
      clearMessage: true,
    );
  }

  List<PriceCompareOptionDraft> _renumberOptions(
    List<PriceCompareOptionDraft> options,
  ) {
    return options
        .asMap()
        .entries
        .map((MapEntry<int, PriceCompareOptionDraft> entry) {
      return entry.value.copyWith(label: _labelForIndex(entry.key));
    }).toList(growable: false);
  }

  String _labelForIndex(int index) {
    return 'Option ${String.fromCharCode(65 + index)}';
  }

  Future<void> _saveObservationIfPossible(PackageOptionInput option) async {
    final String? productId = option.productId;
    if (productId == null || productId.trim().isEmpty) {
      _logDebug(
        'save observation skipped reason: ${option.label} has no product selected',
      );
      return;
    }

    final UnitPriceCalculationResult unitPrice =
        ref.read(unitPriceCalculationServiceProvider).calculate(
              totalPrice: option.price,
              quantity: option.quantity,
              unit: option.unit,
            );

    if (!unitPrice.isValid || unitPrice.unitPrice == null) {
      _logDebug(
        'save observation skipped reason: ${option.label} has invalid unit price (${unitPrice.reason})',
      );
      return;
    }

    final _PersistenceQuantity persistence = _toPersistenceQuantity(
      quantity: option.quantity,
      unit: option.unit,
    );

    if (!persistence.isValid ||
        persistence.quantity == null ||
        persistence.unitCode == null) {
      _logDebug(
        'save observation skipped reason: ${option.label} cannot be persisted with unit ${option.unit}',
      );
      return;
    }

    final DateTime now = DateTime.now();

    final PriceObservation observation = PriceObservation(
      id: _uuid.v4(),
      productId: productId,
      packageQuantity: persistence.quantity!,
      packageUnit: Unit.fromCode(persistence.unitCode!),
      price: Money.fromMajor(amount: option.price),
      unitPrice: Money.fromMajor(
        amount: option.price / persistence.quantity!,
      ),
      observedAt: now,
      createdAt: now,
    );

    try {
      await _priceObservationRepository.addObservation(observation);
    } catch (error, stackTrace) {
      _logDebugError(
        'save observation failed',
        error,
        stackTrace,
      );
      state = state.copyWith(
        message: 'Comparison done, but saving observation failed.',
      );
    }
  }

  void _logDebug(String message) {
    assert(() {
      debugDiagnosticsStore.addLog(
        message: message,
        source: 'PriceCompareController',
      );
      return true;
    }());
  }

  void _logDebugError(String message, Object error, StackTrace stackTrace) {
    assert(() {
      debugDiagnosticsStore.addError(
        error: '$message: $error',
        stackTrace: stackTrace,
        source: 'PriceCompareController',
      );
      return true;
    }());
  }

  String _recommendationLabel(PackageRecommendation recommendation) {
    return recommendation.name;
  }

  _PersistenceQuantity _toPersistenceQuantity({
    required double quantity,
    required String unit,
  }) {
    final String normalizedUnit = _conversionService.normalizeUnitAlias(unit);

    if (!quantity.isFinite || quantity <= 0) {
      return const _PersistenceQuantity.invalid();
    }

    if (normalizedUnit == 'piece') {
      return _PersistenceQuantity.valid(
        quantity: quantity,
        unitCode: 'unit',
      );
    }

    if (normalizedUnit == 'pack') {
      return _PersistenceQuantity.valid(
        quantity: quantity,
        unitCode: 'pack',
      );
    }

    if (normalizedUnit == 'g' || normalizedUnit == 'kg') {
      final UnitConversionResult toGrams = _conversionService.convert(
        quantity: quantity,
        fromUnit: normalizedUnit,
        toUnit: 'g',
      );
      if (!toGrams.isValid || toGrams.convertedQuantity == null) {
        return const _PersistenceQuantity.invalid();
      }
      return _PersistenceQuantity.valid(
        quantity: toGrams.convertedQuantity!,
        unitCode: 'g',
      );
    }

    if (normalizedUnit == 'oz' || normalizedUnit == 'lb') {
      final UnitConversionResult toGrams = _conversionService.convert(
        quantity: quantity,
        fromUnit: normalizedUnit,
        toUnit: 'g',
      );
      if (!toGrams.isValid || toGrams.convertedQuantity == null) {
        return const _PersistenceQuantity.invalid();
      }
      return _PersistenceQuantity.valid(
        quantity: toGrams.convertedQuantity!,
        unitCode: 'g',
      );
    }

    if (normalizedUnit == 'ml') {
      return _PersistenceQuantity.valid(
        quantity: quantity,
        unitCode: 'ml',
      );
    }

    if (normalizedUnit == 'l') {
      return _PersistenceQuantity.valid(
        quantity: quantity,
        unitCode: 'liter',
      );
    }

    if (normalizedUnit == 'gal') {
      final UnitConversionResult toLiter = _conversionService.convert(
        quantity: quantity,
        fromUnit: 'gal',
        toUnit: 'l',
      );
      if (!toLiter.isValid || toLiter.convertedQuantity == null) {
        return const _PersistenceQuantity.invalid();
      }
      return _PersistenceQuantity.valid(
        quantity: toLiter.convertedQuantity!,
        unitCode: 'liter',
      );
    }

    return const _PersistenceQuantity.invalid();
  }
}

class _PersistenceQuantity {
  const _PersistenceQuantity.valid({
    required this.quantity,
    required this.unitCode,
  }) : isValid = true;

  const _PersistenceQuantity.invalid()
      : isValid = false,
        quantity = null,
        unitCode = null;

  final bool isValid;
  final double? quantity;
  final String? unitCode;
}
