import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant {
  primary,
  secondary,
  danger,
}

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(icon ?? Icons.check_circle_outline),
          label: Text(label),
        ),
      AppButtonVariant.secondary => OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon ?? Icons.tune_rounded),
          label: Text(label),
        ),
      AppButtonVariant.danger => FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: onPressed,
          icon: Icon(icon ?? Icons.delete_outline),
          label: Text(label),
        ),
    };

    final Widget constrainedButton = SizedBox(
      height: AppSpacing.xxl,
      child: button,
    );

    if (expanded) {
      return SizedBox(
        width: double.infinity,
        child: constrainedButton,
      );
    }

    return constrainedButton;
  }
}
