import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart'
    show inventoryRepositoryProvider;
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_state.dart';
import 'package:cartalyst_mobile/features/inventories/domain/repositories/inventory_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
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
  late final Uuid _uuid;

  StreamSubscription<List<InventoryItem>>? _itemsSubscription;
  StreamSubscription<List<Product>>? _productsSubscription;

  @override
  InventoryDetailState build(String arg) {
    _repository = ref.watch(inventoryRepositoryProvider);
    _productRepository = ref.watch(productRepositoryProvider);
    _uuid = ref.watch(uuidProvider);

    ref.onDispose(() {
      _itemsSubscription?.cancel();
      _productsSubscription?.cancel();
    });

    _itemsSubscription =
        _repository.watchInventoryItems(arg).listen(_onItemsChanged);

    _productsSubscription =
        _productRepository.watchActiveProducts().listen((List<Product> prods) {
      state = state.copyWith(products: prods);
    });

    return const InventoryDetailState.initial();
  }

  void updateNameInput(String value) {
    state = state.copyWith(nameInput: value, clearMessage: true);
  }

  void updateSelectedProduct(String? productId) {
    state = productId == null
        ? state.copyWith(clearSelectedProduct: true)
        : state.copyWith(selectedProductId: productId);
  }

  void updateQuantityInput(String value) {
    state = state.copyWith(quantityInput: value, clearMessage: true);
  }

  void updateUnitCode(String unitCode) {
    state = state.copyWith(unitCode: unitCode, clearMessage: true);
  }

  Future<void> addItem() async {
    final String trimmedName = state.nameInput.trim();
    final String? productId = state.selectedProductId;

    if (trimmedName.isEmpty && (productId == null || productId.isEmpty)) {
      state = state.copyWith(message: 'Provide a name or link a product.');
      return;
    }

    final double? quantity = double.tryParse(state.quantityInput.trim());
    final Unit? unit = _safeUnit(state.unitCode);
    final DateTime now = DateTime.now();

    final InventoryItem item = InventoryItem(
      id: _uuid.v4(),
      inventoryId: arg,
      productId: productId,
      rawName: trimmedName.isEmpty ? null : trimmedName,
      quantityEstimated: quantity,
      unit: unit,
      status: InventoryItemStatus.inStock,
      confidenceScore: productId == null ? 0.5 : 0.9,
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

    state = state.copyWith(
      nameInput: '',
      clearSelectedProduct: true,
      quantityInput: '',
      unitCode: 'unit',
      message: 'Item added.',
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

  Unit? _safeUnit(String code) {
    try {
      return Unit.fromCode(code);
    } catch (_) {
      return null;
    }
  }
}
