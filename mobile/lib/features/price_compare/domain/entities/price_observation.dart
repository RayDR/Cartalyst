import 'package:cartalyst_mobile/core/domain/value_objects/money.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_observation.freezed.dart';
part 'price_observation.g.dart';

@freezed
class PriceObservation with _$PriceObservation {
  const factory PriceObservation({
    required String id,
    String? productId,
    String? storeName,
    required double packageQuantity,
    required Unit packageUnit,
    required Money price,
    required Money unitPrice,
    required DateTime observedAt,
    required DateTime createdAt,
  }) = _PriceObservation;

  factory PriceObservation.fromJson(Map<String, Object?> json) =>
      _$PriceObservationFromJson(json);
}
