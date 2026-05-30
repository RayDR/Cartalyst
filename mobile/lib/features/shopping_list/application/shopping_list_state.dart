import 'package:cartalyst_mobile/features/products/domain/services/product_suggestion_service.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';

class ShoppingListState {
  const ShoppingListState({
    required this.isBusy,
    required this.isEditMode,
    required this.hasDraft,
    required this.draftPromptPending,
    required this.draftName,
    required this.quickAddInput,
    required this.shoppingModeEnabled,
    required this.purchasedCollapsed,
    required this.pendingItems,
    required this.purchasedItems,
    required this.skippedItems,
    required this.suggestions,
    required this.focusedItemId,
    required this.errorMessage,
  });

  const ShoppingListState.initial()
      : isBusy = false,
        isEditMode = false,
        hasDraft = false,
        draftPromptPending = false,
        draftName = null,
        quickAddInput = '',
        shoppingModeEnabled = true,
        purchasedCollapsed = true,
        pendingItems = const <ShoppingListItem>[],
        purchasedItems = const <ShoppingListItem>[],
        skippedItems = const <ShoppingListItem>[],
        suggestions = const <ProductSuggestion>[],
        focusedItemId = null,
        errorMessage = null;

  final bool isBusy;
  final bool isEditMode;
  final bool hasDraft;
  final bool draftPromptPending;
  final String? draftName;
  final String quickAddInput;
  final bool shoppingModeEnabled;
  final bool purchasedCollapsed;
  final List<ShoppingListItem> pendingItems;
  final List<ShoppingListItem> purchasedItems;
  final List<ShoppingListItem> skippedItems;
  final List<ProductSuggestion> suggestions;
  final String? focusedItemId;
  final String? errorMessage;

  bool get hasItems =>
      pendingItems.isNotEmpty ||
      purchasedItems.isNotEmpty ||
      skippedItems.isNotEmpty;

  ShoppingListItem? get focusedItem {
    if (focusedItemId == null) {
      return null;
    }

    for (final ShoppingListItem item in pendingItems) {
      if (item.id == focusedItemId) {
        return item;
      }
    }
    for (final ShoppingListItem item in skippedItems) {
      if (item.id == focusedItemId) {
        return item;
      }
    }
    for (final ShoppingListItem item in purchasedItems) {
      if (item.id == focusedItemId) {
        return item;
      }
    }

    return null;
  }

  ShoppingListState copyWith({
    bool? isBusy,
    bool? isEditMode,
    bool? hasDraft,
    bool? draftPromptPending,
    String? draftName,
    String? quickAddInput,
    bool? shoppingModeEnabled,
    bool? purchasedCollapsed,
    List<ShoppingListItem>? pendingItems,
    List<ShoppingListItem>? purchasedItems,
    List<ShoppingListItem>? skippedItems,
    List<ProductSuggestion>? suggestions,
    String? focusedItemId,
    String? errorMessage,
    bool clearDraftName = false,
    bool clearErrorMessage = false,
    bool clearFocusedItem = false,
  }) {
    return ShoppingListState(
      isBusy: isBusy ?? this.isBusy,
      isEditMode: isEditMode ?? this.isEditMode,
      hasDraft: hasDraft ?? this.hasDraft,
      draftPromptPending: draftPromptPending ?? this.draftPromptPending,
      draftName: clearDraftName ? null : (draftName ?? this.draftName),
      quickAddInput: quickAddInput ?? this.quickAddInput,
      shoppingModeEnabled: shoppingModeEnabled ?? this.shoppingModeEnabled,
      purchasedCollapsed: purchasedCollapsed ?? this.purchasedCollapsed,
      pendingItems: pendingItems ?? this.pendingItems,
      purchasedItems: purchasedItems ?? this.purchasedItems,
      skippedItems: skippedItems ?? this.skippedItems,
      suggestions: suggestions ?? this.suggestions,
      focusedItemId:
          clearFocusedItem ? null : (focusedItemId ?? this.focusedItemId),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
