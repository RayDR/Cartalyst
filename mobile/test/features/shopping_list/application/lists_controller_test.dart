import 'dart:async';

import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show shoppingListRepositoryProvider, uuidProvider;
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late FakeShoppingListRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeShoppingListRepository();

    container = ProviderContainer(
      overrides: <Override>[
        shoppingListRepositoryProvider.overrideWithValue(repository),
        uuidProvider.overrideWithValue(const Uuid()),
      ],
    );

    addTearDown(container.dispose);
    addTearDown(repository.dispose);
  });

  Future<void> waitForLists() async {
    for (int i = 0; i < 30; i++) {
      // Lists stream is emitted asynchronously; give it a tick.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      final ListsState state = container.read(listsControllerProvider);
      if (state.lists.isNotEmpty || i > 5) {
        return;
      }
    }
  }

  group('ListsController', () {
    test('starts with empty list', () async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists, isEmpty);
      expect(state.isEmpty, isTrue);
    });

    test('createList adds a list and returns its id', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);

      final String? newId = await controller.createList('Weekly groceries');

      expect(newId, isNotNull);
      expect(newId, isNotEmpty);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.length, 1);
      expect(state.lists.first.name, 'Weekly groceries');
      expect(state.lists.first.id, newId);
      expect(state.lists.first.listType, ShoppingListType.simple);
      expect(
        state.lists.first.routingMode,
        ShoppingListRoutingMode.none,
      );
    });

    test('createList supports organized list type and routing mode', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);

      final String? newId = await controller.createList(
        'Weekly organized',
        listType: ShoppingListType.organized,
        routingMode: ShoppingListRoutingMode.inventoryCategories,
      );

      expect(newId, isNotNull);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      final ShoppingList list =
          state.lists.firstWhere((ShoppingList item) => item.id == newId);
      expect(list.listType, ShoppingListType.organized);
      expect(list.routingMode, ShoppingListRoutingMode.inventoryCategories);
    });

    test('createList trims whitespace', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('  Pantry run  ');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.first.name, 'Pantry run');
    });

    test('createList can start linked to an inventory', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);

      await controller.createList('Weekly groceries', inventoryId: 'inv-home');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.first.name, 'Weekly groceries');
      expect(
        repository.linkedInventoryIdsForList(state.lists.first.id),
        contains('inv-home'),
      );
    });

    test('createList without inventory keeps list standalone', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);

      await controller.createList('Quick list');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.first.inventoryId, isNull);
    });

    test('createList can link to a newly created inventory id', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);

      const String newInventoryId = 'inv-created-now';
      await controller.createList(
        'Weekly groceries',
        inventoryId: newInventoryId,
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(
        repository.linkedInventoryIdsForList(state.lists.first.id),
        contains(newInventoryId),
      );
    });

    test('createList returns null for empty name', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      final String? id = await controller.createList('   ');
      expect(id, isNull);

      await Future<void>.delayed(const Duration(milliseconds: 20));
      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists, isEmpty);
    });

    test('renameList updates list name', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('Old name');

      await waitForLists();

      final ShoppingList list =
          container.read(listsControllerProvider).lists.first;
      await controller.renameList(list, 'New name');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.first.name, 'New name');
    });

    test('undoLastAction restores renamed list', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('Old name');

      await waitForLists();

      final ShoppingList list =
          container.read(listsControllerProvider).lists.first;
      await controller.renameList(list, 'New name');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final bool undone = await controller.undoLastAction();
      expect(undone, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.first.name, 'Old name');
    });

    test('deleteList soft-deletes and sets lastDeletedList', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('To delete');

      await waitForLists();

      final ShoppingList list =
          container.read(listsControllerProvider).lists.first;
      await controller.deleteList(list);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      // List should no longer appear in non-deleted stream
      expect(state.lists, isEmpty);
      // lastDeletedList is available for undo
      expect(state.lastDeletedList, isNotNull);
      expect(state.lastDeletedList!.name, 'To delete');
    });

    test('undoLastAction restores deleted list', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('Undo delete');

      await waitForLists();

      final ShoppingList list =
          container.read(listsControllerProvider).lists.first;
      await controller.deleteList(list);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final bool undone = await controller.undoLastAction();
      expect(undone, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.length, 1);
      expect(state.lists.first.name, 'Undo delete');
    });

    test('restoreLastDeleted restores a soft-deleted list', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('Restorable');

      await waitForLists();

      final ShoppingList list =
          container.read(listsControllerProvider).lists.first;
      await controller.deleteList(list);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      // Confirm deleted
      expect(container.read(listsControllerProvider).lists, isEmpty);

      await controller.restoreLastDeleted();

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.length, 1);
      expect(state.lists.first.name, 'Restorable');
      expect(state.lists.first.deletedAt, isNull);
      expect(state.lastDeletedList, isNull);
    });

    test('lists are ordered by updatedAt descending', () async {
      // Initialize the controller so it subscribes to the stream before we emit.
      container.read(listsControllerProvider);

      final DateTime t1 = DateTime(2026);
      final DateTime t2 = DateTime(2026, 1, 3);
      final DateTime t3 = DateTime(2026, 1, 2);

      repository.seedList(
        ShoppingList(
          id: 'a',
          name: 'List A',
          status: ShoppingListStatus.active,
          createdAt: t1,
          updatedAt: t1,
          syncStatus: 'local_only',
          version: 1,
        ),
      );
      repository.seedList(
        ShoppingList(
          id: 'b',
          name: 'List B',
          status: ShoppingListStatus.active,
          createdAt: t2,
          updatedAt: t2,
          syncStatus: 'local_only',
          version: 1,
        ),
      );
      repository.seedList(
        ShoppingList(
          id: 'c',
          name: 'List C',
          status: ShoppingListStatus.active,
          createdAt: t3,
          updatedAt: t3,
          syncStatus: 'local_only',
          version: 1,
        ),
      );
      repository.emitLists();

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.length, 3);
      // Most recently updated first
      expect(state.lists[0].id, 'b');
      expect(state.lists[1].id, 'c');
      expect(state.lists[2].id, 'a');
    });

    test('linkToInventory creates a link without mutating list ownership',
        () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('Linked list');

      await waitForLists();

      final ShoppingList list =
          container.read(listsControllerProvider).lists.first;
      expect(repository.linkedInventoryIdsForList(list.id), isEmpty);

      await controller.linkToInventory(list, 'inv-123');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(
        repository.linkedInventoryIdsForList(list.id),
        contains('inv-123'),
      );
    });

    test('linkToInventory supports multiple linked inventories', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('Linked list', inventoryId: 'inv-123');

      await waitForLists();

      final ShoppingList list =
          container.read(listsControllerProvider).lists.first;
      expect(
        repository.linkedInventoryIdsForList(list.id),
        contains('inv-123'),
      );

      await controller.linkToInventory(list, 'inv-456');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(
        repository.linkedInventoryIdsForList(list.id),
        containsAll(<String>['inv-123', 'inv-456']),
      );
    });

    test('unlinkFromInventory removes only selected link', () async {
      final ListsController controller =
          container.read(listsControllerProvider.notifier);
      await controller.createList('Linked list', inventoryId: 'inv-123');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ShoppingList seeded =
          container.read(listsControllerProvider).lists.first;
      await controller.linkToInventory(seeded, 'inv-456');

      await waitForLists();

      final ShoppingList list =
          container.read(listsControllerProvider).lists.first;
      expect(
        repository.linkedInventoryIdsForList(list.id),
        containsAll(<String>['inv-123', 'inv-456']),
      );

      await controller.unlinkFromInventory(list, inventoryId: 'inv-123');

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(
        repository.linkedInventoryIdsForList(list.id),
        <String>{'inv-456'},
      );
    });

    test('recentLists returns at most 5 lists', () async {
      for (int i = 1; i <= 7; i++) {
        // Initialize the controller before seeding so it subscribes to the stream.
        container.read(listsControllerProvider);
        repository.seedList(
          ShoppingList(
            id: 'list-$i',
            name: 'List $i',
            status: ShoppingListStatus.active,
            createdAt: DateTime(2026, 1, i),
            updatedAt: DateTime(2026, 1, i),
            syncStatus: 'local_only',
            version: 1,
          ),
        );
      }
      repository.emitLists();

      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ListsState state = container.read(listsControllerProvider);
      expect(state.lists.length, 7);
      expect(state.recentLists.length, 5);
    });
  });
}

