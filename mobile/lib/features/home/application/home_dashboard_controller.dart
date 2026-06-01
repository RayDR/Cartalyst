import 'dart:async';

import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart'
    show appDatabaseProvider, shoppingListRepositoryProvider;
import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/repositories/shopping_list_repository.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart'
  hide ShoppingList, ShoppingListStatus;
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeDashboardControllerProvider =
    NotifierProvider<HomeDashboardController, HomeDashboardState>(
      HomeDashboardController.new,
    );

class HomeDashboardController extends Notifier<HomeDashboardState> {
  late final ShoppingListRepository _repository;
  late final AppDatabase _database;

  StreamSubscription<List<ShoppingList>>? _listsSubscription;

  @override
  HomeDashboardState build() {
    _repository = ref.watch(shoppingListRepositoryProvider);
    _database = ref.watch(appDatabaseProvider);

    ref.onDispose(() {
      _listsSubscription?.cancel();
    });

    _subscribeLists();
    _loadReminders();

    return const HomeDashboardState.initial();
  }

  void _subscribeLists() {
    _listsSubscription?.cancel();
    _listsSubscription = _repository.watchAllLists().listen(
      (List<ShoppingList> allLists) {
        final List<ShoppingList> activeLists = allLists
            .where(
              (ShoppingList list) =>
                  list.status == ShoppingListStatus.active,
            )
            .toList(growable: false);
        final List<ShoppingList> completedLists = allLists
            .where(
              (ShoppingList list) =>
                  list.status == ShoppingListStatus.completed,
            )
            .toList(growable: false);
        state = state.copyWith(
          activeLists: activeLists,
          completedLists: completedLists,
        );
      },
      onError: (_, __) {},
      cancelOnError: false,
    );
  }

  Future<void> _loadReminders() async {
    try {
      final List<QueryRow> rows = await _database.customSelect(
        '''
        SELECT raw_text, COUNT(*) AS freq
        FROM shopping_list_items
        WHERE status = 'purchased'
          AND deleted_at IS NULL
        GROUP BY LOWER(raw_text)
        ORDER BY freq DESC
        LIMIT 5
        ''',
      ).get();
      final List<String> names = rows
          .map((QueryRow row) => row.read<String>('raw_text'))
          .toList(growable: false);
      state = state.copyWith(reminders: names);
    } catch (_) {
      // Non-fatal: keep empty reminders
    }
  }
}
