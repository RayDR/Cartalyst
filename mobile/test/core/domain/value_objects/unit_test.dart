import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit', () {
    test('creates normalized supported unit', () {
      final Unit unit = Unit.fromCode(' KG ');

      expect(unit.code, 'kg');
    });

    test('throws for unsupported unit', () {
      expect(() => Unit.fromCode('box'), throwsArgumentError);
    });
  });
}
