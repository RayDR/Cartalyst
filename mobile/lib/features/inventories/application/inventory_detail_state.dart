import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';

class InventoryDetailState {
  const InventoryDetailState({
    required this.isBusy,
    required this.products,
    required this.inStockItems,
    required this.lowItems,
    required this.finishedItems,
    required this.nameInput,
    required this.quantityInput,
    required this.unitCode,
    this.selectedProductId,
    this.message,
  });

  const InventoryDetailState.initial()
      : isBusy = false,
        products = const <Product>[],
        inStockItems = const <InventoryItem>[],
        lowItems = const <InventoryItem>[],
        finishedItems = const <InventoryItem>[],
        nameInput = '',
        quantityInput = '',
        unitCode = 'unit',
        selectedProductId = null,
        message = null;

  final bool isBusy;
  final List<Product> products;
  final List<InventoryItem> inStockItems;
  final List<InventoryItem> lowItems;
  final List<InventoryItem> finishedItems;
  final String nameInput;
  final String quantityInput;
  final String unitCode;
  final String? selectedProductId;
  final String? message;

  bool get hasAnyItems =>
      inStockItems.isNotEmpty || lowItems.isNotEmpty || finishedItems.isNotEmpty;

  InventoryDetailState copyWith({
    bool? isBusy,
    List<Product>? products,
    List<InventoryItem>? inStockItems,
    List<InventoryItem>? lowItems,
    List<InventoryItem>? finishedItems,
    String? nameInput,
    String? quantityInput,
    String? unitCode,
    String? selectedProductId,
    String? message,
    bool clearSelectedProduct = false,
    bool clearMessage = false,
  }) {
    return InventoryDetailState(
      isBusy: isBusy ?? this.isBusy,
      products: products ?? this.products,
      inStockItems: inStockItems ?? this.inStockItems,
      lowItems: lowItems ?? this.lowItems,
      finishedItems: finishedItems ?? this.finishedItems,
      nameInput: nameInput ?? this.nameInput,
      quantityInput: quantityInput ?? this.quantityInput,
      unitCode: unitCode ?? this.unitCode,
      selectedProductId: clearSelectedProduct
          ? null
          : (selectedProductId ?? this.selectedProductId),
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
