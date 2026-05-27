import 'package:cartalyst_mobile/features/price_compare/data/mappers/price_observation_mapper.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/entities/price_observation.dart' as domain;
import 'package:cartalyst_mobile/features/price_compare/domain/repositories/price_observation_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';

class LocalPriceObservationRepository implements PriceObservationRepository {
  LocalPriceObservationRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<domain.PriceObservation>> watchLatestObservations() {
    return _database.priceObservationsDao.watchLatestObservations().map(
          (rows) => rows.map(toDomainPriceObservation).toList(growable: false),
        );
  }

  @override
  Future<void> addObservation(domain.PriceObservation observation) {
    return _database.priceObservationsDao.addObservation(
      toPriceObservationCompanion(observation),
    );
  }
}
