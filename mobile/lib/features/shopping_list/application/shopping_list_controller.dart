import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/inventories/data/repositories/local_inventory_repository.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/products/data/repositories/local_product_repository.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/features/products/domain/services/product_suggestion_service.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/data/repositories/local_shopping_list_repository.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart'
    show AppDatabase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final appDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final shoppingListRepositoryProvider =
    Provider<ShoppingListRepository>((Ref ref) {
  return LocalShoppingListRepository(ref.watch(appDatabaseProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((Ref ref) {
  return LocalProductRepository(ref.watch(appDatabaseProvider));
});

final shoppingInventoryRepositoryProvider = Provider<InventoryRepository>(
  (Ref ref) {
    return LocalInventoryRepository(ref.watch(appDatabaseProvider));
  },
);

final productSuggestionServiceProvider =
    Provider<ProductSuggestionService>((Ref ref) {
  return const ProductSuggestionService();
});

final uuidProvider = Provider<Uuid>((Ref ref) {
  return const Uuid();
});

final shoppingListControllerProvider =
    NotifierProviderFamily<ShoppingListController, ShoppingListState, String>(
  ShoppingListController.new,
);

class ShoppingListController extends FamilyNotifier<ShoppingListState, String> {
  late final ShoppingListRepository _shoppingListRepository;
  late final ProductRepository _productRepository;
  late final InventoryRepository _inventoryRepository;
  late final ProductSuggestionService _suggestionService;
  late final Uuid _uuid;

  StreamSubscription<List<ShoppingListItem>>? _listItemsSubscription;
  StreamSubscription<List<Product>>? _productsSubscription;
  final List<_ShoppingListUndoEntry> _undoStack = <_ShoppingListUndoEntry>[];
  List<ShoppingListItem> _confirmedItems = const <ShoppingListItem>[];
  _WorkingDraft? _workingDraft;
  bool _draftChecked = false;

  List<Product> _products = const <Product>[];
  List<ProductAlias> _aliases = const <ProductAlias>[];
  List<ProductUsageStat> _usageStats = const <ProductUsageStat>[];

  @override
  ShoppingListState build(String arg) {
    _shoppingListRepository = ref.watch(shoppingListRepositoryProvider);
    _productRepository = ref.watch(productRepositoryProvider);
    _inventoryRepository = ref.watch(shoppingInventoryRepositoryProvider);
    _suggestionService = ref.watch(productSuggestionServiceProvider);
    _uuid = ref.watch(uuidProvider);

    ref.onDispose(() {
      _listItemsSubscription?.cancel();
      _productsSubscription?.cancel();
    });

    _subscribeListItems(arg);
    _subscribeProducts();

    return const ShoppingListState.initial();
  }

  void updateQuickAddInput(String value) {
    state = state.copyWith(quickAddInput: value, clearErrorMessage: true);
    _refreshSuggestions();
  }

  Future<void> syncWithList(ShoppingList list) async {
    if (_draftChecked) {
      return;
    }

    _draftChecked = true;
    final ShoppingListDraft? persistedDraft =
        await _shoppingListRepository.readDraft(arg);
    if (persistedDraft == null) {
      return;
    }

    _workingDraft = _WorkingDraft(
      name: persistedDraft.name,
      items: _cloneItems(persistedDraft.items),
      updatedAt: persistedDraft.updatedAt,
    );

    state = state.copyWith(
      hasDraft: true,
      draftPromptPending: true,
      draftName: persistedDraft.name,
    );
  }

  Future<bool> enterEditMode(ShoppingList list) async {
    if (state.isEditMode) {
      return true;
    }

    if (_workingDraft == null) {
      _workingDraft = _WorkingDraft(
        name: list.name,
        items: _cloneItems(_confirmedItems),
        updatedAt: DateTime.now(),
      );
      await _persistDraft();
    }

    state = state.copyWith(
      isEditMode: true,
      hasDraft: true,
      draftPromptPending: false,
      draftName: _workingDraft!.name,
      clearErrorMessage: true,
    );
    _applyVisibleItems(_workingDraft!.items);
    return true;
  }

  Future<bool> continueDraftEditing(ShoppingList list) {
    return enterEditMode(list);
  }

  Future<bool> cancelChanges() async {
    if (!state.isEditMode || _workingDraft == null) {
      return false;
    }

    await _persistDraft();
    state = state.copyWith(
      isEditMode: false,
      hasDraft: true,
      draftPromptPending: false,
      draftName: _workingDraft!.name,
      clearErrorMessage: true,
    );
    _applyVisibleItems(_confirmedItems);
    return true;
  }

  Future<bool> discardDraft() async {
    try {
      await _shoppingListRepository.deleteDraft(arg);
      _workingDraft = null;
      state = state.copyWith(
        isEditMode: false,
        hasDraft: false,
        draftPromptPending: false,
        clearDraftName: true,
        clearErrorMessage: true,
      );
      _applyVisibleItems(_confirmedItems);
      return true;
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to discard draft.');
      return false;
    }
  }

  Future<bool> applyDraft(ShoppingList list) async {
    if (_workingDraft == null) {
      return false;
    }

    try {
      state = state.copyWith(isBusy: true, clearErrorMessage: true);

      final DateTime now = DateTime.now();
      if (list.name.trim() != _workingDraft!.name.trim()) {
        final ShoppingList renamed = ShoppingList(
          id: list.id,
          inventoryId: list.inventoryId,
          name: _workingDraft!.name.trim(),
          listType: list.listType,
          routingMode: list.routingMode,
          status: list.status,
          createdAt: list.createdAt,
          updatedAt: now,
          deletedAt: list.deletedAt,
          syncStatus: 'pending_sync',
          version: list.version + 1,
        );
        await _shoppingListRepository.saveShoppingList(renamed);
      }

      final Map<String, ShoppingListItem> draftById =
          <String, ShoppingListItem>{
        for (final ShoppingListItem item in _workingDraft!.items) item.id: item,
      };

      for (final ShoppingListItem draftItem in _workingDraft!.items) {
        final ShoppingListItem normalized = draftItem.copyWith(
          shoppingListId: arg,
          deletedAt: null,
        );
        await _shoppingListRepository.saveShoppingListItem(normalized);
      }

      for (final ShoppingListItem confirmed in _confirmedItems) {
        if (draftById.containsKey(confirmed.id)) {
          continue;
        }
        final DateTime removedAt = DateTime.now();
        await _shoppingListRepository.saveShoppingListItem(
          confirmed.copyWith(
            deletedAt: removedAt,
            updatedAt: removedAt,
            version: confirmed.version + 1,
            syncStatus: 'pending_sync',
          ),
        );
      }

      await _shoppingListRepository.deleteDraft(arg);
      _workingDraft = null;

      state = state.copyWith(
        isBusy: false,
        isEditMode: false,
        hasDraft: false,
        draftPromptPending: false,
        clearDraftName: true,
      );
      _applyVisibleItems(_confirmedItems);
      return true;
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to apply draft changes.',
      );
      return false;
    }
  }

  Future<void> addFromQuickAdd({
    ProductSuggestion? selectedSuggestion,
    bool forceCustom = false,
  }) async {
    final String trimmedInput = state.quickAddInput.trim();
    if (trimmedInput.isEmpty) {
      return;
    }

    final ProductSuggestion fallbackSuggestion = _suggestionService
        .suggest(
          rawInput: trimmedInput,
          availableProducts: _products,
          aliases: _aliases,
          usageStats: _usageStats,
          maxResults: 1,
        )
        .first;

    final ProductSuggestion baseSuggestion =
        selectedSuggestion ?? fallbackSuggestion;

    final Product? matchedProduct = forceCustom
        ? null
        : _resolveMatchedProduct(baseSuggestion, fallbackSuggestion);

    final DateTime now = DateTime.now();
    final Unit? parsedUnit = _toSupportedUnit(
      baseSuggestion.parsedUnit ?? fallbackSuggestion.parsedUnit,
    );

    final String normalizedRawText = (baseSuggestion.normalizedQuery.isNotEmpty
            ? baseSuggestion.normalizedQuery
            : trimmedInput)
        .trim();

    final ShoppingListItem item = ShoppingListItem(
      id: _uuid.v4(),
      shoppingListId: arg,
      productId: matchedProduct?.id,
      rawText: matchedProduct?.canonicalName ?? normalizedRawText,
      quantity:
          baseSuggestion.parsedQuantity ?? fallbackSuggestion.parsedQuantity,
      unit: parsedUnit,
      status: ShoppingListItemStatus.pending,
      source: matchedProduct == null
          ? ShoppingListItemSource.manual
          : ShoppingListItemSource.suggestion,
      priorityScore: matchedProduct == null
          ? 0.1
          : (baseSuggestion.confidenceScore > 0
              ? baseSuggestion.confidenceScore
              : fallbackSuggestion.confidenceScore),
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending_sync',
      version: 1,
    );

    try {
      state = state.copyWith(isBusy: true, clearErrorMessage: true);
      if (state.isEditMode) {
        await _upsertDraftItem(item);
      } else {
        await _shoppingListRepository.saveShoppingListItem(item);
      }
      state = state.copyWith(
        isBusy: false,
        quickAddInput: '',
        suggestions: const <ProductSuggestion>[],
      );
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to add item. Please try again.',
      );
    }
  }

  Future<void> addCustomItem() {
    return addFromQuickAdd(forceCustom: true);
  }

  Future<bool> renameList(ShoppingList list, String newName) async {
    final String trimmed = newName.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    if (state.isEditMode) {
      _workingDraft ??= _WorkingDraft(
        name: list.name,
        items: _cloneItems(_confirmedItems),
        updatedAt: DateTime.now(),
      );
      _workingDraft = _workingDraft!.copyWith(
        name: trimmed,
        updatedAt: DateTime.now(),
      );
      await _persistDraft();
      state = state.copyWith(
        hasDraft: true,
        draftName: trimmed,
        clearErrorMessage: true,
      );
      return true;
    }

    final DateTime now = DateTime.now();
    final ShoppingList updated = ShoppingList(
      id: list.id,
      inventoryId: list.inventoryId,
      name: trimmed,
      listType: list.listType,
      routingMode: list.routingMode,
      status: list.status,
      createdAt: list.createdAt,
      updatedAt: now,
      deletedAt: list.deletedAt,
      syncStatus: 'pending_sync',
      version: list.version + 1,
    );

    try {
      await _shoppingListRepository.saveShoppingList(updated);
      _undoStack.add(_ShoppingListUndoEntry(list: list));
      return true;
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to rename list.');
      return false;
    }
  }

  Future<bool> updateItemQuantityAndUnit({
    required ShoppingListItem item,
    double? quantity,
    String? unitCode,
  }) {
    final DateTime now = DateTime.now();
    final Unit? unit = _toSupportedUnit(unitCode);
    return _saveItem(
      item.copyWith(
        quantity: quantity,
        unit: unit,
        updatedAt: now,
        version: item.version + 1,
        syncStatus: 'pending_sync',
      ),
    );
  }

  Future<bool> markPurchased(ShoppingListItem item) {
    return _saveItem(
      item.transitionTo(ShoppingListItemStatus.purchased),
      undoItem: item,
    );
  }

  Future<bool> markSkipped(ShoppingListItem item) {
    return _saveItem(
      item.transitionTo(ShoppingListItemStatus.skipped),
      undoItem: item,
    );
  }

  Future<bool> restorePending(ShoppingListItem item) {
    return _saveItem(
      item.transitionTo(ShoppingListItemStatus.pending),
      undoItem: item,
    );
  }

  Future<bool> softDelete(ShoppingListItem item) {
    final DateTime now = DateTime.now();
    return _saveItem(
      item.copyWith(
        deletedAt: now,
        updatedAt: now,
        version: item.version + 1,
        syncStatus: 'pending_sync',
      ),
      undoItem: item,
    );
  }

  void setPurchasedCollapsed(bool collapsed) {
    state = state.copyWith(purchasedCollapsed: collapsed);
  }

  void setShoppingModeEnabled(bool enabled) {
    state = state.copyWith(shoppingModeEnabled: enabled);
  }

  void setFocusedItem(String? itemId) {
    if (itemId == null) {
      state = state.copyWith(clearFocusedItem: true);
      return;
    }
    state = state.copyWith(focusedItemId: itemId);
  }

  void _subscribeProducts() {
    _productsSubscription?.cancel();
    _productsSubscription = _productRepository
        .watchActiveProducts()
        .listen((List<Product> products) {
      _products = products;
      _loadAliases();
      _refreshSuggestions();
    });
  }

  void _subscribeListItems(String shoppingListId) {
    _listItemsSubscription?.cancel();
    _listItemsSubscription = _shoppingListRepository
        .watchItemsForList(shoppingListId)
        .listen((List<ShoppingListItem> items) {
      _confirmedItems = items
          .where((ShoppingListItem item) => item.deletedAt == null)
          .toList(growable: false);
      _usageStats = _buildUsageStats(items);

      if (!state.isEditMode) {
        _applyVisibleItems(_confirmedItems);
      }

      _refreshSuggestions();
    });
  }

  Future<void> _loadAliases() async {
    final List<String> productIds =
        _products.map((Product product) => product.id).toList(growable: false);
    if (productIds.isEmpty) {
      _aliases = const <ProductAlias>[];
      return;
    }

    try {
      _aliases = await _productRepository.findAliasesForProducts(productIds);
    } catch (_) {
      _aliases = const <ProductAlias>[];
    }
  }

  List<ProductUsageStat> _buildUsageStats(List<ShoppingListItem> items) {
    final Map<String, int> frequencyByProduct = <String, int>{};
    final Map<String, DateTime?> lastUsedByProduct = <String, DateTime?>{};

    for (final ShoppingListItem item in items) {
      final String? productId = item.productId;
      if (productId == null) {
        continue;
      }

      frequencyByProduct[productId] = (frequencyByProduct[productId] ?? 0) + 1;

      final DateTime candidate = item.purchasedAt ?? item.updatedAt;
      final DateTime? existing = lastUsedByProduct[productId];
      if (existing == null || candidate.isAfter(existing)) {
        lastUsedByProduct[productId] = candidate;
      }
    }

    return frequencyByProduct.entries
        .map(
          (MapEntry<String, int> entry) => ProductUsageStat(
            productId: entry.key,
            frequency: entry.value,
            lastUsedAt: lastUsedByProduct[entry.key],
          ),
        )
        .toList(growable: false);
  }

  Product? _resolveMatchedProduct(
    ProductSuggestion base,
    ProductSuggestion fallback,
  ) {
    if (base.suggestedProduct != null &&
        base.reasonCode != SuggestionReasonCode.unknownProduct &&
        base.reasonCode != SuggestionReasonCode.emptyInput) {
      return base.suggestedProduct;
    }

    if (fallback.suggestedProduct != null &&
        fallback.reasonCode != SuggestionReasonCode.unknownProduct &&
        fallback.reasonCode != SuggestionReasonCode.emptyInput) {
      return fallback.suggestedProduct;
    }

    return null;
  }

  Unit? _toSupportedUnit(String? code) {
    if (code == null || code.trim().isEmpty) {
      return null;
    }

    final String normalized = code.trim().toLowerCase();

    if (!Unit.supportedCodes.contains(normalized)) {
      return null;
    }

    return Unit.fromCode(normalized);
  }

  void _refreshSuggestions() {
    final String input = state.quickAddInput.trim();
    if (input.isEmpty) {
      state = state.copyWith(suggestions: const <ProductSuggestion>[]);
      return;
    }

    final List<ProductSuggestion> all = _suggestionService.suggest(
      rawInput: input,
      availableProducts: _products,
      aliases: _aliases,
      usageStats: _usageStats,
      maxResults: 6,
    );

    final List<ProductSuggestion> suggestions = all
        .where(
          (ProductSuggestion suggestion) => suggestion.suggestedProduct != null,
        )
        .toList(growable: false);

    state = state.copyWith(suggestions: suggestions);
  }

  Future<bool> undoLastAction() async {
    if (state.isEditMode) {
      return false;
    }

    if (_undoStack.isEmpty) {
      return false;
    }

    final _ShoppingListUndoEntry entry = _undoStack.removeLast();
    try {
      if (entry.item != null) {
        await _shoppingListRepository.saveShoppingListItem(entry.item!);
      } else if (entry.list != null) {
        await _shoppingListRepository.saveShoppingList(entry.list!);
      }
      state = state.copyWith(clearErrorMessage: true);
      return true;
    } catch (_) {
      state = state.copyWith(errorMessage: 'Unable to undo item action.');
      return false;
    }
  }

  Future<bool> _saveItem(
    ShoppingListItem item, {
    ShoppingListItem? undoItem,
  }) async {
    if (state.isEditMode) {
      await _upsertDraftItem(item);
      return true;
    }

    try {
      state = state.copyWith(isBusy: true, clearErrorMessage: true);
      await _shoppingListRepository.saveShoppingListItem(
        item,
      );
      if (item.status == ShoppingListItemStatus.purchased) {
        await _savePurchasedItemToLinkedInventories(item);
      }
      if (undoItem != null) {
        _undoStack.add(_ShoppingListUndoEntry(item: undoItem));
      }
      state = state.copyWith(isBusy: false);
      return true;
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to update item. Please try again.',
      );
      return false;
    }
  }

  Future<void> _savePurchasedItemToLinkedInventories(
    ShoppingListItem purchased,
  ) async {
    final List<Inventory> linkedInventories =
        await _shoppingListRepository.watchInventoriesForList(arg).first;

    if (linkedInventories.isEmpty) {
      return;
    }

    final DateTime now = DateTime.now();
    for (final Inventory inventory in linkedInventories) {
      final InventoryItem inventoryItem = InventoryItem(
        id: _uuid.v4(),
        inventoryId: inventory.id,
        productId: purchased.productId,
        rawName: purchased.productId == null ? purchased.rawText : null,
        quantityEstimated: purchased.quantity,
        unit: purchased.unit,
        status: InventoryItemStatus.inStock,
        confidenceScore: purchased.productId == null ? 0.6 : 0.95,
        lastConfirmedAt: now,
        createdAt: now,
        updatedAt: now,
        syncStatus: 'pending_sync',
        version: 1,
      );

      final InventoryEvent inventoryEvent = InventoryEvent(
        id: _uuid.v4(),
        productId: purchased.productId,
        inventoryId: inventory.id,
        inventoryItemId: inventoryItem.id,
        eventType: InventoryEventType.purchase,
        quantity: purchased.quantity,
        unit: purchased.unit,
        source: InventoryEventSource.system,
        occurredAt: now,
        createdAt: now,
      );

      await _inventoryRepository.saveInventoryItem(inventoryItem);
      await _inventoryRepository.addInventoryEvent(inventoryEvent);
    }
  }

  Future<void> _upsertDraftItem(ShoppingListItem item) async {
    final _WorkingDraft draft = _workingDraft ??
        _WorkingDraft(
          name: state.draftName ?? '',
          items: _cloneItems(_confirmedItems),
          updatedAt: DateTime.now(),
        );

    final List<ShoppingListItem> items = draft.items
        .map((ShoppingListItem item) => item.copyWith())
        .toList(growable: true);
    final int index =
        items.indexWhere((ShoppingListItem entry) => entry.id == item.id);

    if (item.deletedAt != null) {
      if (index >= 0) {
        items.removeAt(index);
      }
    } else if (index >= 0) {
      items[index] = item;
    } else {
      items.add(item);
    }

    _workingDraft = draft.copyWith(items: items, updatedAt: DateTime.now());
    await _persistDraft();

    state = state.copyWith(
      hasDraft: true,
      draftName: _workingDraft!.name,
      clearErrorMessage: true,
    );
    if (state.isEditMode) {
      _applyVisibleItems(_workingDraft!.items);
    }
  }

  Future<void> _persistDraft() {
    final _WorkingDraft? draft = _workingDraft;
    if (draft == null) {
      return Future<void>.value();
    }

    return _shoppingListRepository.saveDraft(
      ShoppingListDraft(
        shoppingListId: arg,
        name: draft.name,
        items: _cloneItems(draft.items),
        updatedAt: draft.updatedAt,
      ),
    );
  }

  void _applyVisibleItems(List<ShoppingListItem> source) {
    final List<ShoppingListItem> pending = source
        .where(
          (ShoppingListItem item) =>
              item.deletedAt == null &&
              item.status == ShoppingListItemStatus.pending,
        )
        .toList(growable: false);
    final List<ShoppingListItem> purchased = source
        .where(
          (ShoppingListItem item) =>
              item.deletedAt == null &&
              item.status == ShoppingListItemStatus.purchased,
        )
        .toList(growable: false);
    final List<ShoppingListItem> skipped = source
        .where(
          (ShoppingListItem item) =>
              item.deletedAt == null &&
              item.status == ShoppingListItemStatus.skipped,
        )
        .toList(growable: false);

    final String? focusedItemId = state.focusedItemId;
    final bool focusedStillExists = focusedItemId != null &&
        source.any((ShoppingListItem item) => item.id == focusedItemId);
    final String? nextFocusedItemId = focusedStillExists
        ? focusedItemId
        : (pending.isNotEmpty ? pending.first.id : null);

    state = state.copyWith(
      pendingItems: pending,
      purchasedItems: purchased,
      skippedItems: skipped,
      focusedItemId: nextFocusedItemId,
      clearFocusedItem: nextFocusedItemId == null,
    );
  }

  List<ShoppingListItem> _cloneItems(List<ShoppingListItem> items) {
    return items
        .map(
          (ShoppingListItem item) => item.copyWith(),
        )
        .toList(growable: false);
  }
}

class _ShoppingListUndoEntry {
  const _ShoppingListUndoEntry({this.item, this.list});

  final ShoppingListItem? item;
  final ShoppingList? list;
}

class _WorkingDraft {
  const _WorkingDraft({
    required this.name,
    required this.items,
    required this.updatedAt,
  });

  final String name;
  final List<ShoppingListItem> items;
  final DateTime updatedAt;

  _WorkingDraft copyWith({
    String? name,
    List<ShoppingListItem>? items,
    DateTime? updatedAt,
  }) {
    return _WorkingDraft(
      name: name ?? this.name,
      items: items ?? this.items,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
