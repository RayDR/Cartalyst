import 'dart:async';

import 'package:cartalyst_mobile/features/price_compare/application/price_compare_controller.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/entities/price_observation.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/repositories/price_observation_repository.dart';
import 'package:cartalyst_mobile/features/price_compare/presentation/price_compare_screen.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product_alias.dart';
import 'package:cartalyst_mobile/features/products/domain/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders compare title and default two options', (
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
    expect(find.text('Option A'), findsOneWidget);
    expect(find.text('Option B'), findsOneWidget);

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
