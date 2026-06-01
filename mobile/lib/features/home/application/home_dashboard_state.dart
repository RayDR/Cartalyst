import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';

class HomeDashboardState {
  const HomeDashboardState({
    required this.activeLists,
    required this.completedLists,
    required this.reminders,
    this.errorMessage,
  });

  const HomeDashboardState.initial()
      : activeLists = const <ShoppingList>[],
        completedLists = const <ShoppingList>[],
        reminders = const <String>[],
        errorMessage = null;

  /// Non-deleted lists with status == active, sorted by updatedAt desc.
  final List<ShoppingList> activeLists;

  /// Non-deleted lists with status == completed, sorted by updatedAt desc.
  final List<ShoppingList> completedLists;

  /// Top frequently purchased product names from purchase history.
  /// Empty when not enough data to show meaningful suggestions.
  final List<String> reminders;

  final String? errorMessage;

  bool get hasAnyLists => activeLists.isNotEmpty || completedLists.isNotEmpty;

  HomeDashboardState copyWith({
    List<ShoppingList>? activeLists,
    List<ShoppingList>? completedLists,
    List<String>? reminders,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HomeDashboardState(
      activeLists: activeLists ?? this.activeLists,
      completedLists: completedLists ?? this.completedLists,
      reminders: reminders ?? this.reminders,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
