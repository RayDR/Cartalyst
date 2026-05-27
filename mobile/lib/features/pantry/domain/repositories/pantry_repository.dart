import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';

abstract interface class PantryRepository {
  Stream<List<PantryItem>> watchPantryItems();

  Stream<List<InventoryEvent>> watchInventoryEvents();

  Future<void> savePantryItem(PantryItem item);

  Future<void> addInventoryEvent(InventoryEvent event);
}
