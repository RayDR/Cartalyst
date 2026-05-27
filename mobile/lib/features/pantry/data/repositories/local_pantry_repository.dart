import 'package:cartalyst_mobile/features/pantry/data/mappers/pantry_mapper.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_event.dart' as domain;
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart' as domain;
import 'package:cartalyst_mobile/features/pantry/domain/repositories/pantry_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';

class LocalPantryRepository implements PantryRepository {
  LocalPantryRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<domain.PantryItem>> watchPantryItems() {
    return _database.pantryDao.watchPantryItems().map(
          (rows) => rows.map(toDomainPantryItem).toList(growable: false),
        );
  }

  @override
  Stream<List<domain.InventoryEvent>> watchInventoryEvents() {
    return _database.pantryDao.watchInventoryEvents().map(
          (rows) => rows.map(toDomainInventoryEvent).toList(growable: false),
        );
  }

  @override
  Future<void> savePantryItem(domain.PantryItem item) {
    return _database.pantryDao.upsertPantryItem(toPantryItemCompanion(item));
  }

  @override
  Future<void> addInventoryEvent(domain.InventoryEvent event) {
    return _database.pantryDao.addInventoryEvent(toInventoryEventCompanion(event));
  }
}
