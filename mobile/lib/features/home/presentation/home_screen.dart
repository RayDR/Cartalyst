import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:cartalyst_mobile/features/pantry/application/pantry_controller.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<PantryItem> lowItems = ref.watch(runningLowPantryItemsProvider);

    return AppScaffold(
      title: 'Cartalyst Home',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeader(
            title: 'Shopping overview',
            subtitle: 'Fast list actions, smart suggestions, and pantry snapshots.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              StatusChip(label: 'Local-first', tone: StatusChipTone.success),
              StatusChip(label: 'V1 scope'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: AppListTile(
              title: 'Start today\'s list',
              subtitle: 'Build a new grocery list in a few taps.',
              leading: Icon(Icons.playlist_add_check_circle_outlined),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (lowItems.isNotEmpty) ...<Widget>[
            const SectionHeader(
              title: 'Running low',
              subtitle: 'Remember to buy these items soon.',
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                children: lowItems
                    .map(
                      (PantryItem item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: AppListTile(
                          title: item.rawName ?? item.productId ?? 'Pantry item',
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
          ],
          Expanded(
            child: EmptyState(
              title: 'No active list yet',
              description:
                  'Create your first shopping list to begin tracking products and prices.',
              icon: Icons.shopping_basket_outlined,
              primaryActionLabel: 'Create list',
              onPrimaryActionPressed: () {},
              secondaryActionLabel: 'View pantry',
              onSecondaryActionPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