// ---------------------------------------------------------------------------
// Fake repository
// ---------------------------------------------------------------------------

class FakeShoppingListRepository extends ShoppingListRepository {
  final StreamController<List<ShoppingList>> _allListsController =
      StreamController<List<ShoppingList>>.broadcast();

  final StreamController<List<ShoppingList>> _activeListsController =
      StreamController<List<ShoppingList>>.broadcast();

  final Map<String, StreamController<List<ShoppingListItem>>>
      _itemsControllers = <String, StreamController<List<ShoppingListItem>>>{};

  final List<ShoppingList> _lists = <ShoppingList>[];
  final List<ShoppingListItem> _items = <ShoppingListItem>[];
  final Map<String, ShoppingListDraft> _drafts = <String, ShoppingListDraft>{};
  final Map<String, Set<String>> _inventoryLinksByList =
      <String, Set<String>>{};

  Set<String> linkedInventoryIdsForList(String listId) {
    return Set<String>.from(_inventoryLinksByList[listId] ?? <String>{});
  }

  void seedList(ShoppingList list) {
    _lists.add(list);
    final String? legacyInventoryId = list.inventoryId;
    if (legacyInventoryId != null && legacyInventoryId.isNotEmpty) {
      _inventoryLinksByList
          .putIfAbsent(list.id, () => <String>{})
          .add(legacyInventoryId);
    }
  }

  void emitLists() {
    _emitAllLists();
    _emitActiveLists();
  }

  @override
  Stream<List<ShoppingList>> watchAllLists() {
    Future<void>.microtask(_emitAllLists);
    return _allListsController.stream;
  }

  @override
  Stream<List<ShoppingList>> watchActiveLists() {
    Future<void>.microtask(_emitActiveLists);
    return _activeListsController.stream;
  }

