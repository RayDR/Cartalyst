import 'package:cartalyst_mobile/features/price_compare/domain/entities/price_observation.dart';

abstract interface class PriceObservationRepository {
  Stream<List<PriceObservation>> watchLatestObservations();

  Future<void> addObservation(PriceObservation observation);
}
