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
  final List<_ListUndoEntry> _undoStack = <_ListUndoEntry>[];

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
    _subscription = _repository.watchAllLists().listen(
      (List<ShoppingList> lists) {
        state = state.copyWith(
          lists: lists,
          isBusy: false,
          clearErrorMessage: true,
        );
      },
      onError: (_, __) {
        state = state.copyWith(
          isBusy: false,
          errorMessage: 'Unable to load lists right now.',
        );
      },
      cancelOnError: false,
    );
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

  Future<bool> renameList(ShoppingList list, String newName) async {
    final String trimmed = newName.trim();
    if (trimmed.isEmpty) {
      return false;
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
      _pushUndo(
        _ListUndoEntry(
          label: 'Rename list',
          undo: () => _repository.saveShoppingList(list),
        ),
      );
      state = state.copyWith(clearLastDeleted: true);
      return true;
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to rename list.');
      return false;
    }
  }

  Future<bool> deleteList(ShoppingList list) async {
    state = state.copyWith(lastDeletedList: list);
    try {
      await _repository.deleteShoppingList(list.id);
      _pushUndo(
        _ListUndoEntry(
          label: 'Delete list',
          undo: () => _repository.saveShoppingList(list),
        ),
      );
      return true;
    } catch (_) {
      state = state.copyWith(
        clearLastDeleted: true,
        errorMessage: 'Unable to delete list.',
      );
      return false;
    }
  }

  Future<bool> archiveList(ShoppingList list) async {
    final DateTime now = DateTime.now();
    final ShoppingList archived = ShoppingList(
      id: list.id,
      inventoryId: list.inventoryId,
      name: list.name,
      status: ShoppingListStatus.archived,
      createdAt: list.createdAt,
      updatedAt: now,
      deletedAt: list.deletedAt,
      syncStatus: 'pending_sync',
      version: list.version + 1,
    );

    try {
      await _repository.saveShoppingList(archived);
      _pushUndo(
        _ListUndoEntry(
          label: 'Archive list',
          undo: () => _repository.saveShoppingList(list),
        ),
      );
      state = state.copyWith(clearLastDeleted: true, clearErrorMessage: true);
      return true;
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to archive list.');
      return false;
    }
  }

  /// Undoes the most recent soft delete. No-op if nothing to restore.
  Future<bool> restoreLastDeleted() {
    return undoLastAction();
  }

  Future<bool> linkToInventory(ShoppingList list, String inventoryId) {
    return updateLinkedInventory(list, inventoryId);
  }

  Future<bool> unlinkFromInventory(ShoppingList list) {
    return updateLinkedInventory(list, null);
  }

  Future<bool> updateLinkedInventory(
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
      return true;
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to update list inventory.');
      return false;
    }
  }

  Future<bool> undoLastAction() async {
    if (_undoStack.isEmpty) {
      return false;
    }

    final _ListUndoEntry entry = _undoStack.removeLast();
    try {
      await entry.undo();
      state = state.copyWith(clearLastDeleted: true, clearErrorMessage: true);
      return true;
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'Unable to undo ${entry.label.toLowerCase()}.',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }

  void refresh() {
    state = state.copyWith(isBusy: true, clearErrorMessage: true);
    _subscribe();
  }

  void _pushUndo(_ListUndoEntry entry) {
    _undoStack.add(entry);
  }
}

class _ListUndoEntry {
  const _ListUndoEntry({
    required this.label,
    required this.undo,
  });

  final String label;
  final Future<void> Function() undo;
}
