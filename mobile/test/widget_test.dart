import 'package:cartalyst_mobile/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the home shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CartalystApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cartalyst Home'), findsOneWidget);
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('Pantry'), findsOneWidget);
    expect(find.text('Compare'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
