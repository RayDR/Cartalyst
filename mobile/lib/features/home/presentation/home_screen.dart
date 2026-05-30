import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
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

    return AppScaffold(
      title: 'Home',
      child: ListView(
        children: <Widget>[
          if (listsState.isEmpty)
            EmptyState(
              title: 'Cartalyst',
              description:
                  'Keep your shopping lists local, organized, and ready whenever you are.',
              icon: Icons.shopping_cart_outlined,
              primaryActionLabel: 'Create shopping list',
              onPrimaryActionPressed: () => _showCreateDialog(context, listsController),
            )
          else ...<Widget>[
            Text(
              'Recent lists',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Recently created or updated lists stay at the top.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _showCreateDialog(context, listsController),
                icon: const Icon(Icons.add),
                label: const Text('Create shopping list'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...listsState.recentLists.map(
              (ShoppingList list) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  onTap: () => context.go('/lists/${list.id}'),
                  child: AppListTile(
                    title: list.name,
                    subtitle: _recentActivityLabel(list.updatedAt),
                    leading: const Icon(Icons.shopping_cart_outlined),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
          ],
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
      builder: (BuildContext context) => const _NameSheet(),
    );
    if (name == null || !context.mounted) {
      return;
    }

    final String? newId = await controller.createList(name);
    if (newId != null && context.mounted) {
      context.go('/lists/$newId');
    }
  }

  static String _recentActivityLabel(DateTime value) {
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
}

class _NameSheet extends StatefulWidget {
  const _NameSheet();

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
