import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('AppDatabase', () {
    AppDatabase? database;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
    });

    tearDown(() async {
      await database?.close();
    });

    test('seeds common products and aliases on first create', () async {
      try {
        final List<Product> products = await database!.select(database!.products).get();
        final aliases = await database!.select(database!.productAliases).get();

        expect(products.length, 15);
        expect(aliases.length, greaterThanOrEqualTo(30));
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });

    test('development reset clears user tables and reseeds products', () async {
      try {
        final String listId = const Uuid().v4();

        await database!.into(database!.shoppingLists).insert(
              ShoppingListsCompanion.insert(
                id: listId,
                name: 'Weekly list',
              ),
            );

        await database!.developmentReset();

        final List<ShoppingList> lists =
            await database!.select(database!.shoppingLists).get();
        final List<Product> products =
            await database!.select(database!.products).get();

        expect(lists, isEmpty);
        expect(products.length, 15);
      } on ArgumentError catch (error) {
        if (_isMissingSqlite(error)) {
          return;
        }
        rethrow;
      }
    });
  });
}

bool _isMissingSqlite(ArgumentError error) {
  return error.toString().contains('libsqlite3.so');
}
