import 'package:cartalyst_mobile/features/price_compare/domain/services/package_comparison_service.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';

class PriceCompareState {
  const PriceCompareState({
    required this.products,
    required this.optionOnePrice,
    required this.optionOneQuantity,
    required this.optionOneUnit,
    required this.optionOneProductId,
    required this.optionTwoPrice,
    required this.optionTwoQuantity,
    required this.optionTwoUnit,
    required this.optionTwoProductId,
    required this.comparisonResult,
    required this.isBusy,
    required this.message,
  });

  const PriceCompareState.initial()
    : products = const <Product>[],
      optionOnePrice = '',
      optionOneQuantity = '',
      optionOneUnit = 'piece',
      optionOneProductId = null,
      optionTwoPrice = '',
      optionTwoQuantity = '',
      optionTwoUnit = 'piece',
      optionTwoProductId = null,
      comparisonResult = null,
      isBusy = false,
      message = null;

  final List<Product> products;
  final String optionOnePrice;
  final String optionOneQuantity;
  final String optionOneUnit;
  final String? optionOneProductId;
  final String optionTwoPrice;
  final String optionTwoQuantity;
  final String optionTwoUnit;
  final String? optionTwoProductId;
  final PackageComparisonResult? comparisonResult;
  final bool isBusy;
  final String? message;

  PriceCompareState copyWith({
    List<Product>? products,
    String? optionOnePrice,
    String? optionOneQuantity,
    String? optionOneUnit,
    String? optionOneProductId,
    bool clearOptionOneProductId = false,
    String? optionTwoPrice,
    String? optionTwoQuantity,
    String? optionTwoUnit,
    String? optionTwoProductId,
    bool clearOptionTwoProductId = false,
    PackageComparisonResult? comparisonResult,
    bool clearComparison = false,
    bool? isBusy,
    String? message,
    bool clearMessage = false,
  }) {
    return PriceCompareState(
      products: products ?? this.products,
      optionOnePrice: optionOnePrice ?? this.optionOnePrice,
      optionOneQuantity: optionOneQuantity ?? this.optionOneQuantity,
      optionOneUnit: optionOneUnit ?? this.optionOneUnit,
      optionOneProductId: clearOptionOneProductId
          ? null
          : (optionOneProductId ?? this.optionOneProductId),
      optionTwoPrice: optionTwoPrice ?? this.optionTwoPrice,
      optionTwoQuantity: optionTwoQuantity ?? this.optionTwoQuantity,
      optionTwoUnit: optionTwoUnit ?? this.optionTwoUnit,
      optionTwoProductId: clearOptionTwoProductId
          ? null
          : (optionTwoProductId ?? this.optionTwoProductId),
      comparisonResult: clearComparison ? null : (comparisonResult ?? this.comparisonResult),
      isBusy: isBusy ?? this.isBusy,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