  @override
  Stream<List<ShoppingListItem>> watchItemsForList(String shoppingListId) {
    final StreamController<List<ShoppingListItem>> controller =
        _itemsControllers.putIfAbsent(
      shoppingListId,
      () => StreamController<List<ShoppingListItem>>.broadcast(),
    );
    Future<void>.microtask(() => _emitItemsForList(shoppingListId));
    return controller.stream;
  }

  @override
  Future<void> saveShoppingList(ShoppingList shoppingList) async {
    final int index =
        _lists.indexWhere((ShoppingList l) => l.id == shoppingList.id);
    if (index >= 0) {
      _lists[index] = shoppingList;
    } else {
      _lists.add(shoppingList);
    }
    _emitAllLists();
    _emitActiveLists();
  }

  @override
  Future<void> saveShoppingListItem(ShoppingListItem item) async {
    final int index =
        _items.indexWhere((ShoppingListItem i) => i.id == item.id);
    if (index >= 0) {
      _items[index] = item;
    } else {
      _items.add(item);
    }
    _emitItemsForList(item.shoppingListId);
  }

  @override
  Future<void> linkListToInventory({
    required String shoppingListId,
    required String inventoryId,
  }) async {
    _inventoryLinksByList
        .putIfAbsent(shoppingListId, () => <String>{})
        .add(inventoryId);
  }

  @override
  Future<void> unlinkListFromInventory({
    required String shoppingListId,
    required String inventoryId,
  }) async {
    _inventoryLinksByList[shoppingListId]?.remove(inventoryId);
  }

  @override
  Stream<List<Inventory>> watchInventoriesForList(String shoppingListId) {
    final Set<String> links =
        _inventoryLinksByList[shoppingListId] ?? <String>{};
    final List<Inventory> inventories = links
        .map(
          (String id) => Inventory(
            id: id,
            name: 'Inventory $id',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
            syncStatus: 'local_only',
            version: 1,
          ),
        )
        .toList(growable: false);
    return Stream<List<Inventory>>.value(inventories);
  }

  @override
  Stream<List<ShoppingList>> watchListsForInventory(String inventoryId) {
    final List<ShoppingList> linked = _lists
        .where(
          (ShoppingList list) =>
              (_inventoryLinksByList[list.id] ?? const <String>{})
                  .contains(inventoryId),
        )
        .toList(growable: false);
    return Stream<List<ShoppingList>>.value(linked);
  }

  @override
  Future<void> deleteShoppingList(String id) async {
    final int index = _lists.indexWhere((ShoppingList l) => l.id == id);
    if (index >= 0) {
      _lists[index] = ShoppingList(
        id: _lists[index].id,
        inventoryId: _lists[index].inventoryId,
        name: _lists[index].name,
        status: _lists[index].status,
        createdAt: _lists[index].createdAt,
        updatedAt: DateTime.now(),
        deletedAt: DateTime.now(),
        syncStatus: 'pending_sync',
        version: _lists[index].version + 1,
      );
    }
    _emitAllLists();
    _emitActiveLists();
  }

  @override
  Future<ShoppingListDraft?> readDraft(String shoppingListId) async {
    return _drafts[shoppingListId];
  }

  @override
  Future<void> saveDraft(ShoppingListDraft draft) async {
    _drafts[draft.shoppingListId] = ShoppingListDraft(
      shoppingListId: draft.shoppingListId,
      name: draft.name,
      items: draft.items
          .map((ShoppingListItem item) => item.copyWith())
          .toList(growable: false),
      updatedAt: draft.updatedAt,
    );
  }

  @override
  Future<void> deleteDraft(String shoppingListId) async {
    _drafts.remove(shoppingListId);
  }

  void _emitAllLists() {
    final List<ShoppingList> nonDeleted = _lists
        .where((ShoppingList l) => l.deletedAt == null)
        .toList()
      ..sort(
        (ShoppingList a, ShoppingList b) => b.updatedAt.compareTo(a.updatedAt),
      );
    _allListsController.add(nonDeleted);
  }

  void _emitActiveLists() {
    final List<ShoppingList> active = _lists
        .where(
          (ShoppingList l) =>
              l.deletedAt == null && l.status == ShoppingListStatus.active,
        )
        .toList()
      ..sort(
        (ShoppingList a, ShoppingList b) => b.updatedAt.compareTo(a.updatedAt),
      );
    _activeListsController.add(active);
  }

  void _emitItemsForList(String shoppingListId) {
    final StreamController<List<ShoppingListItem>>? controller =
        _itemsControllers[shoppingListId];
    if (controller == null) {
      return;
    }
    final List<ShoppingListItem> items = _items
        .where(
          (ShoppingListItem i) =>
              i.shoppingListId == shoppingListId && i.deletedAt == null,
        )
        .toList(growable: false);
    controller.add(items);
  }

  Future<void> dispose() async {
    await _allListsController.close();
    await _activeListsController.close();
    for (final StreamController<List<ShoppingListItem>> ctrl
        in _itemsControllers.values) {
      await ctrl.close();
    }
  }
}
