import 'package:cartalyst_mobile/core/domain/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Money', () {
    test('creates from major amount with 2-decimal rounding', () {
      final Money money = Money.fromMajor(amount: 12.345);

      expect(money.amountMinor, 1235);
      expect(money.amountMajor, 12.35);
      expect(money.currencyCode, 'USD');
    });

    test('adds and subtracts same currency values', () {
      const Money first = Money(amountMinor: 500);
      const Money second = Money(amountMinor: 250);

      final Money total = first.plus(second);
      final Money diff = total.minus(second);

      expect(total.amountMinor, 750);
      expect(diff.amountMinor, 500);
    });

    test('throws when currencies differ', () {
      const Money usd = Money(amountMinor: 500);
      const Money eur = Money(amountMinor: 100, currencyCode: 'EUR');

      expect(() => usd.plus(eur), throwsStateError);
    });
  });
}
