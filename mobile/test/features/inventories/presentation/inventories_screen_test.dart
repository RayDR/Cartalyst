import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/inventories/presentation/inventories_screen.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows empty state only after inventories load successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          inventoriesControllerProvider.overrideWith(
            _LoadedEmptyInventoriesController.new,
          ),
        ],
        child: const MaterialApp(home: InventoriesScreen()),
      ),
    );

    expect(find.text('No inventories yet'), findsOneWidget);
    expect(find.text('Inventories could not load'), findsNothing);
  });

  testWidgets('shows error state instead of empty state when stream fails',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          inventoriesControllerProvider.overrideWith(
            _ErrorInventoriesController.new,
          ),
        ],
        child: const MaterialApp(home: InventoriesScreen()),
      ),
    );

    expect(find.text('Inventories could not load'), findsOneWidget);
    expect(find.text('Unable to load inventories.'), findsOneWidget);
    expect(find.text('No inventories yet'), findsNothing);
  });
}

class _LoadedEmptyInventoriesController extends InventoriesController {
  @override
  InventoriesState build() {
    return const InventoriesState(
      isBusy: false,
      hasLoadedInventories: true,
      inventories: <Inventory>[],
    );
  }
}

class _ErrorInventoriesController extends InventoriesController {
  @override
  InventoriesState build() {
    return const InventoriesState(
      isBusy: false,
      hasLoadedInventories: true,
      inventories: <Inventory>[],
      errorMessage: 'Unable to load inventories.',
    );
  }

  @override
  void retryLoadingInventories() {}
}
