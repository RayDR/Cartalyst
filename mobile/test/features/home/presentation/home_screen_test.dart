import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_controller.dart';
import 'package:cartalyst_mobile/features/home/presentation/home_screen.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ShoppingList _makeList({
  required String id,
  required String name,
  ShoppingListStatus status = ShoppingListStatus.active,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final DateTime now = DateTime(2026, 1, 10, 12);
  return ShoppingList(
    id: id,
    name: name,
    status: status,
    createdAt: createdAt ?? now.subtract(const Duration(days: 2)),
    updatedAt: updatedAt ?? now.subtract(const Duration(days: 1)),
    syncStatus: 'local_only',
    version: 1,
  );
}

void main() {
  Widget buildApp(HomeDashboardState state) {
    return ProviderScope(
      overrides: <Override>[
        homeDashboardControllerProvider.overrideWith(
          () => _TestHomeDashboardController(state),
        ),
        listsControllerProvider.overrideWith(_TestListsController.new),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  group('HomeScreen', () {
    testWidgets(
      'shows empty state with create action when no lists',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildApp(const HomeDashboardState.initial()));
        await tester.pumpAndSettle();

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('No shopping lists yet'), findsOneWidget);
        expect(find.text('Create list'), findsOneWidget);
      },
    );

    testWidgets(
      'shows active lists and reminders section when lists exist',
      (WidgetTester tester) async {
        final HomeDashboardState state = HomeDashboardState(
          activeLists: <ShoppingList>[
            _makeList(id: 'list-1', name: 'Weekly groceries'),
            _makeList(id: 'list-2', name: 'Party snacks'),
          ],
          completedLists: const <ShoppingList>[],
          reminders: const <String>[],
        );

        await tester.pumpWidget(buildApp(state));
        await tester.pumpAndSettle();

        expect(find.text('Weekly groceries'), findsOneWidget);
        expect(find.text('Party snacks'), findsOneWidget);
        expect(find.text('Shopping reminders'), findsOneWidget);
        expect(find.text('Shopping lists'), findsOneWidget);
      },
    );

    testWidgets(
      'shows hint text when reminders are empty',
      (WidgetTester tester) async {
        final HomeDashboardState state = HomeDashboardState(
          activeLists: <ShoppingList>[
            _makeList(id: 'list-1', name: 'Groceries'),
          ],
          completedLists: const <ShoppingList>[],
          reminders: const <String>[],
        );

        await tester.pumpWidget(buildApp(state));
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Cartalyst will learn your frequent products as you shop.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows reminder chips when purchase history exists',
      (WidgetTester tester) async {
        final HomeDashboardState state = HomeDashboardState(
          activeLists: <ShoppingList>[
            _makeList(id: 'list-1', name: 'Groceries'),
          ],
          completedLists: const <ShoppingList>[],
          reminders: const <String>['Milk', 'Bread', 'Eggs'],
        );

        await tester.pumpWidget(buildApp(state));
        await tester.pumpAndSettle();

        expect(find.text('Milk'), findsOneWidget);
        expect(find.text('Bread'), findsOneWidget);
        expect(find.text('Eggs'), findsOneWidget);
      },
    );

    testWidgets(
      'completed lists are hidden from active section',
      (WidgetTester tester) async {
        final HomeDashboardState state = HomeDashboardState(
          activeLists: <ShoppingList>[
            _makeList(id: 'list-1', name: 'Active list'),
          ],
          completedLists: <ShoppingList>[
            _makeList(
              id: 'list-2',
              name: 'Done list',
              status: ShoppingListStatus.completed,
            ),
          ],
          reminders: const <String>[],
        );

        await tester.pumpWidget(buildApp(state));
        await tester.pumpAndSettle();

        expect(find.text('Active list'), findsOneWidget);
        // Completed section is collapsed by default
        expect(find.text('Done list'), findsNothing);
        // But the Completed section header is visible
        expect(find.text('Completed'), findsOneWidget);
      },
    );

    testWidgets(
      'shows completed lists with Restart when section is expanded',
      (WidgetTester tester) async {
        final HomeDashboardState state = HomeDashboardState(
          activeLists: const <ShoppingList>[],
          completedLists: <ShoppingList>[
            _makeList(
              id: 'list-1',
              name: 'Done shopping',
              status: ShoppingListStatus.completed,
            ),
          ],
          reminders: const <String>[],
        );

        await tester.pumpWidget(buildApp(state));
        await tester.pumpAndSettle();

        expect(find.text('Done shopping'), findsNothing);

        // Expand completed section
        await tester.tap(find.widgetWithText(TextButton, 'Show'));
        await tester.pumpAndSettle();

        expect(find.text('Done shopping'), findsOneWidget);
        expect(find.text('Restart'), findsOneWidget);
      },
    );

    testWidgets(
      'shows New badge for recently created lists',
      (WidgetTester tester) async {
        final DateTime now = DateTime.now();
        final HomeDashboardState state = HomeDashboardState(
          activeLists: <ShoppingList>[
            _makeList(
              id: 'list-new',
              name: 'Brand new list',
              createdAt: now.subtract(const Duration(hours: 2)),
              updatedAt: now.subtract(const Duration(hours: 2)),
            ),
            _makeList(
              id: 'list-old',
              name: 'Old list',
              createdAt: now.subtract(const Duration(days: 3)),
              updatedAt: now.subtract(const Duration(days: 3)),
            ),
          ],
          completedLists: const <ShoppingList>[],
          reminders: const <String>[],
        );

        await tester.pumpWidget(buildApp(state));
        await tester.pumpAndSettle();

        expect(find.text('New'), findsOneWidget);
        expect(find.text('Brand new list'), findsOneWidget);
        expect(find.text('Old list'), findsOneWidget);
      },
    );

    testWidgets(
      'opens create list bottom sheet',
      (WidgetTester tester) async {
        final HomeDashboardState state = HomeDashboardState(
          activeLists: <ShoppingList>[
            _makeList(id: 'list-1', name: 'Existing list'),
          ],
          completedLists: const <ShoppingList>[],
          reminders: const <String>[],
        );

        await tester.pumpWidget(buildApp(state));
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'New list'));
        await tester.pumpAndSettle();

        expect(find.text('New shopping list'), findsOneWidget);
        expect(find.text('Create list'), findsOneWidget);
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

