import 'package:cartalyst_mobile/core/debug/debug_diagnostics.dart';
import 'package:cartalyst_mobile/core/debug/debug_diagnostics_provider.dart';
import 'package:cartalyst_mobile/core/design/app_radius.dart';
import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugDiagnosticsScreen extends ConsumerWidget {
  const DebugDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<DebugLogEntry> entries =
        ref.watch(debugDiagnosticsEntriesProvider);
    final DebugDiagnosticsStore store = ref.read(debugDiagnosticsStoreProvider);

    return AppScaffold(
      title: 'Debug Diagnostics',
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _DiagnosticsHeader(
              entryCount: entries.length,
              onAddMarker: () => store.addLog(
                message: 'Manual diagnostic marker',
                source: 'settings',
              ),
              onClear: store.clear,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
          if (entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _DiagnosticsEmptyState(
                onAddMarker: () => store.addLog(
                  message: 'Manual diagnostic marker',
                  source: 'settings',
                ),
              ),
            )
          else
            SliverList.builder(
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == entries.length - 1
                        ? AppSpacing.xl
                        : AppSpacing.xs,
                  ),
                  child: _DiagnosticEntryCard(entry: entries[index]),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _DiagnosticsEmptyState extends StatelessWidget {
  const _DiagnosticsEmptyState({required this.onAddMarker});

  final VoidCallback onAddMarker;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Center(
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.secondaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Icon(Icons.bug_report_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No diagnostics yet',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Errors and logs captured in debug mode will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onAddMarker,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add marker'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagnosticsHeader extends StatelessWidget {
  const _DiagnosticsHeader({
    required this.entryCount,
    required this.onAddMarker,
    required this.onClear,
  });

  final int entryCount;
  final VoidCallback onAddMarker;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: <Widget>[
        Text(
          'Entries: $entryCount',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: <Widget>[
            TextButton.icon(
              onPressed: onAddMarker,
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('Add marker'),
            ),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DiagnosticEntryCard extends StatefulWidget {
  const _DiagnosticEntryCard({required this.entry});

  final DebugLogEntry entry;

  @override
  State<_DiagnosticEntryCard> createState() => _DiagnosticEntryCardState();
}

class _DiagnosticEntryCardState extends State<_DiagnosticEntryCard> {
  bool _stackExpanded = false;

  @override
  Widget build(BuildContext context) {
    final DebugLogEntry entry = widget.entry;
    final String? stackTrace = entry.stackTrace?.trim();
    final bool hasStackTrace = stackTrace != null && stackTrace.isNotEmpty;

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
          if (hasStackTrace) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    setState(() => _stackExpanded = !_stackExpanded);
                  },
                  icon: Icon(
                    _stackExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(
                    _stackExpanded ? 'Hide stack trace' : 'Show stack trace',
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: stackTrace));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Stack trace copied')),
                    );
                  },
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copy'),
                ),
              ],
            ),
            if (_stackExpanded) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              _StackTraceBox(stackTrace: stackTrace),
            ],
          ],
        ],
      ),
    );
  }
}

class _StackTraceBox extends StatelessWidget {
  const _StackTraceBox({required this.stackTrace});

  final String stackTrace;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 240),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: SelectableText(
            stackTrace,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
