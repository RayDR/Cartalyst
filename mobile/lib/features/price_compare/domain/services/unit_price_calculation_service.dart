import 'package:cartalyst_mobile/features/price_compare/domain/services/unit_conversion_service.dart';

class UnitPriceCalculationResult {
  const UnitPriceCalculationResult({
    required this.isValid,
    required this.reason,
    required this.inputUnit,
    this.unitPrice,
    this.normalizedQuantity,
    this.normalizedUnit,
    this.family,
  });

  final bool isValid;
  final double? unitPrice;
  final double? normalizedQuantity;
  final String? normalizedUnit;
  final UnitFamily? family;
  final String reason;
  final String inputUnit;
}

class UnitPriceCalculationService {
  const UnitPriceCalculationService(this._conversionService);

  final UnitConversionService _conversionService;

  UnitPriceCalculationResult calculate({
    required double totalPrice,
    required double quantity,
    required String unit,
  }) {
    final String normalizedUnit = _conversionService.normalizeUnitAlias(unit);

    if (!totalPrice.isFinite || !quantity.isFinite) {
      return UnitPriceCalculationResult(
        isValid: false,
        reason: 'Price and quantity must be finite numbers.',
        inputUnit: normalizedUnit,
      );
    }

    if (totalPrice < 0) {
      return UnitPriceCalculationResult(
        isValid: false,
        reason: 'Price cannot be negative.',
        inputUnit: normalizedUnit,
      );
    }

    final UnitFamily? family = _conversionService.familyFor(normalizedUnit);
    if (family == null) {
      return UnitPriceCalculationResult(
        isValid: false,
        reason: 'Unsupported unit.',
        inputUnit: normalizedUnit,
      );
    }

    final String baseUnit = _conversionService.baseUnitForFamily(family);
    final UnitConversionResult conversion = _conversionService.convert(
      quantity: quantity,
      fromUnit: normalizedUnit,
      toUnit: baseUnit,
    );

    if (!conversion.isValid || conversion.convertedQuantity == null) {
      return UnitPriceCalculationResult(
        isValid: false,
        reason: conversion.reason,
        inputUnit: normalizedUnit,
      );
    }

    final double baseQuantity = conversion.convertedQuantity!;
    if (baseQuantity <= 0) {
      return UnitPriceCalculationResult(
        isValid: false,
        reason: 'Quantity must be greater than zero.',
        inputUnit: normalizedUnit,
      );
    }

    final double unitPrice = totalPrice / baseQuantity;

    return UnitPriceCalculationResult(
      isValid: true,
      reason: 'Unit price calculated successfully.',
      unitPrice: unitPrice,
      normalizedQuantity: baseQuantity,
      normalizedUnit: baseUnit,
      family: family,
      inputUnit: normalizedUnit,
    );
  }
}
