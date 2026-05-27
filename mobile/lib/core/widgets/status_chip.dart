import 'package:flutter/material.dart';

enum StatusChipTone {
  neutral,
  success,
  warning,
  danger,
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    super.key,
    this.tone = StatusChipTone.neutral,
  });

  final String label;
  final StatusChipTone tone;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final ({Color background, Color foreground}) palette = switch (tone) {
      StatusChipTone.neutral => (
          background: colors.surfaceContainerHigh,
          foreground: colors.onSurfaceVariant,
        ),
      StatusChipTone.success => (
          background: colors.tertiaryContainer,
          foreground: colors.onTertiaryContainer,
        ),
      StatusChipTone.warning => (
          background: colors.secondaryContainer,
          foreground: colors.onSecondaryContainer,
        ),
      StatusChipTone.danger => (
          background: colors.errorContainer,
          foreground: colors.onErrorContainer,
        ),
    };

    return Chip(
      label: Text(label),
      side: BorderSide.none,
      backgroundColor: palette.background,
      labelStyle: TextStyle(
        color: palette.foreground,
        fontWeight: FontWeight.w600,
      ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
  }
}
