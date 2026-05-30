import 'dart:async';

import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/inventories/data/repositories/local_inventory_repository.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show appDatabaseProvider, uuidProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((Ref ref) {
  return LocalInventoryRepository(ref.watch(appDatabaseProvider));
});

final inventoriesControllerProvider =
    NotifierProvider<InventoriesController, InventoriesState>(
  InventoriesController.new,
);

class InventoriesController extends Notifier<InventoriesState> {
  late final InventoryRepository _repository;
  late final Uuid _uuid;
  StreamSubscription<List<Inventory>>? _subscription;

  @override
  InventoriesState build() {
    _repository = ref.watch(inventoryRepositoryProvider);
    _uuid = ref.watch(uuidProvider);
    ref.onDispose(() => _subscription?.cancel());
    _subscribe();
    return const InventoriesState.initial();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _repository.watchAllInventories().listen((inventories) {
      state = state.copyWith(inventories: inventories);
    });
  }

  /// Creates a new inventory with [name]. Returns the new inventory's id on
  /// success, or null if the name is blank.
  Future<String?> createInventory(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final DateTime now = DateTime.now();
    final Inventory inventory = Inventory(
      id: _uuid.v4(),
      name: trimmed,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending_sync',
      version: 1,
    );

    state = state.copyWith(isBusy: true, clearErrorMessage: true);
    try {
      await _repository.saveInventory(inventory);
      state = state.copyWith(isBusy: false);
      return inventory.id;
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to create inventory.',
      );
      return null;
    }
  }

  Future<void> renameInventory(Inventory inventory, String newName) async {
    final String trimmed = newName.trim();
    if (trimmed.isEmpty || trimmed == inventory.name) return;

    final Inventory updated = inventory.copyWith(
      name: trimmed,
      updatedAt: DateTime.now(),
      version: inventory.version + 1,
      syncStatus: 'pending_sync',
    );

    state = state.copyWith(isBusy: true, clearErrorMessage: true);
    try {
      await _repository.saveInventory(updated);
      state = state.copyWith(isBusy: false);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to rename inventory.',
      );
    }
  }

  Future<void> deleteInventory(Inventory inventory) async {
    state = state.copyWith(
      isBusy: true,
      clearErrorMessage: true,
      lastDeletedInventory: inventory,
    );
    try {
      await _repository.deleteInventory(inventory.id);
      state = state.copyWith(isBusy: false);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to delete inventory.',
        clearLastDeleted: true,
      );
    }
  }

  Future<void> restoreLastDeleted() async {
    final Inventory? toRestore = state.lastDeletedInventory;
    if (toRestore == null) return;

    final Inventory restored = toRestore.copyWith(
      deletedAt: null,
      updatedAt: DateTime.now(),
      version: toRestore.version + 1,
      syncStatus: 'pending_sync',
    );

    state = state.copyWith(isBusy: true, clearLastDeleted: true);
    try {
      await _repository.saveInventory(restored);
      state = state.copyWith(isBusy: false);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to restore inventory.',
      );
    }
  }
}
