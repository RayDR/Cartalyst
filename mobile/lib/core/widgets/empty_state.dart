import 'package:cartalyst_mobile/core/design/app_radius.dart';
import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.description,
    required this.icon,
    super.key,
    this.primaryActionLabel,
    this.onPrimaryActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryActionPressed;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryActionPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: AppSpacing.xxl + AppSpacing.md,
              width: AppSpacing.xxl + AppSpacing.md,
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: colors.onSecondaryContainer),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (primaryActionLabel != null && onPrimaryActionPressed != null)
              ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: primaryActionLabel!,
                  onPressed: onPrimaryActionPressed,
                  icon: Icons.add_circle_outline,
                ),
              ],
            if (secondaryActionLabel != null &&
                onSecondaryActionPressed != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: secondaryActionLabel!,
                onPressed: onSecondaryActionPressed,
                icon: Icons.tune_rounded,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
