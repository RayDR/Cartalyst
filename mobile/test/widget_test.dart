import 'package:cartalyst_mobile/app/app.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the home shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          homeDashboardControllerProvider.overrideWith(
            _TestHomeDashboardController.new,
          ),
          listsControllerProvider.overrideWith(_TestListsController.new),
          inventoriesControllerProvider.overrideWith(
            _TestInventoriesController.new,
          ),
        ],
        child: const CartalystApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.widgetWithText(Tab, 'Lists'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Inventories'), findsOneWidget);
    expect(find.text('Compare'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}

class _TestHomeDashboardController extends HomeDashboardController {
  @override
  HomeDashboardState build() {
    return const HomeDashboardState.initial();
  }
}

class _TestListsController extends ListsController {
  @override
  ListsState build() => const ListsState.initial();
}

class _TestInventoriesController extends InventoriesController {
  @override
  InventoriesState build() => const InventoriesState.initial();
}
