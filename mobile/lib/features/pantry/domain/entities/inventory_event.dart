import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_event.freezed.dart';
part 'inventory_event.g.dart';

enum InventoryEventType {
  add,
  consume,
  adjust,
  confirm,
  discard,
}

enum InventoryEventSource {
  manual,
  receipt,
  system,
}

@freezed
class InventoryEvent with _$InventoryEvent {
  const factory InventoryEvent({
    required String id,
    String? productId,
    String? pantryItemId,
    required InventoryEventType eventType,
    double? quantity,
    Unit? unit,
    required InventoryEventSource source,
    required DateTime occurredAt,
    required DateTime createdAt,
  }) = _InventoryEvent;

  factory InventoryEvent.fromJson(Map<String, Object?> json) =>
      _$InventoryEventFromJson(json);
}
