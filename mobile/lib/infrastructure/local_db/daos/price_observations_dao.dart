part of '../app_database.dart';

@DriftAccessor(tables: <Type>[PriceObservations])
class PriceObservationsDao extends DatabaseAccessor<AppDatabase>
    with _$PriceObservationsDaoMixin {
  PriceObservationsDao(super.db);

  Future<void> addObservation(PriceObservationsCompanion observation) {
    return into(priceObservations).insert(observation);
  }

  Stream<List<PriceObservation>> watchLatestObservations() {
    final query = select(priceObservations)
      ..orderBy(<OrderingTerm Function($PriceObservationsTable)>[
        (tbl) => OrderingTerm.desc(tbl.observedAt),
      ]);
    return query.watch();
  }
}
