import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class PantryScreen extends StatelessWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pantry',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeader(
            title: 'Inventory snapshot',
            subtitle: 'Track essential items and keep inventory lightweight.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              StatusChip(label: 'Low stock', tone: StatusChipTone.warning),
              StatusChip(label: 'Tracked basics'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: AppListTile(
              title: 'Add pantry staple',
              subtitle: 'Milk, eggs, rice, and other essentials.',
              leading: Icon(Icons.kitchen_outlined),
              trailing: Icon(Icons.add_circle_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: EmptyState(
              title: 'No pantry items yet',
              description:
                  'Track core household products so you can avoid duplicate purchases.',
              icon: Icons.inventory_2_outlined,
              primaryActionLabel: 'Add pantry item',
              onPrimaryActionPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
