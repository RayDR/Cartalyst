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
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_category.dart';
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
  final Map<String, String> _manualCategoryPreferenceByProductId =
      <String, String>{};
  final Map<String, String> _manualCategoryPreferenceByItemName =
      <String, String>{};

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

  Future<String?> createCategory(String name) {
    return _shoppingListRepository.createCategoryForList(
      shoppingListId: arg,
      name: name,
    );
  }

  Future<String?> suggestCategoryForInput(String rawInput) async {
    final String trimmed = rawInput.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final ProductSuggestion fallbackSuggestion = _suggestionService
        .suggest(
          rawInput: trimmed,
          availableProducts: _products,
          aliases: _aliases,
          usageStats: _usageStats,
          maxResults: 1,
        )
        .first;
    final Product? matchedProduct = _resolveMatchedProduct(
      fallbackSuggestion,
      fallbackSuggestion,
    );

    return _resolveSuggestedCategoryId(
      rawInput: trimmed,
      matchedProduct: matchedProduct,
    );
  }

  Future<bool> addItemWithDetails({
    required String name,
    double? quantity,
    String? unitCode,
    String? targetInventoryId,
    String? categoryId,
  }) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    final ProductSuggestion fallbackSuggestion = _suggestionService
        .suggest(
          rawInput: trimmed,
          availableProducts: _products,
          aliases: _aliases,
          usageStats: _usageStats,
          maxResults: 1,
        )
        .first;
    final Product? matchedProduct = _resolveMatchedProduct(
      fallbackSuggestion,
      fallbackSuggestion,
    );

    final String? resolvedCategoryId = categoryId ??
        await _resolveSuggestedCategoryId(
          rawInput: trimmed,
          matchedProduct: matchedProduct,
        );

    if (resolvedCategoryId != null) {
      _rememberManualCategoryChoice(
        categoryId: resolvedCategoryId,
        rawInput: trimmed,
        productId: matchedProduct?.id,
      );
    }

    final DateTime now = DateTime.now();
    final ShoppingListItem item = ShoppingListItem(
      id: _uuid.v4(),
      shoppingListId: arg,
      productId: matchedProduct?.id,
      categoryId: resolvedCategoryId,
      targetInventoryId: targetInventoryId,
      rawText: matchedProduct?.canonicalName ?? trimmed,
      quantity: quantity,
      unit: _toSupportedUnit(unitCode),
      status: ShoppingListItemStatus.pending,
      source: matchedProduct == null
          ? ShoppingListItemSource.manual
          : ShoppingListItemSource.suggestion,
      priorityScore:
          matchedProduct == null ? 0.2 : fallbackSuggestion.confidenceScore,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending_sync',
      version: 1,
    );

    return _saveItem(item);
  }

  Future<bool> reassignItemCategory(
    ShoppingListItem item,
    String? categoryId,
  ) {
    final DateTime now = DateTime.now();
    if (categoryId != null) {
      _rememberManualCategoryChoice(
        categoryId: categoryId,
        rawInput: item.rawText,
        productId: item.productId,
      );
    }
    return _saveItem(
      item.copyWith(
        categoryId: categoryId,
        updatedAt: now,
        version: item.version + 1,
        syncStatus: 'pending_sync',
      ),
      undoItem: item,
    );
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
    String? categoryId,
  }) {
    final DateTime now = DateTime.now();
    final Unit? unit = _toSupportedUnit(unitCode);
    if (categoryId != null) {
      _rememberManualCategoryChoice(
        categoryId: categoryId,
        rawInput: item.rawText,
        productId: item.productId,
      );
    }
    return _saveItem(
      item.copyWith(
        quantity: quantity,
        unit: unit,
        categoryId: categoryId ?? item.categoryId,
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

  Future<String?> _resolveSuggestedCategoryId({
    required String rawInput,
    required Product? matchedProduct,
  }) async {
    final List<ShoppingListCategory> categories =
        await _shoppingListRepository.watchCategoriesForList(arg).first;
    final Map<String, String> nameToCategoryId = <String, String>{};
    String? uncategorizedId;

    for (final ShoppingListCategory category in categories) {
      final String? name = category.categoryName;
      if (name == null) {
        continue;
      }
      final String normalized = name.trim().toLowerCase();
      nameToCategoryId[normalized] = category.categoryId;
      if (normalized == 'uncategorized') {
        uncategorizedId = category.categoryId;
      }
    }

    final String normalizedInput = rawInput.trim().toLowerCase();
    final String? preferredByProduct = matchedProduct == null
        ? null
        : _manualCategoryPreferenceByProductId[matchedProduct.id];
    if (preferredByProduct != null) {
      return preferredByProduct;
    }

    final String? preferredByName =
        _manualCategoryPreferenceByItemName[normalizedInput];
    if (preferredByName != null) {
      return preferredByName;
    }

    final String? fromProductDefault = matchedProduct == null
        ? null
        : nameToCategoryId[matchedProduct.category.trim().toLowerCase()];
    if (fromProductDefault != null) {
      return fromProductDefault;
    }

    if (uncategorizedId != null) {
      return uncategorizedId;
    }

    await _shoppingListRepository.ensureUncategorizedCategoryForList(arg);
    final List<ShoppingListCategory> refreshed =
        await _shoppingListRepository.watchCategoriesForList(arg).first;
    for (final ShoppingListCategory category in refreshed) {
      final String? name = category.categoryName;
      if (name != null && name.trim().toLowerCase() == 'uncategorized') {
        return category.categoryId;
      }
    }

    return null;
  }

  void _rememberManualCategoryChoice({
    required String categoryId,
    required String rawInput,
    String? productId,
  }) {
    final String normalized = rawInput.trim().toLowerCase();
    if (normalized.isNotEmpty) {
      _manualCategoryPreferenceByItemName[normalized] = categoryId;
    }
    if (productId != null && productId.trim().isNotEmpty) {
      _manualCategoryPreferenceByProductId[productId] = categoryId;
    }
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
        final String? routingMessage =
            await _savePurchasedItemToLinkedInventories(item);
        if (routingMessage != null) {
          state = state.copyWith(errorMessage: routingMessage);
        }
      }
      if (undoItem != null) {
        _undoStack.add(_ShoppingListUndoEntry(item: undoItem));
      }
      state = state.copyWith(isBusy: false);
      if (item.status == ShoppingListItemStatus.purchased ||
          item.status == ShoppingListItemStatus.skipped) {
        _checkAndMarkCompletedAfterTransition(item);
      }
      return true;
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Unable to update item. Please try again.',
      );
      return false;
    }
  }

  void _checkAndMarkCompletedAfterTransition(ShoppingListItem savedItem) {
    final List<ShoppingListItem> hypothetical = _confirmedItems
        .map(
          (ShoppingListItem existing) =>
              existing.id == savedItem.id ? savedItem : existing,
        )
        .toList(growable: false);

    final List<ShoppingListItem> nonDeleted = hypothetical
        .where((ShoppingListItem i) => i.deletedAt == null)
        .toList(growable: false);

    if (nonDeleted.isEmpty) {
      return;
    }

    final bool allDone = nonDeleted.every(
      (ShoppingListItem i) =>
          i.status == ShoppingListItemStatus.purchased ||
          i.status == ShoppingListItemStatus.skipped,
    );

    if (allDone) {
      _shoppingListRepository.markListCompleted(arg).ignore();
    }
  }

  Future<String?> _savePurchasedItemToLinkedInventories(
    ShoppingListItem purchased,
  ) async {
    final ShoppingList? currentList = await _readCurrentList();
    if (currentList == null ||
        currentList.listType == ShoppingListType.simple ||
        currentList.routingMode == ShoppingListRoutingMode.none) {
      return _routePurchasedAsSimple(purchased);
    }

    if (currentList.routingMode ==
        ShoppingListRoutingMode.inventoryCategories) {
      return _routePurchasedToSingleInventoryByCategory(
        purchased,
        list: currentList,
      );
    }

    return _routePurchasedByCategoryTargetInventory(purchased);
  }

  Future<String?> _routePurchasedAsSimple(ShoppingListItem purchased) async {
    final List<Inventory> linkedInventories =
        await _shoppingListRepository.watchInventoriesForList(arg).first;

    if (linkedInventories.isEmpty) {
      return null;
    }

    final DateTime now = DateTime.now();
    for (final Inventory inventory in linkedInventories) {
      await _createInventoryItemFromPurchased(
        purchased,
        inventoryId: inventory.id,
        inventoryCategoryId: null,
        occurredAt: now,
      );
    }

    return null;
  }

  Future<String?> _routePurchasedToSingleInventoryByCategory(
    ShoppingListItem purchased, {
    required ShoppingList list,
  }) async {
    final List<ShoppingListCategory> mappings =
        await _shoppingListRepository.watchCategoriesForList(arg).first;

    ShoppingListCategory? mapping;
    final String? itemCategoryId = purchased.categoryId;
    if (itemCategoryId != null) {
      for (final ShoppingListCategory value in mappings) {
        if (value.categoryId != itemCategoryId) {
          continue;
        }
        if (mapping == null) {
          mapping = value;
          continue;
        }
        final bool currentHasTarget =
            (mapping.targetInventoryCategoryId != null &&
                    mapping.targetInventoryCategoryId!.trim().isNotEmpty) ||
                (mapping.targetInventoryId != null &&
                    mapping.targetInventoryId!.trim().isNotEmpty);
        final bool candidateHasTarget =
            (value.targetInventoryCategoryId != null &&
                    value.targetInventoryCategoryId!.trim().isNotEmpty) ||
                (value.targetInventoryId != null &&
                    value.targetInventoryId!.trim().isNotEmpty);
        if (!currentHasTarget && candidateHasTarget) {
          mapping = value;
        }
      }
    }

    final List<Inventory> linkedInventories =
        await _shoppingListRepository.watchInventoriesForList(arg).first;
    final String? inventoryId = mapping?.targetInventoryId ??
        (linkedInventories.isEmpty
            ? list.inventoryId
            : linkedInventories.first.id);

    if (inventoryId == null || inventoryId.trim().isEmpty) {
      return 'Item marked as purchased. Select an inventory to complete routing.';
    }

    final String inventoryCategoryId = mapping?.targetInventoryCategoryId ??
        await _inventoryRepository.ensureUncategorizedInventoryCategory(
          inventoryId,
        );

    await _createInventoryItemFromPurchased(
      purchased,
      inventoryId: inventoryId,
      inventoryCategoryId: inventoryCategoryId,
      occurredAt: DateTime.now(),
    );
    return null;
  }

  Future<String?> _routePurchasedByCategoryTargetInventory(
    ShoppingListItem purchased,
  ) async {
    final List<ShoppingListCategory> mappings =
        await _shoppingListRepository.watchCategoriesForList(arg).first;

    final String? itemCategoryId = purchased.categoryId;
    ShoppingListCategory? mapping;
    if (itemCategoryId != null) {
      for (final ShoppingListCategory value in mappings) {
        if (value.categoryId != itemCategoryId) {
          continue;
        }
        if (mapping == null) {
          mapping = value;
          continue;
        }
        final bool currentHasTarget = mapping.targetInventoryId != null &&
            mapping.targetInventoryId!.trim().isNotEmpty;
        final bool candidateHasTarget = value.targetInventoryId != null &&
            value.targetInventoryId!.trim().isNotEmpty;
        if (!currentHasTarget && candidateHasTarget) {
          mapping = value;
        }
      }
    }

    final String? targetInventoryId = mapping?.targetInventoryId;
    if (targetInventoryId == null || targetInventoryId.trim().isEmpty) {
      return 'Item marked as purchased. Choose or create a target inventory for this category.';
    }

    final String inventoryCategoryId = mapping?.targetInventoryCategoryId ??
        await _inventoryRepository.ensureUncategorizedInventoryCategory(
          targetInventoryId,
        );

    await _createInventoryItemFromPurchased(
      purchased,
      inventoryId: targetInventoryId,
      inventoryCategoryId: inventoryCategoryId,
      occurredAt: DateTime.now(),
    );
    return null;
  }

  Future<void> _createInventoryItemFromPurchased(
    ShoppingListItem purchased, {
    required String inventoryId,
    required String? inventoryCategoryId,
    required DateTime occurredAt,
  }) async {
    final InventoryItem inventoryItem = InventoryItem(
      id: _uuid.v4(),
      inventoryId: inventoryId,
      inventoryCategoryId: inventoryCategoryId,
      productId: purchased.productId,
      rawName: purchased.productId == null ? purchased.rawText : null,
      quantityEstimated: purchased.quantity,
      unit: purchased.unit,
      status: InventoryItemStatus.inStock,
      confidenceScore: purchased.productId == null ? 0.6 : 0.95,
      lastConfirmedAt: occurredAt,
      createdAt: occurredAt,
      updatedAt: occurredAt,
      syncStatus: 'pending_sync',
      version: 1,
    );

    final InventoryEvent inventoryEvent = InventoryEvent(
      id: _uuid.v4(),
      productId: purchased.productId,
      inventoryId: inventoryId,
      inventoryItemId: inventoryItem.id,
      eventType: InventoryEventType.purchase,
      quantity: purchased.quantity,
      unit: purchased.unit,
      source: InventoryEventSource.system,
      occurredAt: occurredAt,
      createdAt: occurredAt,
    );

    await _inventoryRepository.saveInventoryItem(inventoryItem);
    await _inventoryRepository.addInventoryEvent(inventoryEvent);
  }

  Future<ShoppingList?> _readCurrentList() async {
    final List<ShoppingList> lists =
        await _shoppingListRepository.watchAllLists().first;
    for (final ShoppingList list in lists) {
      if (list.id == arg) {
        return list;
      }
    }
    return null;
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

    state = state.copyWith(
      pendingItems: pending,
      purchasedItems: purchased,
      skippedItems: skipped,
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
