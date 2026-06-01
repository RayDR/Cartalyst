import 'dart:async';

import 'package:cartalyst_mobile/features/price_compare/application/price_compare_controller.dart';
import 'package:cartalyst_mobile/features/price_compare/application/price_compare_state.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/entities/price_observation.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/repositories/price_observation_repository.dart';
import 'package:cartalyst_mobile/features/price_compare/presentation/price_compare_screen.dart';
import 'package:cartalyst_mobile/core/widgets/app_button.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders non-blank screen with two default options', (
    WidgetTester tester,
  ) async {
    final _FakeProductRepository productRepository = _FakeProductRepository();
    final _FakePriceObservationRepository observationRepository =
        _FakePriceObservationRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          priceCompareProductRepositoryProvider
              .overrideWithValue(productRepository),
          priceObservationRepositoryProvider
              .overrideWithValue(observationRepository),
        ],
        child: const MaterialApp(home: PriceCompareScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Price Compare'), findsOneWidget);
    expect(find.text('Unit price insights'), findsOneWidget);
    expect(find.text('Compare'), findsOneWidget);
    expect(find.text('Option A'), findsOneWidget);
    expect(find.text('Option B'), findsOneWidget);

    await productRepository.dispose();
    await observationRepository.dispose();
  });

  testWidgets('reset restores the default two options', (
    WidgetTester tester,
  ) async {
    final _FakeProductRepository productRepository = _FakeProductRepository();
    final _FakePriceObservationRepository observationRepository =
        _FakePriceObservationRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          priceCompareProductRepositoryProvider
              .overrideWithValue(productRepository),
          priceObservationRepositoryProvider
              .overrideWithValue(observationRepository),
        ],
        child: const MaterialApp(home: PriceCompareScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Add option'));
    await tester.pumpAndSettle();
    final Finder resetButton = find.widgetWithText(AppButton, 'Reset');
    await tester.ensureVisible(resetButton);
    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    expect(find.text('Option A'), findsOneWidget);
    expect(find.text('Option B'), findsOneWidget);
    expect(find.text('Option C'), findsNothing);

    await productRepository.dispose();
    await observationRepository.dispose();
  });

  testWidgets('completed option renders compact card with unit price and edit',
      (
    WidgetTester tester,
  ) async {
    final _FakeProductRepository productRepository = _FakeProductRepository();
    final _FakePriceObservationRepository observationRepository =
        _FakePriceObservationRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          priceCompareProductRepositoryProvider
              .overrideWithValue(productRepository),
          priceObservationRepositoryProvider
              .overrideWithValue(observationRepository),
        ],
        child: const MaterialApp(home: PriceCompareScreen()),
      ),
    );

    await tester.pumpAndSettle();

    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(PriceCompareScreen)),
    );
    final PriceCompareController controller =
        container.read(priceCompareControllerProvider.notifier);
    final PriceCompareState stateBefore =
        container.read(priceCompareControllerProvider);
    final String firstId = stateBefore.options.first.id;

    controller.updateOptionPrice(firstId, '10');
    controller.updateOptionQuantity(firstId, '20');
    controller.updateOptionUnit(firstId, 'piece');
    controller.collapseOption(firstId);
    await tester.pumpAndSettle();

    expect(find.text('Price: \$10'), findsOneWidget);
    expect(find.text('Quantity: 20 piece'), findsOneWidget);
    expect(find.textContaining('Unit price:'), findsOneWidget);
    expect(find.byTooltip('Edit option'), findsWidgets);

    await productRepository.dispose();
    await observationRepository.dispose();
  });
}

class _FakeProductRepository implements ProductRepository {
  final StreamController<List<Product>> _productsController =
      StreamController<List<Product>>.broadcast();

  @override
  Stream<List<Product>> watchActiveProducts() {
    Future<void>.microtask(() => _productsController.add(const <Product>[]));
    return _productsController.stream;
  }

  @override
  Future<List<ProductAlias>> findAliasesForProduct(String productId) async {
    return const <ProductAlias>[];
  }

  @override
  Future<List<ProductAlias>> findAliasesForProducts(
    List<String> productIds,
  ) async {
    return const <ProductAlias>[];
  }

  @override
  Future<void> saveProduct(Product product) async {}

  @override
  Future<void> saveAlias(ProductAlias alias) async {}

  Future<void> dispose() async {
    await _productsController.close();
  }
}

class _FakePriceObservationRepository implements PriceObservationRepository {
  final StreamController<List<PriceObservation>> _observationsController =
      StreamController<List<PriceObservation>>.broadcast();

  @override
  Stream<List<PriceObservation>> watchLatestObservations() {
    Future<void>.microtask(
      () => _observationsController.add(const <PriceObservation>[]),
    );
    return _observationsController.stream;
  }

  @override
  Future<void> addObservation(PriceObservation observation) async {}

  Future<void> dispose() async {
    await _observationsController.close();
  }
}
