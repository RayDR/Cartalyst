import 'dart:async';

import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show shoppingListRepositoryProvider, uuidProvider;
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final listsControllerProvider =
    NotifierProvider<ListsController, ListsState>(ListsController.new);

class ListsController extends Notifier<ListsState> {
  late final ShoppingListRepository _repository;
  late final Uuid _uuid;

  StreamSubscription<List<ShoppingList>>? _subscription;

  @override
  ListsState build() {
    _repository = ref.watch(shoppingListRepositoryProvider);
    _uuid = ref.watch(uuidProvider);

    ref.onDispose(() => _subscription?.cancel());

    _subscribe();
    return const ListsState.initial();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription =
        _repository.watchAllLists().listen((List<ShoppingList> lists) {
      state = state.copyWith(lists: lists);
    });
  }

  /// Creates a new list with [name]. Returns the new list's id on success, null on failure.
  Future<String?> createList(String name, {String? inventoryId}) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final DateTime now = DateTime.now();
    final ShoppingList list = ShoppingList(
      id: _uuid.v4(),
      inventoryId: inventoryId,
      name: trimmed,
      status: ShoppingListStatus.active,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending_sync',
      version: 1,
    );

    state = state.copyWith(isBusy: true, clearErrorMessage: true);
    try {
      await _repository.saveShoppingList(list);
      state = state.copyWith(isBusy: false);
      return list.id;
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to create list.',
      );
      return null;
    }
  }

  Future<void> renameList(ShoppingList list, String newName) async {
    final String trimmed = newName.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final DateTime now = DateTime.now();
    final ShoppingList updated = ShoppingList(
      id: list.id,
      inventoryId: list.inventoryId,
      name: trimmed,
      status: list.status,
      createdAt: list.createdAt,
      updatedAt: now,
      deletedAt: list.deletedAt,
      syncStatus: 'pending_sync',
      version: list.version + 1,
    );

    try {
      await _repository.saveShoppingList(updated);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to rename list.');
    }
  }

  Future<void> deleteList(ShoppingList list) async {
    state = state.copyWith(lastDeletedList: list);
    try {
      await _repository.deleteShoppingList(list.id);
    } catch (_) {
      state = state.copyWith(
        clearLastDeleted: true,
        errorMessage: 'Unable to delete list.',
      );
    }
  }

  /// Undoes the most recent soft delete. No-op if nothing to restore.
  Future<void> restoreLastDeleted() async {
    final ShoppingList? deleted = state.lastDeletedList;
    if (deleted == null) {
      return;
    }

    final DateTime now = DateTime.now();
    final ShoppingList restored = ShoppingList(
      id: deleted.id,
      inventoryId: deleted.inventoryId,
      name: deleted.name,
      status: deleted.status,
      createdAt: deleted.createdAt,
      updatedAt: now,
      syncStatus: 'pending_sync',
      version: deleted.version + 1,
    );

    state = state.copyWith(clearLastDeleted: true);
    try {
      await _repository.saveShoppingList(restored);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to restore list.');
    }
  }

  Future<void> linkToInventory(ShoppingList list, String inventoryId) {
    return updateLinkedInventory(list, inventoryId);
  }

  Future<void> unlinkFromInventory(ShoppingList list) {
    return updateLinkedInventory(list, null);
  }

  Future<void> updateLinkedInventory(
    ShoppingList list,
    String? inventoryId,
  ) async {
    final DateTime now = DateTime.now();
    final ShoppingList updated = ShoppingList(
      id: list.id,
      inventoryId: inventoryId,
      name: list.name,
      status: list.status,
      createdAt: list.createdAt,
      updatedAt: now,
      deletedAt: list.deletedAt,
      syncStatus: 'pending_sync',
      version: list.version + 1,
    );

    try {
      await _repository.saveShoppingList(updated);
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to update list inventory.');
    }
  }

  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }
}
