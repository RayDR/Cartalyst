import 'package:cartalyst_mobile/core/debug/debug_diagnostics_provider.dart';
import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugDiagnosticsScreen extends ConsumerWidget {
  const DebugDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(debugDiagnosticsEntriesProvider);
    final store = ref.read(debugDiagnosticsStoreProvider);

    return AppScaffold(
      title: 'Debug Diagnostics',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Entries: ${entries.length}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => store.addLog(
                  message: 'Manual diagnostic marker',
                  source: 'settings',
                ),
                icon: const Icon(Icons.add_comment_outlined),
                label: const Text('Add marker'),
              ),
              TextButton.icon(
                onPressed: store.clear,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: entries.isEmpty
                ? EmptyState(
                    title: 'No diagnostics yet',
                    description:
                        'Errors and logs captured in debug mode will appear here.',
                    icon: Icons.bug_report_outlined,
                    primaryActionLabel: 'Add marker',
                    onPrimaryActionPressed: () => store.addLog(
                      message: 'Manual diagnostic marker',
                      source: 'settings',
                    ),
                  )
                : ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (BuildContext context, int index) {
                      final entry = entries[index];
                      return AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '[${entry.level}] ${entry.source}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            SelectableText(entry.message),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              entry.timestamp.toIso8601String(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (entry.stackTrace != null &&
                                entry.stackTrace!
                                    .trim()
                                    .isNotEmpty) ...<Widget>[
                              const SizedBox(height: AppSpacing.xs),
                              ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                title: const Text('Stack trace'),
                                children: <Widget>[
                                  SelectableText(entry.stackTrace!),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
