import 'dart:async';

import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/pantry/application/pantry_state.dart';
import 'package:cartalyst_mobile/features/pantry/data/repositories/local_pantry_repository.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';
import 'package:cartalyst_mobile/features/pantry/domain/repositories/pantry_repository.dart';
import 'package:cartalyst_mobile/features/products/data/repositories/local_product_repository.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart' show AppDatabase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final pantryDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final pantryRepositoryProvider = Provider<PantryRepository>((Ref ref) {
  return LocalPantryRepository(ref.watch(pantryDatabaseProvider));
});

final pantryProductRepositoryProvider = Provider<ProductRepository>((Ref ref) {
  return LocalProductRepository(ref.watch(pantryDatabaseProvider));
});

final pantryUuidProvider = Provider<Uuid>((Ref ref) {
  return const Uuid();
});

final pantryItemsStreamProvider = StreamProvider<List<PantryItem>>((Ref ref) {
  return ref.watch(pantryRepositoryProvider).watchPantryItems();
});

final runningLowPantryItemsProvider = Provider<List<PantryItem>>((Ref ref) {
  final AsyncValue<List<PantryItem>> itemsAsync = ref.watch(pantryItemsStreamProvider);
  return itemsAsync.maybeWhen(
    data: (List<PantryItem> items) => items
        .where((PantryItem item) => item.status == PantryItemStatus.low)
        .toList(growable: false),
    orElse: () => const <PantryItem>[],
  );
});

final pantryControllerProvider = NotifierProvider<PantryController, PantryState>(PantryController.new);

class PantryController extends Notifier<PantryState> {
  late final PantryRepository _pantryRepository;
  late final ProductRepository _productRepository;
  late final Uuid _uuid;

  StreamSubscription<List<PantryItem>>? _itemsSubscription;
  StreamSubscription<List<Product>>? _productsSubscription;

