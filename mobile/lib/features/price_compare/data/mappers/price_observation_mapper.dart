import 'package:cartalyst_mobile/core/domain/value_objects/money.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/entities/price_observation.dart'
    as domain;
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart'
    as local_db;
import 'package:drift/drift.dart';

domain.PriceObservation toDomainPriceObservation(
  local_db.PriceObservation row,
) {
  return domain.PriceObservation(
    id: row.id,
    productId: row.productId,
    storeName: row.storeName,
    packageQuantity: row.packageQuantity,
    packageUnit: Unit.fromCode(row.packageUnit),
    price: Money.fromMajor(amount: row.price),
    unitPrice: Money.fromMajor(amount: row.unitPrice),
    observedAt: row.observedAt,
    createdAt: row.createdAt,
  );
}

local_db.PriceObservationsCompanion toPriceObservationCompanion(
  domain.PriceObservation entity,
) {
  return local_db.PriceObservationsCompanion(
    id: Value(entity.id),
    productId: Value(entity.productId),
    storeName: Value(entity.storeName),
    packageQuantity: Value(entity.packageQuantity),
    packageUnit: Value(entity.packageUnit.code),
    price: Value(entity.price.amountMajor),
    unitPrice: Value(entity.unitPrice.amountMajor),
    observedAt: Value(entity.observedAt),
    createdAt: Value(entity.createdAt),
  );
}
