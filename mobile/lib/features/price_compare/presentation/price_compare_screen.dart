import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/app_text_field.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class PriceCompareScreen extends StatelessWidget {
  const PriceCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Price Compare',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeader(
            title: 'Unit price insights',
            subtitle: 'Compare unit prices clearly for smarter in-store decisions.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const StatusChip(
            label: 'Analytical mode',
            tone: StatusChipTone.success,
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            label: 'Product to compare',
            hint: 'Try: olive oil 500ml',
            prefixIcon: Icons.search,
            textInputAction: TextInputAction.search,
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: AppListTile(
              title: 'Comparison result area',
              subtitle: 'Price per unit and best-value highlight will appear here.',
              leading: Icon(Icons.balance_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: EmptyState(
              title: 'No comparisons yet',
              description:
                  'Add products with size and price details to evaluate value instantly.',
              icon: Icons.price_check_outlined,
              primaryActionLabel: 'Start comparison',
              onPrimaryActionPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
