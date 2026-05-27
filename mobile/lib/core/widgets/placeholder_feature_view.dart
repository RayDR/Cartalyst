import 'package:cartalyst_mobile/core/design/app_colors.dart';
import 'package:cartalyst_mobile/core/design/app_radius.dart';
import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:flutter/material.dart';

class PlaceholderFeatureView extends StatelessWidget {
  const PlaceholderFeatureView({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(icon, color: colors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Next milestone',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: <Widget>[
                  Icon(Icons.check_circle_outline, color: AppColors.info),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'This feature shell is ready for domain and application wiring.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
