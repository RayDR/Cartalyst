import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_button.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/app_text_field.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Shopping List',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeader(
            title: 'Quick product add',
            subtitle: 'Build lists quickly with suggestion-ready product input.',
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            label: 'Product',
            hint: 'Try: eggs, milk, rice',
            prefixIcon: Icons.search,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Add product',
            onPressed: () {},
            icon: Icons.add_shopping_cart_outlined,
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: AppListTile(
              title: 'Suggestions will appear here',
              subtitle: 'Recent and frequent products will surface as you type.',
              leading: Icon(Icons.lightbulb_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: EmptyState(
              title: 'Your list is empty',
              description:
                  'Add your first grocery item to start a focused shopping trip.',
              icon: Icons.shopping_cart_outlined,
              primaryActionLabel: 'Add starter item',
              onPrimaryActionPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
