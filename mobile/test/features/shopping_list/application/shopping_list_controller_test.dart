import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_category.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeShoppingListRepository shoppingListRepository;
  late FakeProductRepository productRepository;
  late FakeInventoryRepository inventoryRepository;
  late ProviderContainer container;

  const String testListId = 'test-list-id';

  setUp(() {
    shoppingListRepository = FakeShoppingListRepository();
    productRepository = FakeProductRepository(
      products: <Product>[
        Product(
          id: 'p-milk',
          canonicalName: 'milk',
          category: 'dairy',
          defaultUnit: Unit.fromCode('liter'),
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
          syncStatus: 'synced',
          version: 1,
        ),
      ],
      aliases: <ProductAlias>[
        ProductAlias(
          id: 'a-1',
          productId: 'p-milk',
          alias: 'leche',
          languageCode: 'es',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      ],
    );

    inventoryRepository = FakeInventoryRepository();

    // Pre-seed a list so the controller has items to work with.
    shoppingListRepository.seedList(
      ShoppingList(
        id: testListId,
        name: 'Test list',
        status: ShoppingListStatus.active,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
        syncStatus: 'local_only',
        version: 1,
      ),
    );
    shoppingListRepository.seedCategory(
      ShoppingListCategory(
        id: 'slc-dairy',
        shoppingListId: testListId,
        categoryId: 'cat-dairy',
        sortOrder: 0,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
        categoryName: 'dairy',
      ),
    );
    shoppingListRepository.seedCategory(
      ShoppingListCategory(
        id: 'slc-produce',
        shoppingListId: testListId,
        categoryId: 'cat-produce',
        sortOrder: 1,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
        categoryName: 'produce',
      ),
    );

    container = ProviderContainer(
      overrides: <Override>[
        shoppingListRepositoryProvider
            .overrideWithValue(shoppingListRepository),
        productRepositoryProvider.overrideWithValue(productRepository),
        shoppingInventoryRepositoryProvider
            .overrideWithValue(inventoryRepository),
      ],
    );

    addTearDown(container.dispose);
    addTearDown(shoppingListRepository.dispose);
    addTearDown(productRepository.dispose);
  });

  group('ShoppingListController', () {
    test('adding matched product', () async {
      // Give the products stream time to deliver before matching.
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.productId, 'p-milk');
      expect(
        state.pendingItems.first.source,
        ShoppingListItemSource.suggestion,
      );
    });

    test('adding custom item', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('dragonfruit 2');
      await controller.addCustomItem();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.productId, isNull);
      expect(state.pendingItems.first.rawText, 'dragonfruit');
      expect(state.pendingItems.first.quantity, 2);
      expect(state.pendingItems.first.source, ShoppingListItemSource.manual);
    });

    test('renameList updates the list title and can be undone', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);

      final ShoppingList initialList = shoppingListRepository.lists
          .firstWhere((ShoppingList list) => list.id == testListId);
      final bool renamed =
          await controller.renameList(initialList, 'Renamed list');
      expect(renamed, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(shoppingListRepository.lists.first.name, 'Renamed list');

      final bool undone = await controller.undoLastAction();
      expect(undone, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(shoppingListRepository.lists.first.name, 'Test list');
    });

    test('edit mode stores list and item changes as draft only', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      final ShoppingList list = shoppingListRepository.lists.first;

      final bool entered = await controller.enterEditMode(list);
      expect(entered, isTrue);

      final bool renamed = await controller.renameList(list, 'Drafted name');
      expect(renamed, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 30));
      controller.updateQuickAddInput('dragonfruit 2');
      await controller.addCustomItem();

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(shoppingListRepository.lists.first.name, 'Test list');
      expect(shoppingListRepository.itemsForList(testListId), isEmpty);

      final ShoppingListDraft? draft =
          shoppingListRepository.getDraft(testListId);
      expect(draft, isNotNull);
      expect(draft!.name, 'Drafted name');

      await controller.cancelChanges();
      final ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.isEditMode, isFalse);
      expect(state.hasDraft, isTrue);
    });

    test('applyDraft commits staged changes and clears persisted draft',
        () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      final ShoppingList list = shoppingListRepository.lists.first;

      await controller.enterEditMode(list);
      await controller.renameList(list, 'Applied name');

      final bool applied = await controller.applyDraft(list);
      expect(applied, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(shoppingListRepository.lists.first.name, 'Applied name');
      expect(shoppingListRepository.getDraft(testListId), isNull);

      final ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.isEditMode, isFalse);
      expect(state.hasDraft, isFalse);
    });

    test('applyDraft persists added draft items', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      final ShoppingList list = shoppingListRepository.lists.first;

      final ShoppingListItem draftItem = ShoppingListItem(
        id: 'draft-item-1',
        shoppingListId: testListId,
        rawText: 'draft apples',
        quantity: 2,
        unit: Unit.fromCode('unit'),
        status: ShoppingListItemStatus.pending,
        source: ShoppingListItemSource.manual,
        priorityScore: 0.2,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
        syncStatus: 'pending_sync',
        version: 1,
      );

      await shoppingListRepository.saveDraft(
        ShoppingListDraft(
          shoppingListId: testListId,
          name: list.name,
          items: <ShoppingListItem>[draftItem],
          updatedAt: DateTime.now(),
        ),
      );

      await controller.syncWithList(list);
      await controller.continueDraftEditing(list);
      final bool applied = await controller.applyDraft(list);
      expect(applied, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(shoppingListRepository.itemsForList(testListId).length, 1);
      expect(
        shoppingListRepository.itemsForList(testListId).first.rawText,
        'draft apples',
      );
      expect(shoppingListRepository.getDraft(testListId), isNull);
    });

    test('applyDraft removes items deleted in draft', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      final ShoppingList list = shoppingListRepository.lists.first;

      final ShoppingListItem seededItem = ShoppingListItem(
        id: 'seed-item-1',
        shoppingListId: testListId,
        rawText: 'seeded item',
        quantity: 1,
        unit: Unit.fromCode('unit'),
        status: ShoppingListItemStatus.pending,
        source: ShoppingListItemSource.manual,
        priorityScore: 0.3,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
        syncStatus: 'synced',
        version: 1,
      );
      await shoppingListRepository.saveShoppingListItem(seededItem);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await controller.enterEditMode(list);
      final ShoppingListState editingState =
          container.read(shoppingListControllerProvider(testListId));
      await controller.softDelete(editingState.pendingItems.first);

      final bool applied = await controller.applyDraft(list);
      expect(applied, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(shoppingListRepository.itemsForList(testListId), isEmpty);
      expect(shoppingListRepository.getDraft(testListId), isNull);
    });

    test('discardDraft drops staged changes', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      final ShoppingList list = shoppingListRepository.lists.first;

      await controller.enterEditMode(list);
      controller.updateQuickAddInput('tomato 3');
      await controller.addCustomItem();

      final bool discarded = await controller.discardDraft();
      expect(discarded, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(shoppingListRepository.getDraft(testListId), isNull);
      expect(shoppingListRepository.itemsForList(testListId), isEmpty);

      final ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.isEditMode, isFalse);
      expect(state.hasDraft, isFalse);
    });

    test('syncWithList exposes reopen prompt when draft exists', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      final ShoppingList list = shoppingListRepository.lists.first;

      await controller.enterEditMode(list);
      await controller.renameList(list, 'Draft stays');
      await controller.cancelChanges();

      final ProviderContainer reopened = ProviderContainer(
        overrides: <Override>[
          shoppingListRepositoryProvider.overrideWithValue(
            shoppingListRepository,
          ),
          productRepositoryProvider.overrideWithValue(productRepository),
        ],
      );
      addTearDown(reopened.dispose);

      final ShoppingListController reopenedController = reopened.read(
        shoppingListControllerProvider(testListId).notifier,
      );
      await reopenedController.syncWithList(shoppingListRepository.lists.first);

      final ShoppingListState reopenedState =
          reopened.read(shoppingListControllerProvider(testListId));
      expect(reopenedState.draftPromptPending, isTrue);
      expect(reopenedState.hasDraft, isTrue);
    });

    test('quick add preserves gal unit for gallon variants', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);

      controller.updateQuickAddInput('1 gallon milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.unit?.code, 'gal');
      expect(state.pendingItems.first.quantity, 1);

      controller.updateQuickAddInput('1 gal leche');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 2);
      expect(state.pendingItems[1].unit?.code, 'gal');
      expect(state.pendingItems[1].quantity, 1);

      controller.updateQuickAddInput('2 gallons milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 3);
      expect(state.pendingItems[2].unit?.code, 'gal');
      expect(state.pendingItems[2].quantity, 2);
    });

    test('purchased status transition', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markPurchased(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems, isEmpty);
      expect(state.purchasedItems.length, 1);
      expect(
        state.purchasedItems.first.status,
        ShoppingListItemStatus.purchased,
      );
    });

    test('undoLastAction restores purchased item to pending', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markPurchased(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final bool undone = await controller.undoLastAction();
      expect(undone, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.status, ShoppingListItemStatus.pending);
    });

    test('skipped status transition', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markSkipped(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems, isEmpty);
      expect(state.skippedItems.length, 1);
      expect(state.skippedItems.first.status, ShoppingListItemStatus.skipped);
    });

    test('undoLastAction restores skipped item to pending', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markSkipped(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final bool undone = await controller.undoLastAction();
      expect(undone, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.status, ShoppingListItemStatus.pending);
    });

    test('restore to pending', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markSkipped(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      await controller.restorePending(state.skippedItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.skippedItems, isEmpty);
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.status, ShoppingListItemStatus.pending);
    });

    test('undoLastAction restores skipped state after restore', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markSkipped(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      await controller.restorePending(state.skippedItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final bool undone = await controller.undoLastAction();
      expect(undone, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.skippedItems.length, 1);
      expect(state.skippedItems.first.status, ShoppingListItemStatus.skipped);
    });

    test('soft delete', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      final String itemId = state.pendingItems.first.id;
      await controller.softDelete(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems, isEmpty);
      expect(shoppingListRepository.deletedItemIds.contains(itemId), isTrue);
    });

    test('undoLastAction restores deleted item', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      controller.updateQuickAddInput('milk');
      await controller.addFromQuickAdd();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      await controller.softDelete(state.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final bool undone = await controller.undoLastAction();
      expect(undone, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.deletedAt, isNull);
    });

    test('organized add falls back to Uncategorized category', () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);

      final bool added = await controller.addItemWithDetails(
        name: 'mystery item',
      );
      expect(added, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 20));
      final ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 1);
      expect(state.pendingItems.first.categoryId, 'cat-uncategorized');
    });

    test('manual category reassignment is remembered for future suggestions',
        () async {
      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);

      await Future<void>.delayed(const Duration(milliseconds: 30));

      await controller.addItemWithDetails(name: 'milk');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      ShoppingListState state =
          container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.first.categoryId, 'cat-dairy');

      final bool reassigned = await controller.reassignItemCategory(
        state.pendingItems.first,
        'cat-produce',
      );
      expect(reassigned, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 20));
      await controller.addItemWithDetails(name: 'milk');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      state = container.read(shoppingListControllerProvider(testListId));
      expect(state.pendingItems.length, 2);
      expect(state.pendingItems.last.categoryId, 'cat-produce');
    });

    test('purchased item routes to one inventory category', () async {
      await shoppingListRepository.saveShoppingList(
        shoppingListRepository.lists.first.copyWith(
          listType: ShoppingListType.organized,
          routingMode: ShoppingListRoutingMode.inventoryCategories,
        ),
      );
      await shoppingListRepository.linkListToInventory(
        shoppingListId: testListId,
        inventoryId: 'inv-main',
      );
      shoppingListRepository.seedCategory(
        ShoppingListCategory(
          id: 'slc-dairy-map',
          shoppingListId: testListId,
          categoryId: 'cat-dairy',
          targetInventoryId: 'inv-main',
          targetInventoryCategoryId: 'invcat-dairy',
          sortOrder: 2,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
          categoryName: 'dairy',
        ),
      );

      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      final bool added = await controller.addItemWithDetails(
        name: 'milk',
        categoryId: 'cat-dairy',
      );
      expect(added, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ShoppingListState beforePurchase =
          container.read(shoppingListControllerProvider(testListId));
      final bool purchased =
          await controller.markPurchased(beforePurchase.pendingItems.first);

      expect(purchased, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(inventoryRepository.savedItems.length, 1);
      expect(inventoryRepository.savedItems.first.inventoryId, 'inv-main');
      expect(
        inventoryRepository.savedItems.first.inventoryCategoryId,
        'invcat-dairy',
      );
    });

    test('purchased item routes to category-as-inventory target', () async {
      await shoppingListRepository.saveShoppingList(
        shoppingListRepository.lists.first.copyWith(
          listType: ShoppingListType.organized,
          routingMode: ShoppingListRoutingMode.categoryAsInventory,
        ),
      );
      shoppingListRepository.seedCategory(
        ShoppingListCategory(
          id: 'slc-produce-map',
          shoppingListId: testListId,
          categoryId: 'cat-produce',
          targetInventoryId: 'inv-produce',
          targetInventoryCategoryId: 'invcat-produce',
          sortOrder: 3,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
          categoryName: 'produce',
        ),
      );

      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      await controller.addItemWithDetails(
        name: 'apples',
        categoryId: 'cat-produce',
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ShoppingListState beforePurchase =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markPurchased(beforePurchase.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(inventoryRepository.savedItems.length, 1);
      expect(inventoryRepository.savedItems.first.inventoryId, 'inv-produce');
      expect(
        inventoryRepository.savedItems.first.inventoryCategoryId,
        'invcat-produce',
      );
    });

    test('purchased routing falls back to Uncategorized category', () async {
      await shoppingListRepository.saveShoppingList(
        shoppingListRepository.lists.first.copyWith(
          listType: ShoppingListType.organized,
          routingMode: ShoppingListRoutingMode.inventoryCategories,
        ),
      );
      await shoppingListRepository.linkListToInventory(
        shoppingListId: testListId,
        inventoryId: 'inv-main',
      );

      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      await controller.addItemWithDetails(
        name: 'unknown',
        categoryId: 'cat-missing-map',
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ShoppingListState beforePurchase =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markPurchased(beforePurchase.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(inventoryRepository.savedItems.length, 1);
      expect(
        inventoryRepository.savedItems.first.inventoryCategoryId,
        'inv-main::inventory-uncategorized',
      );
    });

    test('routing failure handled safely while keeping item purchased',
        () async {
      await shoppingListRepository.saveShoppingList(
        shoppingListRepository.lists.first.copyWith(
          listType: ShoppingListType.organized,
          routingMode: ShoppingListRoutingMode.categoryAsInventory,
        ),
      );
      inventoryRepository.throwOnSave = true;
      shoppingListRepository.seedCategory(
        ShoppingListCategory(
          id: 'slc-fail-map',
          shoppingListId: testListId,
          categoryId: 'cat-dairy',
          targetInventoryId: 'inv-main',
          sortOrder: 4,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
          categoryName: 'dairy',
        ),
      );

      final ShoppingListController controller =
          container.read(shoppingListControllerProvider(testListId).notifier);
      await controller.addItemWithDetails(
        name: 'milk',
        categoryId: 'cat-dairy',
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ShoppingListState beforePurchase =
          container.read(shoppingListControllerProvider(testListId));
      await controller.markPurchased(beforePurchase.pendingItems.first);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ShoppingListState afterPurchase =
          container.read(shoppingListControllerProvider(testListId));
      expect(afterPurchase.purchasedItems.length, 1);
      expect(afterPurchase.errorMessage, isNotNull);
      expect(
        afterPurchase.errorMessage,
        contains('Unable to update item'),
      );
    });
  });
}

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
  final List<ShoppingListCategory> _categories = <ShoppingListCategory>[];

  List<ShoppingList> get lists => List<ShoppingList>.unmodifiable(_lists);

  List<String> get deletedItemIds => _items
      .where((ShoppingListItem item) => item.deletedAt != null)
      .map((ShoppingListItem item) => item.id)
      .toList(growable: false);

  ShoppingListDraft? getDraft(String shoppingListId) => _drafts[shoppingListId];

  List<ShoppingListItem> itemsForList(String shoppingListId) => _items
      .where((ShoppingListItem item) => item.shoppingListId == shoppingListId)
      .where((ShoppingListItem item) => item.deletedAt == null)
      .toList(growable: false);

  void seedList(ShoppingList list) {
    _lists.add(list);
    final String? legacyInventoryId = list.inventoryId;
    if (legacyInventoryId != null && legacyInventoryId.isNotEmpty) {
      _inventoryLinksByList
          .putIfAbsent(list.id, () => <String>{})
          .add(legacyInventoryId);
    }
  }

  void seedCategory(ShoppingListCategory category) {
    _categories.add(category);
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
  Stream<List<ShoppingListCategory>> watchCategoriesForList(
    String shoppingListId,
  ) {
    final List<ShoppingListCategory> categories = _categories
        .where((ShoppingListCategory c) => c.shoppingListId == shoppingListId)
        .toList(growable: false);
    return Stream<List<ShoppingListCategory>>.value(categories);
  }

  @override
  Future<void> saveShoppingList(ShoppingList shoppingList) async {
    final int index = _lists
        .indexWhere((ShoppingList element) => element.id == shoppingList.id);
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
        _items.indexWhere((ShoppingListItem element) => element.id == item.id);
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
    final Set<String> linked =
        _inventoryLinksByList[shoppingListId] ?? <String>{};
    final List<Inventory> inventories = linked
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

  @override
  Future<void> ensureUncategorizedCategoryForList(String shoppingListId) async {
    final bool exists = _categories.any(
      (ShoppingListCategory category) =>
          category.shoppingListId == shoppingListId &&
          (category.categoryName ?? '').toLowerCase() == 'uncategorized',
    );
    if (exists) {
      return;
    }
    final DateTime now = DateTime.now();
    _categories.add(
      ShoppingListCategory(
        id: 'slc-uncategorized',
        shoppingListId: shoppingListId,
        categoryId: 'cat-uncategorized',
        sortOrder: _categories.length,
        createdAt: now,
        updatedAt: now,
        categoryName: 'Uncategorized',
      ),
    );
  }

  void _emitAllLists() {
    final List<ShoppingList> nonDeleted = _lists
        .where((ShoppingList l) => l.deletedAt == null)
        .toList(growable: false);
    _allListsController.add(nonDeleted);
  }

  void _emitActiveLists() {
    final List<ShoppingList> active = _lists
        .where(
          (ShoppingList list) =>
              list.deletedAt == null &&
              list.status == ShoppingListStatus.active,
        )
        .toList(growable: false);
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
          (ShoppingListItem item) =>
              item.shoppingListId == shoppingListId && item.deletedAt == null,
        )
        .toList(growable: false);

    controller.add(items);
  }

  Future<void> dispose() async {
    await _allListsController.close();
    await _activeListsController.close();
    for (final StreamController<List<ShoppingListItem>> controller
        in _itemsControllers.values) {
      await controller.close();
    }
  }
}

class FakeProductRepository implements ProductRepository {
  FakeProductRepository({
    required List<Product> products,
    required List<ProductAlias> aliases,
  })  : _products = products,
        _aliases = aliases;

  final StreamController<List<Product>> _productsController =
      StreamController<List<Product>>.broadcast();

  final List<Product> _products;
  final List<ProductAlias> _aliases;

  @override
  Stream<List<Product>> watchActiveProducts() {
    Future<void>.microtask(() => _productsController.add(_products));
    return _productsController.stream;
  }

  @override
  Future<List<ProductAlias>> findAliasesForProduct(String productId) async {
    return _aliases
        .where((ProductAlias alias) => alias.productId == productId)
        .toList(growable: false);
  }

  @override
  Future<List<ProductAlias>> findAliasesForProducts(
    List<String> productIds,
  ) async {
    return _aliases
        .where((ProductAlias alias) => productIds.contains(alias.productId))
        .toList(growable: false);
  }

  @override
  Future<void> saveProduct(Product product) async {
    final int index =
        _products.indexWhere((Product element) => element.id == product.id);
    if (index >= 0) {
      _products[index] = product;
    } else {
      _products.add(product);
    }
    _productsController.add(_products);
  }

  @override
  Future<void> saveAlias(ProductAlias alias) async {
    _aliases.add(alias);
  }

  Future<void> dispose() async {
    await _productsController.close();
  }
}

class FakeInventoryRepository extends InventoryRepository {
  bool throwOnSave = false;
  final List<InventoryItem> savedItems = <InventoryItem>[];

  @override
  Stream<List<Inventory>> watchAllInventories() {
    return Stream<List<Inventory>>.value(const <Inventory>[]);
  }

  @override
  Stream<List<InventoryItem>> watchInventoryItems(String inventoryId) {
    return Stream<List<InventoryItem>>.value(const <InventoryItem>[]);
  }

  @override
  Future<void> saveInventory(Inventory inventory) async {}

  @override
  Future<void> deleteInventory(String id) async {}

  @override
  Future<void> deleteInventoryItem(String id) async {}

  @override
  Future<void> addInventoryEvent(InventoryEvent event) async {}

  @override
  Future<void> saveInventoryItem(InventoryItem item) async {
    if (throwOnSave) {
      throw StateError('save failed');
    }
    savedItems.add(item);
  }

  @override
  Future<String> ensureUncategorizedInventoryCategory(
    String inventoryId,
  ) async {
    return '$inventoryId::inventory-uncategorized';
  }
}
