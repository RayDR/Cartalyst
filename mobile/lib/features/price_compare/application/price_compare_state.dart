import 'package:cartalyst_mobile/features/price_compare/domain/services/package_comparison_service.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';

class PriceCompareOptionDraft {
  const PriceCompareOptionDraft({
    required this.id,
    required this.label,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.productId,
    required this.isExpanded,
  });

  const PriceCompareOptionDraft.initial({
    required this.id,
    required this.label,
    this.isExpanded = true,
  })  : price = '',
        quantity = '',
        unit = null,
        productId = null;

  final String id;
  final String label;
  final String price;
  final String quantity;
  final String? unit;
  final String? productId;
  final bool isExpanded;

  bool get hasRequiredFields =>
      price.trim().isNotEmpty &&
      quantity.trim().isNotEmpty &&
      unit != null &&
      unit!.trim().isNotEmpty;

  bool get showsCompactCard => hasRequiredFields && !isExpanded;

  String get compactSummary {
    final String unitLabel = unit ?? 'No unit';
    final String priceLabel = price.trim().isEmpty ? 'No price' : '\$$price';
    final String quantityLabel =
        quantity.trim().isEmpty ? 'No quantity' : '$quantity $unitLabel';
    return '$priceLabel • $quantityLabel';
  }

  PriceCompareOptionDraft copyWith({
    String? id,
    String? label,
    String? price,
    String? quantity,
    String? unit,
    bool clearUnit = false,
    String? productId,
    bool clearProductId = false,
    bool? isExpanded,
  }) {
    return PriceCompareOptionDraft(
      id: id ?? this.id,
      label: label ?? this.label,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      unit: clearUnit ? null : (unit ?? this.unit),
      productId: clearProductId ? null : (productId ?? this.productId),
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class PriceCompareState {
  const PriceCompareState({
    required this.products,
    required this.options,
    required this.comparisonResult,
    required this.isBusy,
    required this.message,
  });

  const PriceCompareState.initial()
      : products = const <Product>[],
        options = const <PriceCompareOptionDraft>[
          PriceCompareOptionDraft.initial(id: 'option-1', label: 'Option A'),
          PriceCompareOptionDraft.initial(id: 'option-2', label: 'Option B'),
        ],
        comparisonResult = null,
        isBusy = false,
        message = null;

  final List<Product> products;
  final List<PriceCompareOptionDraft> options;
  final PackageComparisonResult? comparisonResult;
  final bool isBusy;
  final String? message;

  bool get canAddMoreOptions => options.length < 5;

  bool get canRemoveOptions => options.length > 2;

  PriceCompareState copyWith({
    List<Product>? products,
    List<PriceCompareOptionDraft>? options,
    PackageComparisonResult? comparisonResult,
    bool clearComparison = false,
    bool? isBusy,
    String? message,
    bool clearMessage = false,
  }) {
    return PriceCompareState(
      products: products ?? this.products,
      options: options ?? this.options,
      comparisonResult:
          clearComparison ? null : (comparisonResult ?? this.comparisonResult),
      isBusy: isBusy ?? this.isBusy,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
