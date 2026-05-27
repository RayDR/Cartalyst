import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
