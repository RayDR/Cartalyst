enum UnitFamily {
  count,
  weight,
  volume,
}

class UnitConversionResult {
  const UnitConversionResult({
    required this.isValid,
    required this.reason,
    required this.fromUnit,
    required this.toUnit,
    this.convertedQuantity,
    this.family,
  });

  final bool isValid;
  final double? convertedQuantity;
  final UnitFamily? family;
  final String reason;
  final String fromUnit;
  final String toUnit;
}

class UnitConversionService {
  const UnitConversionService();

  static const List<String> supportedUnits = <String>[
    'piece',
    'pack',
    'oz',
    'lb',
    'g',
    'kg',
    'ml',
    'l',
    'gal',
  ];

  UnitConversionResult convert({
    required double quantity,
    required String fromUnit,
    required String toUnit,
  }) {
    final String normalizedFrom = _normalizeUnit(fromUnit);
    final String normalizedTo = _normalizeUnit(toUnit);

    if (!quantity.isFinite) {
      return UnitConversionResult(
        isValid: false,
        reason: 'Quantity must be a finite number.',
        fromUnit: normalizedFrom,
        toUnit: normalizedTo,
      );
    }

    if (quantity <= 0) {
      return UnitConversionResult(
        isValid: false,
        reason: 'Quantity must be greater than zero.',
        fromUnit: normalizedFrom,
        toUnit: normalizedTo,
      );
    }

    if (!supportedUnits.contains(normalizedFrom) ||
        !supportedUnits.contains(normalizedTo)) {
      return UnitConversionResult(
        isValid: false,
        reason: 'Unsupported unit provided.',
        fromUnit: normalizedFrom,
        toUnit: normalizedTo,
      );
    }

    final UnitFamily? fromFamily = familyFor(normalizedFrom);
    final UnitFamily? toFamily = familyFor(normalizedTo);

    if (fromFamily == null || toFamily == null || fromFamily != toFamily) {
      return UnitConversionResult(
        isValid: false,
        reason: 'Units are not in the same family and cannot be compared.',
        fromUnit: normalizedFrom,
        toUnit: normalizedTo,
      );
    }

    final double baseValue = quantity * _factorToBase(normalizedFrom);
    final double converted = baseValue / _factorToBase(normalizedTo);

    return UnitConversionResult(
      isValid: true,
      reason: 'Conversion successful.',
      convertedQuantity: converted,
      family: fromFamily,
      fromUnit: normalizedFrom,
      toUnit: normalizedTo,
    );
  }

  UnitFamily? familyFor(String unit) {
    final String normalized = _normalizeUnit(unit);

    if (normalized == 'piece' || normalized == 'pack') {
      return UnitFamily.count;
    }

    if (normalized == 'oz' || normalized == 'lb' || normalized == 'g' || normalized == 'kg') {
      return UnitFamily.weight;
    }

    if (normalized == 'ml' || normalized == 'l' || normalized == 'gal') {
      return UnitFamily.volume;
    }

    return null;
  }

  String normalizeUnitAlias(String unit) {
    return _normalizeUnit(unit);
  }

  String baseUnitForFamily(UnitFamily family) {
    return switch (family) {
      UnitFamily.count => 'piece',
      UnitFamily.weight => 'g',
      UnitFamily.volume => 'ml',
    };
  }

  double _factorToBase(String unit) {
    return switch (unit) {
      'piece' => 1,
      'pack' => 1,
      'oz' => 28.349523125,
      'lb' => 453.59237,
      'g' => 1,
      'kg' => 1000,
      'ml' => 1,
      'l' => 1000,
      'gal' => 3785.411784,
      _ => 1,
    };
  }

  String _normalizeUnit(String unit) {
    final String normalized = unit.trim().toLowerCase();

    return switch (normalized) {
      'pieces' || 'pcs' || 'pc' => 'piece',
      'packs' => 'pack',
      'liter' || 'liters' || 'litre' || 'litres' => 'l',
      'gallon' || 'gallons' => 'gal',
      _ => normalized,
    };
  }
}
