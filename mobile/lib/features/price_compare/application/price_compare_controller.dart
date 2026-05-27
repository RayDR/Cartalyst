import 'dart:async';

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
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' show AppDatabase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final priceCompareDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final priceCompareProductRepositoryProvider = Provider<ProductRepository>((Ref ref) {
  return LocalProductRepository(ref.watch(priceCompareDatabaseProvider));
});

final priceObservationRepositoryProvider = Provider<PriceObservationRepository>((Ref ref) {
  return LocalPriceObservationRepository(ref.watch(priceCompareDatabaseProvider));
});

final unitConversionServiceProvider = Provider<UnitConversionService>((Ref ref) {
  return const UnitConversionService();
});

final unitPriceCalculationServiceProvider = Provider<UnitPriceCalculationService>((Ref ref) {
  return UnitPriceCalculationService(ref.watch(unitConversionServiceProvider));
});

final packageComparisonServiceProvider = Provider<PackageComparisonService>((Ref ref) {
  return PackageComparisonService(ref.watch(unitPriceCalculationServiceProvider));
});

final priceCompareUuidProvider = Provider<Uuid>((Ref ref) {
  return const Uuid();
});

final priceCompareControllerProvider =
    NotifierProvider<PriceCompareController, PriceCompareState>(PriceCompareController.new);

class PriceCompareController extends Notifier<PriceCompareState> {
  late final ProductRepository _productRepository;
  late final PriceObservationRepository _priceObservationRepository;
  late final PackageComparisonService _comparisonService;
  late final UnitConversionService _conversionService;
  late final Uuid _uuid;

  StreamSubscription<List<Product>>? _productsSubscription;

  static const List<String> unitOptions = UnitConversionService.supportedUnits;

  @override
  PriceCompareState build() {
    _productRepository = ref.watch(priceCompareProductRepositoryProvider);
    _priceObservationRepository = ref.watch(priceObservationRepositoryProvider);
    _comparisonService = ref.watch(packageComparisonServiceProvider);
    _conversionService = ref.watch(unitConversionServiceProvider);
    _uuid = ref.watch(priceCompareUuidProvider);

    ref.onDispose(() {
      _productsSubscription?.cancel();
    });

    _productsSubscription = _productRepository.watchActiveProducts().listen((List<Product> products) {
      state = state.copyWith(products: products);
    });

    return const PriceCompareState.initial();
  }

  void updateOptionOnePrice(String value) {
    state = state.copyWith(optionOnePrice: value, clearMessage: true);
  }

  void updateOptionOneQuantity(String value) {
    state = state.copyWith(optionOneQuantity: value, clearMessage: true);
  }

  void updateOptionOneUnit(String unit) {
    state = state.copyWith(optionOneUnit: unit, clearMessage: true);
  }

  void updateOptionOneProduct(String? productId) {
    state = productId == null
        ? state.copyWith(clearOptionOneProductId: true)
        : state.copyWith(optionOneProductId: productId);
  }

  void updateOptionTwoPrice(String value) {
    state = state.copyWith(optionTwoPrice: value, clearMessage: true);
  }

  void updateOptionTwoQuantity(String value) {
    state = state.copyWith(optionTwoQuantity: value, clearMessage: true);
  }

  void updateOptionTwoUnit(String unit) {
    state = state.copyWith(optionTwoUnit: unit, clearMessage: true);
  }

  void updateOptionTwoProduct(String? productId) {
    state = productId == null
        ? state.copyWith(clearOptionTwoProductId: true)
        : state.copyWith(optionTwoProductId: productId);
  }

  Future<void> compare() async {
    final double parsedOptionOnePrice = double.tryParse(state.optionOnePrice.trim()) ?? double.nan;
    final double parsedOptionOneQuantity =
        double.tryParse(state.optionOneQuantity.trim()) ?? double.nan;

    final double parsedOptionTwoPrice = double.tryParse(state.optionTwoPrice.trim()) ?? double.nan;
    final double parsedOptionTwoQuantity =
        double.tryParse(state.optionTwoQuantity.trim()) ?? double.nan;

    final PackageOptionInput first = PackageOptionInput(
      label: 'Option A',
      price: parsedOptionOnePrice,
      quantity: parsedOptionOneQuantity,
      unit: state.optionOneUnit,
      productId: state.optionOneProductId,
    );

    final PackageOptionInput second = PackageOptionInput(
      label: 'Option B',
      price: parsedOptionTwoPrice,
      quantity: parsedOptionTwoQuantity,
      unit: state.optionTwoUnit,
      productId: state.optionTwoProductId,
    );

    final PackageComparisonResult result = _comparisonService.compare(
      first: first,
      second: second,
    );

    state = state.copyWith(
      comparisonResult: result,
      message: result.explanation,
    );

    await _saveObservationIfPossible(first);
    await _saveObservationIfPossible(second);
  }

  void reset() {
    state = state.copyWith(
      optionOnePrice: '',
      optionOneQuantity: '',
      optionOneUnit: 'piece',
      clearOptionOneProductId: true,
      optionTwoPrice: '',
      optionTwoQuantity: '',
      optionTwoUnit: 'piece',
      clearOptionTwoProductId: true,
      clearComparison: true,
      clearMessage: true,
    );
  }

  Future<void> _saveObservationIfPossible(PackageOptionInput option) async {
    final String? productId = option.productId;
    if (productId == null || productId.trim().isEmpty) {
      return;
    }

    final UnitPriceCalculationResult unitPrice = ref
        .read(unitPriceCalculationServiceProvider)
        .calculate(totalPrice: option.price, quantity: option.quantity, unit: option.unit);

    if (!unitPrice.isValid || unitPrice.unitPrice == null) {
      return;
    }

    final _PersistenceQuantity persistence = _toPersistenceQuantity(
      quantity: option.quantity,
      unit: option.unit,
    );

    if (!persistence.isValid || persistence.quantity == null || persistence.unitCode == null) {
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
    } catch (_) {
      state = state.copyWith(message: 'Comparison done, but saving observation failed.');
    }
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
