import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';

class PantryState {
  const PantryState({
    required this.products,
    required this.inStockItems,
    required this.lowItems,
    required this.finishedItems,
    required this.nameInput,
    required this.selectedProductId,
    required this.quantityInput,
    required this.unitCode,
    required this.isBusy,
    required this.message,
  });

  const PantryState.initial()
      : products = const <Product>[],
        inStockItems = const <PantryItem>[],
        lowItems = const <PantryItem>[],
        finishedItems = const <PantryItem>[],
        nameInput = '',
        selectedProductId = null,
        quantityInput = '',
        unitCode = 'unit',
        isBusy = false,
        message = null;

  final List<Product> products;
  final List<PantryItem> inStockItems;
  final List<PantryItem> lowItems;
  final List<PantryItem> finishedItems;

  final String nameInput;
  final String? selectedProductId;
  final String quantityInput;
  final String unitCode;

  final bool isBusy;
  final String? message;

  bool get hasAnyItems =>
      inStockItems.isNotEmpty ||
      lowItems.isNotEmpty ||
      finishedItems.isNotEmpty;

  PantryState copyWith({
    List<Product>? products,
    List<PantryItem>? inStockItems,
    List<PantryItem>? lowItems,
    List<PantryItem>? finishedItems,
    String? nameInput,
    String? selectedProductId,
    bool clearSelectedProduct = false,
    String? quantityInput,
    String? unitCode,
    bool? isBusy,
    String? message,
    bool clearMessage = false,
  }) {
    return PantryState(
      products: products ?? this.products,
      inStockItems: inStockItems ?? this.inStockItems,
      lowItems: lowItems ?? this.lowItems,
      finishedItems: finishedItems ?? this.finishedItems,
      nameInput: nameInput ?? this.nameInput,
      selectedProductId: clearSelectedProduct
          ? null
          : (selectedProductId ?? this.selectedProductId),
      quantityInput: quantityInput ?? this.quantityInput,
      unitCode: unitCode ?? this.unitCode,
      isBusy: isBusy ?? this.isBusy,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
