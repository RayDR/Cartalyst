import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ListsState listsState = ref.watch(listsControllerProvider);
    final ListsController listsController = ref.read(listsControllerProvider.notifier);

    final String greeting = _greetingForNow();

    return AppScaffold(
      title: 'Cartalyst',
      child: ListView(
        children: <Widget>[
          Text(
            greeting,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('Your smart shopping assistant'),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showCreateDialog(context, listsController),
              icon: const Icon(Icons.add),
              label: const Text('New list'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SectionHeader(
            title: 'Recent lists',
            subtitle: listsState.isEmpty
                ? 'Create your first list to get started.'
                : 'Your most recently updated lists.',
          ),
          const SizedBox(height: AppSpacing.sm),
          if (listsState.isEmpty)
            const AppCard(
              child: AppListTile(
                title: 'No lists yet',
                subtitle: 'Tap "New list" above to create one.',
                leading: Icon(Icons.shopping_cart_outlined),
              ),
            )
          else
            ...listsState.recentLists.map(
              (ShoppingList list) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  onTap: () => context.go('/lists/${list.id}'),
                  child: AppListTile(
                    title: list.name,
                    subtitle: 'Updated ${_formatTimestamp(list.updatedAt)}',
                    leading: const Icon(Icons.shopping_cart_outlined),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
          if (!listsState.isEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            TextButton(
              onPressed: () => context.go('/lists'),
              child: const Text('See all lists'),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppCard(
            onTap: () => context.go('/price-compare'),
            child: const AppListTile(
              title: 'Compare package value',
              subtitle: 'Check unit price between options.',
              leading: Icon(Icons.balance_outlined),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Future<void> _showCreateDialog(
    BuildContext context,
    ListsController controller,
  ) async {
    final String? name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) => _NameSheet(),
    );
    if (name == null || !context.mounted) {
      return;
    }
    final String? newId = await controller.createList(name);
    if (newId != null && context.mounted) {
      context.go('/lists/$newId');
    }
  }

  static String _greetingForNow() {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 18) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  static String _formatTimestamp(DateTime value) {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(value);
    if (diff.inMinutes < 1) {
      return 'just now';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    }
    return '${diff.inDays}d ago';
  }
}

class _NameSheet extends StatefulWidget {
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
          Text('New list', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'List name',
              hintText: 'Example: Weekly groceries',
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: const Text('Create'),
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
