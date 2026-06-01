import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShoppingListItem transitions', () {
    final DateTime now = DateTime(2026, 1, 1, 10);

    ShoppingListItem buildItem(ShoppingListItemStatus status) {
      return ShoppingListItem(
        id: 'item-1',
        shoppingListId: 'list-1',
        rawText: 'milk',
        status: status,
        source: ShoppingListItemSource.manual,
        priorityScore: 0.3,
        createdAt: now,
        updatedAt: now,
        syncStatus: 'synced',
        version: 1,
      );
    }

    test('allows pending -> purchased', () {
      final ShoppingListItem item = buildItem(ShoppingListItemStatus.pending);
      final DateTime transitionTime = DateTime(2026, 1, 2, 9);

      final ShoppingListItem updated = item.transitionTo(
        ShoppingListItemStatus.purchased,
        transitionedAt: transitionTime,
      );

      expect(updated.status, ShoppingListItemStatus.purchased);
      expect(updated.purchasedAt, transitionTime);
      expect(updated.syncStatus, 'pending_sync');
      expect(updated.version, 2);
    });

    test('allows purchased -> pending', () {
      final ShoppingListItem item = buildItem(ShoppingListItemStatus.purchased);

      final ShoppingListItem updated =
          item.transitionTo(ShoppingListItemStatus.pending);

      expect(updated.status, ShoppingListItemStatus.pending);
      expect(updated.purchasedAt, isNull);
    });

    test('rejects skipped -> purchased', () {
      final ShoppingListItem item = buildItem(ShoppingListItemStatus.skipped);

      expect(
        () => item.transitionTo(ShoppingListItemStatus.purchased),
        throwsStateError,
      );
    });
  });
}
