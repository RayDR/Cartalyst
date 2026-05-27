import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

@freezed
class Unit with _$Unit {
  const Unit._();

  const factory Unit({required String code}) = _Unit;

  factory Unit.fromJson(Map<String, Object?> json) => _$UnitFromJson(json);

  static const Set<String> supportedCodes = <String>{
    'unit',
    'kg',
    'g',
    'gal',
    'liter',
    'ml',
    'pack',
  };

  static Unit fromCode(String code) {
    final String normalized = code.trim().toLowerCase();
    if (!supportedCodes.contains(normalized)) {
      throw ArgumentError.value(code, 'code', 'Unsupported unit code.');
    }
    return Unit(code: normalized);
  }
}
