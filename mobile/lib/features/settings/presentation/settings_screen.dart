import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:cartalyst_mobile/features/settings/presentation/debug_diagnostics_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeader(
            title: 'Preferences',
            subtitle: 'Control app behavior for a focused shopping workflow.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              StatusChip(label: 'Offline-ready', tone: StatusChipTone.success),
              StatusChip(label: 'Sync later'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: Column(
              children: <Widget>[
                AppListTile(
                  title: 'Shopping mode',
                  subtitle: 'One-handed optimized layout preferences.',
                  leading: Icon(Icons.handshake_outlined),
                  trailing: Icon(Icons.chevron_right),
                ),
                SizedBox(height: AppSpacing.xs),
                AppListTile(
                  title: 'Data and privacy',
                  subtitle: 'Manage local-first storage preferences.',
                  leading: Icon(Icons.privacy_tip_outlined),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (kDebugMode) ...<Widget>[
            AppCard(
              child: AppListTile(
                title: 'Debug diagnostics',
                subtitle: 'View runtime errors and logs while testing the app.',
                leading: const Icon(Icons.bug_report_outlined),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DebugDiagnosticsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Expanded(
            child: EmptyState(
              title: 'No custom preferences yet',
              description:
                  'Default settings are active. Personalization options will expand in upcoming milestones.',
              icon: Icons.tune_rounded,
              primaryActionLabel: 'Review defaults',
              onPrimaryActionPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
