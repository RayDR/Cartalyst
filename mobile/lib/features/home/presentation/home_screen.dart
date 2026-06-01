import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_controller.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeDashboardState dashboardState = ref.watch(
      homeDashboardControllerProvider,
    );
    final ListsController listsController = ref.read(
      listsControllerProvider.notifier,
    );

    if (!dashboardState.hasAnyLists) {
      return AppScaffold(
        title: 'Home',
        child: EmptyState(
          title: 'No shopping lists yet',
          description: 'Create your first list and start shopping smarter.',
          icon: Icons.shopping_cart_outlined,
          primaryActionLabel: 'Create list',
          onPrimaryActionPressed: () =>
              _showCreateListSheet(context, listsController),
        ),
      );
    }

    return AppScaffold(
      title: 'Home',
      padding: EdgeInsets.zero,
      child: _HomeContent(
        state: dashboardState,
        onCreateList: () => _showCreateListSheet(context, listsController),
        onRestartList: (ShoppingList list) => listsController.restartList(list),
      ),
    );
  }

  Future<void> _showCreateListSheet(
    BuildContext context,
    ListsController controller,
  ) async {
    final String? name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) => const _NameSheet(
        title: 'New shopping list',
        description: 'Give your list a name to get started.',
        label: 'List name',
        hint: 'Example: Weekly groceries',
        actionLabel: 'Create list',
      ),
    );
    if (name == null || !context.mounted) {
      return;
    }
    final String? newId = await controller.createList(name);
    if (newId != null && context.mounted) {
      context.go('/lists/$newId');
    }
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({
    required this.state,
    required this.onCreateList,
    required this.onRestartList,
  });

  final HomeDashboardState state;
  final VoidCallback onCreateList;
  final Future<bool> Function(ShoppingList list) onRestartList;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  bool _completedExpanded = false;

  @override
  Widget build(BuildContext context) {
    final DateTime newBadgeCutoff =
        DateTime.now().subtract(const Duration(hours: 24));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: <Widget>[
        _buildRemindersSection(context),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeader(
          title: 'Shopping lists',
          actionLabel: 'New list',
          onActionPressed: widget.onCreateList,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (widget.state.activeLists.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              'No active lists. Tap "New list" to create one.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          )
        else
          ...widget.state.activeLists.map(
            (ShoppingList list) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _ListCard(
                list: list,
                isNew: list.createdAt.isAfter(newBadgeCutoff),
                onTap: () => context.go('/lists/${list.id}'),
              ),
            ),
          ),
        if (widget.state.completedLists.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(
            title: 'Completed',
            actionLabel: _completedExpanded ? 'Hide' : 'Show',
            onActionPressed: () =>
                setState(() => _completedExpanded = !_completedExpanded),
          ),
          if (_completedExpanded) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            ...widget.state.completedLists.map(
              (ShoppingList list) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: _CompletedListCard(
                  list: list,
                  onRestart: () => widget.onRestartList(list),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildRemindersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Shopping reminders',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (widget.state.reminders.isEmpty)
          Text(
            'Cartalyst will learn your frequent products as you shop.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          )
        else
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: widget.state.reminders
                .map(
                  (String name) => Chip(
                    label: Text(name),
                    visualDensity: VisualDensity.compact,
                    avatar: const Icon(Icons.shopping_bag_outlined, size: 16),
                  ),
                )
                .toList(growable: false),
          ),
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.list,
    required this.isNew,
    required this.onTap,
  });

  final ShoppingList list;
  final bool isNew;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: AppListTile(
        title: list.name,
        subtitle: _recentActivityLabel(list.updatedAt),
        leading: const Icon(Icons.shopping_cart_outlined),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isNew)
              Container(
                margin: const EdgeInsets.only(right: AppSpacing.xs),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'New',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _CompletedListCard extends StatelessWidget {
  const _CompletedListCard({
    required this.list,
    required this.onRestart,
  });

  final ShoppingList list;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: AppListTile(
        title: list.name,
        subtitle: _recentActivityLabel(list.updatedAt),
        leading: const Icon(Icons.check_circle_outline),
        trailing: TextButton(
          onPressed: onRestart,
          child: const Text('Restart'),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (actionLabel != null && onActionPressed != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _NameSheet extends StatefulWidget {
  const _NameSheet({
    required this.title,
    required this.description,
    required this.label,
    required this.hint,
    required this.actionLabel,
  });

  final String title;
  final String description;
  final String label;
  final String hint;
  final String actionLabel;

  @override
  State<_NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<_NameSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text(widget.actionLabel),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final String name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }
    Navigator.of(context).pop(name);
  }
}

String _recentActivityLabel(DateTime value) {
  final DateTime now = DateTime.now();
  final Duration diff = now.difference(value);
  if (diff.inMinutes < 1) {
    return 'Updated just now';
  }
  if (diff.inHours < 1) {
    return 'Updated ${diff.inMinutes}m ago';
  }
  if (diff.inDays < 1) {
    return 'Updated ${diff.inHours}h ago';
  }
  return 'Updated ${diff.inDays}d ago';
}

