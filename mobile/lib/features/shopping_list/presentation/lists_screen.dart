import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ListsState state = ref.watch(listsControllerProvider);
    final ListsController controller = ref.read(listsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('My Lists')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('New list'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: state.isEmpty
          ? EmptyState(
              title: 'No lists yet',
              description: 'Create a list to start tracking your shopping.',
              icon: Icons.shopping_cart_outlined,
              primaryActionLabel: 'Create my first list',
              onPrimaryActionPressed: () => _showCreateDialog(context, controller),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: state.lists.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (BuildContext context, int index) {
                final ShoppingList list = state.lists[index];
                return _ListCard(
                  list: list,
                  onTap: () => context.go('/lists/${list.id}'),
                  onRename: () => _showRenameDialog(context, controller, list),
                  onDelete: () => _confirmDelete(context, controller, list),
                );
              },
            ),
        ),
      ),
    );
  }

  Future<void> _showCreateDialog(
    BuildContext context,
    ListsController controller,
  ) async {
    final String? name = await _showNameSheet(
      context,
      title: 'New list',
      initialValue: '',
    );
    if (name == null || !context.mounted) {
      return;
    }
    final String? newId = await controller.createList(name);
    if (newId != null && context.mounted) {
      context.go('/lists/$newId');
    }
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    ListsController controller,
    ShoppingList list,
  ) async {
    final String? newName = await _showNameSheet(
      context,
      title: 'Rename list',
      initialValue: list.name,
    );
    if (newName == null) {
      return;
    }
    await controller.renameList(list, newName);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ListsController controller,
    ShoppingList list,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete list?'),
        content: Text('Delete "${list.name}"? You can undo this.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await controller.deleteList(list);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${list.name}" deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: controller.restoreLastDeleted,
          ),
        ),
      );
    }
  }

  Future<String?> _showNameSheet(
    BuildContext context, {
    required String title,
    required String initialValue,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) => _NameSheet(
        title: title,
        initialValue: initialValue,
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.list,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  final ShoppingList list;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: AppListTile(
        title: list.name,
        subtitle: list.inventoryId != null ? 'Linked to inventory' : 'No inventory linked',
        leading: const Icon(Icons.shopping_cart_outlined),
        trailing: PopupMenuButton<_ListAction>(
          onSelected: (_ListAction action) {
            switch (action) {
              case _ListAction.rename:
                onRename();
              case _ListAction.delete:
                onDelete();
            }
          },
          itemBuilder: (_) => const <PopupMenuEntry<_ListAction>>[
            PopupMenuItem<_ListAction>(
              value: _ListAction.rename,
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Rename'),
              ),
            ),
            PopupMenuItem<_ListAction>(
              value: _ListAction.delete,
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ListAction { rename, delete }

class _NameSheet extends StatefulWidget {
  const _NameSheet({
    required this.title,
    required this.initialValue,
  });

  final String title;
  final String initialValue;

  @override
  State<_NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<_NameSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

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
              child: const Text('Save'),
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
