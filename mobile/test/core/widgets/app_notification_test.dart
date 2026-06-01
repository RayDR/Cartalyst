import 'package:cartalyst_mobile/core/widgets/app_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title message action and progress bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppNotification(
              title: 'List created',
              message: 'Weekly groceries is ready.',
              actionLabel: 'Undo',
              onAction: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('List created'), findsOneWidget);
    expect(find.text('Weekly groceries is ready.'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('app-notification-progress')),
      findsOneWidget,
    );
  });

  testWidgets('runs action callback', (WidgetTester tester) async {
    bool didUndo = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppNotification(
              title: 'List deleted',
              message: 'Weekly groceries deleted.',
              actionLabel: 'Undo',
              onAction: () => didUndo = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Undo'));
    await tester.pump();

    expect(didUndo, isTrue);
  });

  testWidgets('dismisses horizontally', (WidgetTester tester) async {
    bool dismissed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppNotification(
              title: 'Item skipped',
              message: 'Marked "Milk" as skipped.',
              onDismissed: () => dismissed = true,
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(AppNotification), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(dismissed, isTrue);
  });
}
