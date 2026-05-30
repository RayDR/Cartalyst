import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';

class InventoriesState {
  const InventoriesState({
    required this.isBusy,
    required this.inventories,
    this.lastDeletedInventory,
    this.errorMessage,
  });

  const InventoriesState.initial()
      : isBusy = false,
        inventories = const <Inventory>[],
        lastDeletedInventory = null,
        errorMessage = null;

  final bool isBusy;
  final List<Inventory> inventories;
  final Inventory? lastDeletedInventory;
  final String? errorMessage;

  bool get isEmpty => inventories.isEmpty;

  List<Inventory> get recentInventories => inventories.length > 5
      ? inventories.sublist(0, 5)
      : List<Inventory>.unmodifiable(inventories);

  InventoriesState copyWith({
    bool? isBusy,
    List<Inventory>? inventories,
    Inventory? lastDeletedInventory,
    String? errorMessage,
    bool clearLastDeleted = false,
    bool clearErrorMessage = false,
  }) {
    return InventoriesState(
      isBusy: isBusy ?? this.isBusy,
      inventories: inventories ?? this.inventories,
      lastDeletedInventory: clearLastDeleted
          ? null
          : (lastDeletedInventory ?? this.lastDeletedInventory),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
