import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart'
    show inventoryRepositoryProvider;
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_state.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/features/products/domain/services/product_suggestion_service.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show productRepositoryProvider, uuidProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final inventoryDetailControllerProvider = NotifierProviderFamily<
    InventoryDetailController, InventoryDetailState, String>(
  InventoryDetailController.new,
);

class InventoryDetailController
    extends FamilyNotifier<InventoryDetailState, String> {
  late final InventoryRepository _repository;
  late final ProductRepository _productRepository;
  late final ProductSuggestionService _suggestionService;
  late final Uuid _uuid;
  List<Product> _products = const <Product>[];
  List<ProductAlias> _aliases = const <ProductAlias>[];
  List<ProductUsageStat> _usageStats = const <ProductUsageStat>[];
  Map<String, String> _customNamesByNormalized = const <String, String>{};
  final Map<String, String> _manualCategoryPreferenceByProductId =
      <String, String>{};
  final Map<String, String> _manualCategoryPreferenceByName =
      <String, String>{};

  StreamSubscription<List<InventoryItem>>? _itemsSubscription;
  StreamSubscription<List<Product>>? _productsSubscription;
  StreamSubscription<List<InventoryCategory>>? _categoriesSubscription;

  @override
  InventoryDetailState build(String arg) {
    _repository = ref.watch(inventoryRepositoryProvider);
    _productRepository = ref.watch(productRepositoryProvider);
    _suggestionService = const ProductSuggestionService();
    _uuid = ref.watch(uuidProvider);

    ref.onDispose(() {
      _itemsSubscription?.cancel();
      _productsSubscription?.cancel();
      _categoriesSubscription?.cancel();
    });

    _itemsSubscription =
        _repository.watchInventoryItems(arg).listen(_onItemsChanged);

    _productsSubscription =
        _productRepository.watchActiveProducts().listen((List<Product> prods) {
      _products = prods;
      _loadAliases();
      state = state.copyWith(products: prods);
      _refreshNameSuggestions();
    });

    _categoriesSubscription =
        _repository.watchInventoryCategories(arg).listen((categories) {
      state = state.copyWith(categories: categories);
    });

    return const InventoryDetailState.initial();
  }

  void updateNameInput(String value) {
    state = state.copyWith(
      nameInput: value,
      selectedProductId: _resolveExactMatchedProductId(value),
      clearMessage: true,
    );
    _refreshNameSuggestions();
  }

  void updateSelectedProduct(String? productId) {
    state = productId == null
        ? state.copyWith(clearSelectedProduct: true)
        : state.copyWith(selectedProductId: productId);
    _refreshNameSuggestions();
  }

  void useNameSuggestion(InventoryNameSuggestion suggestion) {
    state = state.copyWith(
      nameInput: suggestion.label,
      selectedProductId: suggestion.productId,
      clearMessage: true,
    );
    _refreshNameSuggestions();
  }

  void updateQuantityInput(String value) {
    state = state.copyWith(quantityInput: value, clearMessage: true);
  }

  void updateUnitCode(String? unitCode) {
    state = unitCode == null
        ? state.copyWith(clearUnitCode: true, clearMessage: true)
        : state.copyWith(unitCode: unitCode, clearMessage: true);
  }

  Future<void> addItem() async {
    final String trimmedName = state.nameInput.trim();
    final String? productId =
        state.selectedProductId ?? _resolveExactMatchedProductId(trimmedName);

    if (trimmedName.isEmpty) {
      state = state.copyWith(message: 'Item name is required.');
      return;
    }

    await addItemWithDetails(
      name: trimmedName,
      quantity: double.tryParse(state.quantityInput.trim()),
      unitCode: state.unitCode,
      productId: productId,
    );

    state = state.copyWith(
      nameInput: '',
      clearSelectedProduct: true,
      quantityInput: '',
      clearUnitCode: true,
      nameSuggestions: const <InventoryNameSuggestion>[],
      message: 'Item added.',
    );
  }

  Future<void> addItemWithDetails({
    required String name,
    double? quantity,
    String? unitCode,
    String? productId,
    String? inventoryCategoryId,
  }) async {
    final String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      state = state.copyWith(message: 'Item name is required.');
      return;
    }

    final String? resolvedProductId = productId?.trim().isEmpty == true
        ? null
        : (productId ?? _resolveExactMatchedProductId(trimmedName));
    final Unit? unit = _safeUnit(unitCode);
    final String resolvedCategoryId = inventoryCategoryId ??
        await _resolveSuggestedCategoryId(
          rawName: trimmedName,
          productId: resolvedProductId,
        );

    final DateTime now = DateTime.now();
    final InventoryItem item = InventoryItem(
      id: _uuid.v4(),
      inventoryId: arg,
      inventoryCategoryId: resolvedCategoryId,
      productId: resolvedProductId,
      rawName: resolvedProductId == null ? trimmedName : null,
      quantityEstimated: quantity,
      unit: unit,
      status: InventoryItemStatus.inStock,
      confidenceScore: resolvedProductId == null ? 0.5 : 0.9,
      lastConfirmedAt: now,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending_sync',
      version: 1,
    );

    final InventoryEvent event = _buildEvent(
      item: item,
      eventType: InventoryEventType.purchase,
      quantity: quantity,
      unit: unit,
      occurredAt: now,
    );

    await _saveItemAndEvent(item: item, event: event);
    _rememberCategoryChoice(
      categoryId: resolvedCategoryId,
      rawName: trimmedName,
      productId: resolvedProductId,
    );
    _registerCustomName(item.rawName);
  }

  Future<String?> createCategory(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final DateTime now = DateTime.now();
    final String categoryId = _uuid.v4();
    final String inventoryCategoryId = _uuid.v4();
    final int sortOrder = state.categories.length;

    await _repository.saveCategory(
      Category(
        id: categoryId,
        name: trimmed,
        createdAt: now,
        updatedAt: now,
        syncStatus: 'pending_sync',
        version: 1,
      ),
    );

    await _repository.saveInventoryCategory(
      InventoryCategory(
        id: inventoryCategoryId,
        inventoryId: arg,
        categoryId: categoryId,
        name: trimmed,
        sortOrder: sortOrder,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return inventoryCategoryId;
  }

  Future<String> suggestCategoryForName(
    String rawName, {
    String? productId,
  }) {
    return _resolveSuggestedCategoryId(
      rawName: rawName,
      productId: productId,
    );
  }

  Future<void> markInStock(InventoryItem item) async {
    final DateTime now = DateTime.now();
    final InventoryItem updated = item.copyWith(
      status: InventoryItemStatus.inStock,
      lastConfirmedAt: now,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );
    await _saveItemAndEvent(
      item: updated,
      event: _buildEvent(
        item: updated,
        eventType: InventoryEventType.purchase,
        quantity: updated.quantityEstimated,
        unit: updated.unit,
        occurredAt: now,
      ),
    );
  }

  Future<void> markRunningLow(InventoryItem item) async {
    final DateTime now = DateTime.now();
    final InventoryItem updated = item.copyWith(
      status: InventoryItemStatus.low,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );
    await _saveItemAndEvent(
      item: updated,
      event: _buildEvent(
        item: updated,
        eventType: InventoryEventType.consume,
        quantity: updated.quantityEstimated,
        unit: updated.unit,
        occurredAt: now,
      ),
    );
  }

  Future<void> markFinished(InventoryItem item) async {
    final DateTime now = DateTime.now();
    final InventoryItem updated = item.copyWith(
      status: InventoryItemStatus.out,
      quantityEstimated: 0,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );
    await _saveItemAndEvent(
      item: updated,
      event: _buildEvent(
        item: updated,
        eventType: InventoryEventType.finish,
        quantity: 0,
        unit: updated.unit,
        occurredAt: now,
      ),
    );
  }

  Future<void> adjustItem({
    required InventoryItem item,
    required double? quantity,
    required String unitCode,
  }) async {
    final DateTime now = DateTime.now();
    final Unit? unit = _safeUnit(unitCode);
    final InventoryItem updated = item.copyWith(
      quantityEstimated: quantity,
      unit: unit,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );
    await _saveItemAndEvent(
      item: updated,
      event: _buildEvent(
        item: updated,
        eventType: InventoryEventType.adjust,
        quantity: quantity,
        unit: unit,
        occurredAt: now,
      ),
    );
  }

  Future<void> assignItemToCategory({
    required InventoryItem item,
    String? inventoryCategoryId,
  }) async {
    final DateTime now = DateTime.now();
    final InventoryItem updated = item.copyWith(
      inventoryCategoryId: inventoryCategoryId,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );
    await _saveItemAndEvent(
      item: updated,
      event: _buildEvent(
        item: updated,
        eventType: InventoryEventType.adjust,
        quantity: updated.quantityEstimated,
        unit: updated.unit,
        occurredAt: now,
      ),
    );
    if (inventoryCategoryId != null) {
      _rememberCategoryChoice(
        categoryId: inventoryCategoryId,
        rawName: item.rawName ?? '',
        productId: item.productId,
      );
    }
  }

  Future<void> softDelete(InventoryItem item) async {
    final DateTime now = DateTime.now();
    final InventoryItem updated = item.copyWith(
      deletedAt: now,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );
    await _saveItemAndEvent(
      item: updated,
      event: _buildEvent(
        item: updated,
        eventType: InventoryEventType.discard,
        quantity: updated.quantityEstimated,
        unit: updated.unit,
        occurredAt: now,
      ),
    );
  }

  Future<void> _saveItemAndEvent({
    required InventoryItem item,
    required InventoryEvent event,
  }) async {
    try {
      state = state.copyWith(isBusy: true, clearMessage: true);
      await _repository.saveInventoryItem(item);
      await _repository.addInventoryEvent(event);
      state = state.copyWith(isBusy: false);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        message: 'Unable to save update.',
      );
    }
  }

  void _onItemsChanged(List<InventoryItem> items) {
    final DateTime recentThreshold =
        DateTime.now().subtract(const Duration(days: 7));

    _usageStats = _buildUsageStats(items);
    _customNamesByNormalized = _buildCustomNameIndex(items);

    final List<InventoryItem> inStock = items
        .where((item) => item.status == InventoryItemStatus.inStock)
        .toList(growable: false);

    final List<InventoryItem> low = items
        .where((item) => item.status == InventoryItemStatus.low)
        .toList(growable: false);

    final List<InventoryItem> finished = items
        .where(
          (item) =>
              item.status == InventoryItemStatus.out &&
              item.updatedAt.isAfter(recentThreshold),
        )
        .toList(growable: false);

    state = state.copyWith(
      inStockItems: inStock,
      lowItems: low,
      finishedItems: finished,
    );
    _refreshNameSuggestions();
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
    _refreshNameSuggestions();
  }

  List<ProductUsageStat> _buildUsageStats(List<InventoryItem> items) {
    final Map<String, int> frequencyByProduct = <String, int>{};
    final Map<String, DateTime?> lastUsedByProduct = <String, DateTime?>{};

    for (final InventoryItem item in items) {
      final String? productId = item.productId;
      if (productId == null) {
        continue;
      }

      frequencyByProduct[productId] = (frequencyByProduct[productId] ?? 0) + 1;
      final DateTime candidate = item.lastConfirmedAt ?? item.updatedAt;
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

  Map<String, String> _buildCustomNameIndex(List<InventoryItem> items) {
    final Map<String, String> byNormalized = <String, String>{};
    for (final InventoryItem item in items) {
      final String? raw = item.rawName?.trim();
      if (raw == null || raw.isEmpty) {
        continue;
      }
      final String normalized = _normalize(raw);
      if (normalized.isNotEmpty) {
        byNormalized[normalized] = raw;
      }
    }
    return byNormalized;
  }

  void _registerCustomName(String? rawName) {
    final String? trimmed = rawName?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return;
    }
    final String normalized = _normalize(trimmed);
    if (normalized.isEmpty) {
      return;
    }
    _customNamesByNormalized = <String, String>{
      ..._customNamesByNormalized,
      normalized: trimmed,
    };
  }

  void _refreshNameSuggestions() {
    final String query = state.nameInput.trim();
    final List<InventoryNameSuggestion> suggestions =
        <InventoryNameSuggestion>[];
    final Set<String> seen = <String>{};

    final List<String> customNames = _customNamesByNormalized.values.toList()
      ..sort();
    for (final String name in customNames) {
      final String normalized = _normalize(name);
      if (query.isNotEmpty && !normalized.contains(_normalize(query))) {
        continue;
      }
      if (seen.add(normalized)) {
        suggestions.add(
          InventoryNameSuggestion(label: name, productId: null),
        );
      }
      if (suggestions.length >= 6) {
        state = state.copyWith(nameSuggestions: suggestions);
        return;
      }
    }

    if (_products.isNotEmpty && query.isNotEmpty) {
      final List<ProductSuggestion> productSuggestions =
          _suggestionService.suggest(
        rawInput: query,
        availableProducts: _products,
        aliases: _aliases,
        usageStats: _usageStats,
        maxResults: 6,
      );

      for (final ProductSuggestion suggestion in productSuggestions) {
        final Product? product = suggestion.suggestedProduct;
        if (product == null) {
          continue;
        }
        final String normalized = _normalize(product.canonicalName);
        if (seen.add(normalized)) {
          suggestions.add(
            InventoryNameSuggestion(
              label: product.canonicalName,
              productId: product.id,
            ),
          );
        }
        if (suggestions.length >= 6) {
          break;
        }
      }
    }

    state = state.copyWith(nameSuggestions: suggestions);
  }

  String? _resolveExactMatchedProductId(String rawName) {
    final String query = rawName.trim();
    if (query.isEmpty || _products.isEmpty) {
      return null;
    }

    final List<ProductSuggestion> suggested = _suggestionService.suggest(
      rawInput: query,
      availableProducts: _products,
      aliases: _aliases,
      usageStats: _usageStats,
      maxResults: 1,
    );

    if (suggested.isEmpty) {
      return null;
    }

    final ProductSuggestion best = suggested.first;
    if (best.reasonCode != SuggestionReasonCode.exactMatch) {
      return null;
    }

    return best.suggestedProduct?.id;
  }

  String _normalize(String input) {
    final String lower = input.toLowerCase();
    return lower
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll(RegExp(r'[^a-z0-9\s\.]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<String> _resolveSuggestedCategoryId({
    required String rawName,
    String? productId,
  }) async {
    final String normalizedName = _normalize(rawName);
    if (productId != null &&
        _manualCategoryPreferenceByProductId[productId] != null) {
      return _manualCategoryPreferenceByProductId[productId]!;
    }
    if (normalizedName.isNotEmpty &&
        _manualCategoryPreferenceByName[normalizedName] != null) {
      return _manualCategoryPreferenceByName[normalizedName]!;
    }

    final String? candidateProductId =
        productId ?? _resolveExactMatchedProductId(rawName);
    if (candidateProductId != null) {
      Product? product;
      for (final Product value in _products) {
        if (value.id == candidateProductId) {
          product = value;
          break;
        }
      }
      if (product != null) {
        final String normalizedProductCategory =
            _normalize(product.category).toLowerCase();
        for (final InventoryCategory category in state.categories) {
          if (_normalize(category.name).toLowerCase() ==
              normalizedProductCategory) {
            return category.id;
          }
        }
      }
    }

    return _repository.ensureUncategorizedInventoryCategory(arg);
  }

  void _rememberCategoryChoice({
    required String categoryId,
    required String rawName,
    String? productId,
  }) {
    final String normalizedName = _normalize(rawName);
    if (normalizedName.isNotEmpty) {
      _manualCategoryPreferenceByName[normalizedName] = categoryId;
    }
    if (productId != null && productId.trim().isNotEmpty) {
      _manualCategoryPreferenceByProductId[productId] = categoryId;
    }
  }

  InventoryEvent _buildEvent({
    required InventoryItem item,
    required InventoryEventType eventType,
    required DateTime occurredAt,
    double? quantity,
    Unit? unit,
  }) {
    return InventoryEvent(
      id: _uuid.v4(),
      inventoryId: item.inventoryId,
      productId: item.productId,
      inventoryItemId: item.id,
      eventType: eventType,
      quantity: quantity,
      unit: unit,
      source: InventoryEventSource.manual,
      occurredAt: occurredAt,
      createdAt: occurredAt,
    );
  }

  Unit? _safeUnit(String? code) {
    if (code == null || code.trim().isEmpty) {
      return null;
    }
    try {
      return Unit.fromCode(code);
    } catch (_) {
      return null;
    }
  }
}
