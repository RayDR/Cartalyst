import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_controller.dart';
import 'package:cartalyst_mobile/features/home/presentation/home_screen.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart'
    as local_db;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(HomeDashboardState state) {
    return ProviderScope(
      overrides: <Override>[
        homeDashboardControllerProvider.overrideWith(
          () => _TestHomeDashboardController(state),
        ),
        listsControllerProvider.overrideWith(_TestListsController.new),
        inventoriesControllerProvider.overrideWith(
          _TestInventoriesController.new,
        ),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  group('HomeScreen', () {
    testWidgets(
      'shows dashboard tabs and empty states when there is no data',
      (WidgetTester tester) async {
      await tester.pumpWidget(
        buildApp(const HomeDashboardState.initial()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Lists'), findsOneWidget);
      expect(find.text('Inventories'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('No lists yet'), findsOneWidget);
    },
    );

    testWidgets(
      'shows lists inventories and categories with create actions',
      (WidgetTester tester) async {
      final DateTime now = DateTime(2026, 1, 3, 10);
      final HomeDashboardState state = HomeDashboardState(
        greeting: 'Hello',
        identity: 'Your smart shopping analyst',
        lists: <local_db.ShoppingList>[
          local_db.ShoppingList(
            id: 'list-1',
            name: 'Weekend groceries',
            listType: 'simple',
            routingMode: 'none',
            status: 'active',
            createdAt: now.subtract(const Duration(days: 2)),
            updatedAt: now.subtract(const Duration(days: 2)),
            syncStatus: 'local_only',
            version: 1,
          ),
          local_db.ShoppingList(
            id: 'list-2',
            name: 'Party snacks',
            listType: 'simple',
            routingMode: 'none',
            status: 'active',
            createdAt: now.subtract(const Duration(days: 1)),
            updatedAt: now.subtract(const Duration(days: 1)),
            syncStatus: 'local_only',
            version: 1,
          ),
        ],
        inventories: <local_db.Inventory>[
          local_db.Inventory(
            id: 'inventory-1',
            name: 'Pantry',
            description: null,
            createdAt: now,
            updatedAt: now,
            syncStatus: 'local_only',
            version: 1,
          ),
        ],
        categories: <local_db.Category>[
          local_db.Category(
            id: 'cat-1',
            name: 'Fruits',
            color: null,
            icon: null,
            createdAt: now,
            updatedAt: now,
            syncStatus: 'local_only',
            version: 1,
          ),
          local_db.Category(
            id: 'cat-uncategorized',
            name: 'Uncategorized',
            color: null,
            icon: null,
            createdAt: now,
            updatedAt: now,
            syncStatus: 'local_only',
            version: 1,
          ),
        ],
      );

      await tester.pumpWidget(buildApp(state));
      await tester.pumpAndSettle();

      expect(find.text('Recent lists'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Create list'), findsWidgets);
      expect(find.text('Party snacks'), findsOneWidget);
      expect(find.text('Weekend groceries'), findsOneWidget);

      await tester.tap(find.text('Inventories'));
      await tester.pumpAndSettle();
      expect(find.text('Pantry'), findsOneWidget);
      expect(find.text('Create inventory'), findsOneWidget);

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();
      expect(find.text('Uncategorized'), findsOneWidget);
      expect(find.text('Fruits'), findsOneWidget);
    },
    );

    testWidgets(
      'opens create list sheet from home',
      (WidgetTester tester) async {
      await tester.pumpWidget(
        buildApp(const HomeDashboardState.initial()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create list'));
      await tester.pumpAndSettle();

      expect(find.text('New shopping list'), findsOneWidget);
      expect(find.text('Create list'), findsWidgets);
    },
    );
  });
}

class _TestHomeDashboardController extends HomeDashboardController {
  _TestHomeDashboardController(this._state);

  final HomeDashboardState _state;

  @override
  HomeDashboardState build() => _state;
}

class _TestListsController extends ListsController {
  @override
  ListsState build() => const ListsState.initial();
}

class _TestInventoriesController extends InventoriesController {
  @override
  InventoriesState build() => const InventoriesState.initial();
}
