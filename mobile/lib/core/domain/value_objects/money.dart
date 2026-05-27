import 'package:freezed_annotation/freezed_annotation.dart';

part 'money.freezed.dart';
part 'money.g.dart';

@freezed
class Money with _$Money {
  const Money._();

  const factory Money({
    required int amountMinor,
    @Default('USD') String currencyCode,
  }) = _Money;

  factory Money.fromJson(Map<String, Object?> json) => _$MoneyFromJson(json);

  factory Money.fromMajor({
    required double amount,
    String currencyCode = 'USD',
  }) {
    return Money(
      amountMinor: (amount * 100).round(),
      currencyCode: currencyCode,
    );
  }

  double get amountMajor => amountMinor / 100.0;

  Money plus(Money other) {
    _assertSameCurrency(other);
    return copyWith(amountMinor: amountMinor + other.amountMinor);
  }

  Money minus(Money other) {
    _assertSameCurrency(other);
    return copyWith(amountMinor: amountMinor - other.amountMinor);
  }

  void _assertSameCurrency(Money other) {
    if (currencyCode != other.currencyCode) {
      throw StateError('Money operations require the same currency.');
    }
  }
}
