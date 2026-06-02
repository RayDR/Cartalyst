import 'package:cartalyst_mobile/core/debug/debug_diagnostics.dart';
import 'package:cartalyst_mobile/core/debug/debug_diagnostics_provider.dart';
import 'package:cartalyst_mobile/features/settings/presentation/debug_diagnostics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders empty diagnostics state', (WidgetTester tester) async {
    final DebugDiagnosticsStore store = DebugDiagnosticsStore();

    await tester.pumpWidget(_buildSubject(store, withBottomNavigation: true));

    expect(find.text('Debug Diagnostics'), findsOneWidget);
    expect(find.text('Entries: 0'), findsOneWidget);
    expect(find.text('No diagnostics yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders many diagnostics entries without layout exceptions', (
    WidgetTester tester,
  ) async {
    final DebugDiagnosticsStore store = DebugDiagnosticsStore();
    for (int i = 0; i < 55; i++) {
      store.addLog(
        message: 'Diagnostic entry $i',
        source: 'test-suite',
      );
    }

    await tester.pumpWidget(_buildSubject(store));
    await tester.pumpAndSettle();

    expect(find.text('Entries: 55'), findsOneWidget);
    expect(find.text('Diagnostic entry 54'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Diagnostic entry 0'),
      500,
      scrollable: find.byType(CustomScrollView),
    );

    expect(find.text('Diagnostic entry 0'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders long expanded stack trace safely', (
    WidgetTester tester,
  ) async {
    final DebugDiagnosticsStore store = DebugDiagnosticsStore();
    store.addError(
      error: Exception('Layout assertion sample'),
      stackTrace: StackTrace.fromString(
        List<String>.generate(
          80,
          (int index) {
            final String tail = ''.padRight(80, 'x');
            return '#$index package:cartalyst_mobile/debug/'
                'very_long_stack_trace_line.dart 10:20 $tail';
          },
        ).join('\n'),
      ),
      source: 'test-suite',
    );

    await tester.pumpWidget(_buildSubject(store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show stack trace'));
    await tester.pumpAndSettle();

    expect(find.text('Hide stack trace'), findsOneWidget);
    expect(find.byType(SelectableText), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

Widget _buildSubject(
  DebugDiagnosticsStore store, {
  bool withBottomNavigation = false,
}) {
  final Widget screen = withBottomNavigation
      ? Scaffold(
          body: const DebugDiagnosticsScreen(),
          bottomNavigationBar: NavigationBar(
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.bug_report_outlined),
                label: 'Debug',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        )
      : const DebugDiagnosticsScreen();

  return ProviderScope(
    overrides: <Override>[
      debugDiagnosticsStoreProvider.overrideWith((Ref ref) => store),
    ],
    child: MaterialApp(home: screen),
  );
}
