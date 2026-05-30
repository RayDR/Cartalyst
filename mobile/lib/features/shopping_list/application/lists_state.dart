import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';

class ListsState {
  const ListsState({
    required this.isBusy,
    required this.lists,
    required this.lastDeletedList,
    required this.errorMessage,
  });

  const ListsState.initial()
      : isBusy = false,
        lists = const <ShoppingList>[],
        lastDeletedList = null,
        errorMessage = null;

  final bool isBusy;
  final List<ShoppingList> lists;

  /// The most recently soft-deleted list, available for undo.
  final ShoppingList? lastDeletedList;
  final String? errorMessage;

  bool get isEmpty => lists.isEmpty;

  List<ShoppingList> get recentLists =>
      lists.length > 5 ? lists.sublist(0, 5) : List<ShoppingList>.unmodifiable(lists);

  ListsState copyWith({
    bool? isBusy,
    List<ShoppingList>? lists,
    ShoppingList? lastDeletedList,
    String? errorMessage,
    bool clearLastDeleted = false,
    bool clearErrorMessage = false,
  }) {
    return ListsState(
      isBusy: isBusy ?? this.isBusy,
      lists: lists ?? this.lists,
      lastDeletedList: clearLastDeleted ? null : (lastDeletedList ?? this.lastDeletedList),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
