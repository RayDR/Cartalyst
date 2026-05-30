import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_button.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_controller.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeDashboardState state = ref.watch(homeDashboardControllerProvider);

    return AppScaffold(
      title: 'Cartalyst Home',
      child: ListView(
        children: <Widget>[
          Text(
            state.greeting,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            state.identity,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              StatusChip(label: 'Local-first', tone: StatusChipTone.success),
              StatusChip(label: 'Rule-based suggestions'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SectionHeader(
            title: 'Current shopping list summary',
            subtitle: state.activeShoppingList == null
                ? 'No active list yet.'
                : state.activeShoppingList!.name,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: state.activeShoppingList == null
                ? const AppListTile(
                    title: 'No active shopping list',
                    subtitle: 'Open Shopping to start and track your trip.',
                    leading: Icon(Icons.shopping_basket_outlined),
                  )
                : Column(
                    children: <Widget>[
                      AppListTile(
                        title: '${state.pendingCount} pending items',
                        subtitle: '${state.purchasedCount} purchased • ${state.skippedCount} skipped',
                        leading: const Icon(Icons.playlist_add_check_circle_outlined),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppButton(
                        label: 'Open shopping list',
                        onPressed: () => context.go('/shopping-list'),
                        icon: Icons.chevron_right,
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          const SectionHeader(
            title: 'Remember to buy',
            subtitle: 'Pending items from your current list.',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: state.rememberToBuyItems.isEmpty
                ? const AppListTile(
                    title: 'Nothing pending right now',
                    subtitle: 'Add items in Shopping to keep this section useful.',
                    leading: Icon(Icons.checklist_outlined),
                  )
                : Column(
                    children: state.rememberToBuyItems
                        .map(
                          (ShoppingListItem item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: AppListTile(
                              title: item.rawText,
                              subtitle: item.quantity == null
                                  ? 'Qty not set'
                                  : '${item.quantity} ${item.unit?.code ?? ''}'.trim(),
                              leading: const Icon(Icons.shopping_cart_outlined),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          const SectionHeader(
            title: 'Running low',
            subtitle: 'Items that need refill soon.',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: state.runningLowItems.isEmpty
                ? const AppListTile(
                    title: 'No low-stock items',
                    subtitle: 'Great job keeping inventory levels healthy.',
                    leading: Icon(Icons.thumb_up_alt_outlined),
                  )
                : Column(
                    children: state.runningLowItems
                        .map(
                          (PantryItem item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: AppListTile(
                              title: item.rawName ?? item.productId ?? 'Inventory item',
                              subtitle: item.quantityEstimated == null
                                  ? 'Low stock'
                                  : 'Estimated ${item.quantityEstimated} ${item.unit?.code ?? ''}'.trim(),
                              leading: const Icon(Icons.warning_amber_rounded),
                              trailing: const StatusChip(
                                label: 'Low',
                                tone: StatusChipTone.warning,
                              ),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          const SectionHeader(
            title: 'Quick price compare shortcut',
            subtitle: 'Open comparison with one tap.',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            onTap: () => context.go('/price-compare'),
            child: const AppListTile(
              title: 'Compare package value',
              subtitle: 'Check unit price between two options.',
              leading: Icon(Icons.balance_outlined),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const SectionHeader(
            title: 'Recently updated inventory items',
            subtitle: 'Latest inventory changes from your device.',
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: state.recentlyUpdatedPantryItems.isEmpty
                ? const AppListTile(
                    title: 'No inventory updates yet',
                    subtitle: 'Inventory changes will appear here as you update items.',
                    leading: Icon(Icons.history),
                  )
                : Column(
                    children: state.recentlyUpdatedPantryItems
                        .map(
                          (PantryItem item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: AppListTile(
                              title: item.rawName ?? item.productId ?? 'Inventory item',
                              subtitle: 'Updated ${_formatTimestamp(item.updatedAt)}',
                              leading: const Icon(Icons.inventory_2_outlined),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  static String _formatTimestamp(DateTime value) {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(value);
    if (diff.inMinutes < 1) {
      return 'just now';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    }
    return '${diff.inDays}d ago';
  }
}