  @override
  PantryState build() {
    _pantryRepository = ref.watch(pantryRepositoryProvider);
    _productRepository = ref.watch(pantryProductRepositoryProvider);
    _uuid = ref.watch(pantryUuidProvider);

    ref.onDispose(() {
      _itemsSubscription?.cancel();
      _productsSubscription?.cancel();
    });

    _itemsSubscription = _pantryRepository.watchPantryItems().listen(_onItemsChanged);
    _productsSubscription = _productRepository.watchActiveProducts().listen((List<Product> products) {
      state = state.copyWith(products: products);
    });

    return const PantryState.initial();
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

  Future<void> addPantryItem() async {
    final String trimmedName = state.nameInput.trim();
    final String? productId = state.selectedProductId;

    if (trimmedName.isEmpty && (productId == null || productId.isEmpty)) {
      state = state.copyWith(message: 'Provide a name or link a product.');
      return;
    }

    final double? quantity = double.tryParse(state.quantityInput.trim());
    final Unit? unit = _safeUnit(state.unitCode);

    final DateTime now = DateTime.now();
    final PantryItem item = PantryItem(
      id: _uuid.v4(),
      productId: productId,
      rawName: trimmedName.isEmpty ? null : trimmedName,
      quantityEstimated: quantity,
      unit: unit,
      status: PantryItemStatus.inStock,
      confidenceScore: productId == null ? 0.5 : 0.9,
      lastConfirmedAt: now,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending_sync',
      version: 1,
    );

    final InventoryEvent event = _buildEvent(
      pantryItem: item,
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
      message: 'Pantry item added.',
    );
  }

  Future<void> markInStock(PantryItem item) async {
    final DateTime now = DateTime.now();
    final PantryItem updated = item.copyWith(
      status: PantryItemStatus.inStock,
      lastConfirmedAt: now,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );

    final InventoryEvent event = _buildEvent(
      pantryItem: updated,
      eventType: InventoryEventType.purchase,
      quantity: updated.quantityEstimated,
      unit: updated.unit,
      occurredAt: now,
    );

    await _saveItemAndEvent(item: updated, event: event);
  }

  Future<void> markRunningLow(PantryItem item) async {
    final DateTime now = DateTime.now();
    final PantryItem updated = item.copyWith(
      status: PantryItemStatus.low,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );

    final InventoryEvent event = _buildEvent(
      pantryItem: updated,
      eventType: InventoryEventType.consume,
      quantity: updated.quantityEstimated,
      unit: updated.unit,
      occurredAt: now,
    );

    await _saveItemAndEvent(item: updated, event: event);
  }

  Future<void> markFinished(PantryItem item) async {
    final DateTime now = DateTime.now();
    final PantryItem updated = item.copyWith(
      status: PantryItemStatus.out,
      quantityEstimated: 0,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );

    final InventoryEvent event = _buildEvent(
      pantryItem: updated,
      eventType: InventoryEventType.finish,
      quantity: 0,
      unit: updated.unit,
      occurredAt: now,
    );

    await _saveItemAndEvent(item: updated, event: event);
  }

  Future<void> adjustItem({
    required PantryItem item,
    required double? quantity,
    required String unitCode,
  }) async {
    final DateTime now = DateTime.now();
    final Unit? unit = _safeUnit(unitCode);
    final PantryItem updated = item.copyWith(
      quantityEstimated: quantity,
      unit: unit,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );

    final InventoryEvent event = _buildEvent(
      pantryItem: updated,
      eventType: InventoryEventType.adjust,
      quantity: quantity,
      unit: unit,
      occurredAt: now,
    );

    await _saveItemAndEvent(item: updated, event: event);
  }

  Future<void> softDelete(PantryItem item) async {
    final DateTime now = DateTime.now();
    final PantryItem updated = item.copyWith(
      deletedAt: now,
      updatedAt: now,
      version: item.version + 1,
      syncStatus: 'pending_sync',
    );

    final InventoryEvent event = _buildEvent(
      pantryItem: updated,
      eventType: InventoryEventType.discard,
      quantity: updated.quantityEstimated,
      unit: updated.unit,
      occurredAt: now,
    );

    await _saveItemAndEvent(item: updated, event: event);
  }

  Future<void> _saveItemAndEvent({
    required PantryItem item,
    required InventoryEvent event,
  }) async {
    try {
      state = state.copyWith(isBusy: true, clearMessage: true);
      await _pantryRepository.savePantryItem(item);
      await _pantryRepository.addInventoryEvent(event);
      state = state.copyWith(isBusy: false);
    } catch (_) {
      state = state.copyWith(
        isBusy: false,
        message: 'Unable to save pantry update.',
      );
    }
  }

  void _onItemsChanged(List<PantryItem> items) {
    final DateTime recentThreshold = DateTime.now().subtract(const Duration(days: 7));

    final List<PantryItem> inStock = items
        .where((PantryItem item) => item.status == PantryItemStatus.inStock)
        .toList(growable: false);

    final List<PantryItem> low = items
        .where((PantryItem item) => item.status == PantryItemStatus.low)
        .toList(growable: false);

    final List<PantryItem> finished = items
        .where(
          (PantryItem item) =>
              item.status == PantryItemStatus.out && item.updatedAt.isAfter(recentThreshold),
        )
        .toList(growable: false);

    state = state.copyWith(
      inStockItems: inStock,
      lowItems: low,
      finishedItems: finished,
    );
  }

  InventoryEvent _buildEvent({
    required PantryItem pantryItem,
    required InventoryEventType eventType,
    required DateTime occurredAt,
    double? quantity,
    Unit? unit,
  }) {
    return InventoryEvent(
      id: _uuid.v4(),
      productId: pantryItem.productId,
      pantryItemId: pantryItem.id,
      eventType: eventType,
      quantity: quantity,
      unit: unit,
      source: InventoryEventSource.manual,
      occurredAt: occurredAt,
      createdAt: occurredAt,
    );
  }

  Unit? _safeUnit(String unitCode) {
    final String normalized = unitCode.trim().toLowerCase();
    if (!Unit.supportedCodes.contains(normalized)) {
      return null;
    }
    return Unit.fromCode(normalized);
  }
}
