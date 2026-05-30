import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
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
    final ListsController controller =
        ref.read(listsControllerProvider.notifier);
    final Map<String, Inventory> inventoriesById = <String, Inventory>{
      for (final Inventory inventory
          in ref.watch(inventoriesControllerProvider).inventories)
        inventory.id: inventory,
    };

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
                  onPrimaryActionPressed: () =>
                      _showCreateDialog(context, controller),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: state.lists.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (BuildContext context, int index) {
                    final ShoppingList list = state.lists[index];
                    return Dismissible(
                      key: ValueKey<String>(list.id),
                      direction: DismissDirection.endToStart,
                      background: const SizedBox.shrink(),
                      secondaryBackground: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete_outline),
                      ),
                      onDismissed: (_) => _deleteListWithUndo(
                        context,
                        controller,
                        list,
                      ),
                      child: _ListCard(
                        list: list,
                        inventoryName: list.inventoryId == null
                            ? null
                            : inventoriesById[list.inventoryId!]?.name,
                        onTap: () => context.go('/lists/${list.id}'),
                        onRename: () =>
                            _showRenameDialog(context, controller, list),
                        onDelete: () =>
                            _confirmDelete(context, controller, list),
                      ),
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
    final _ListDraft? draft = await _showListComposerSheet(context);
    if (draft == null || !context.mounted) {
      return;
    }
    final String? newId = await controller.createList(
      draft.name,
      inventoryId: draft.inventoryId,
    );
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
    final bool renamed = await controller.renameList(list, newName);
    if (renamed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Renamed "${list.name}"'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: controller.undoLastAction,
          ),
        ),
      );
    }
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

    final bool deleted = await controller.deleteList(list);

    if (!deleted || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${list.name}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: controller.undoLastAction,
        ),
      ),
    );
  }

  Future<void> _deleteListWithUndo(
    BuildContext context,
    ListsController controller,
    ShoppingList list,
  ) async {
    final bool deleted = await controller.deleteList(list);
    if (!deleted || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${list.name}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: controller.undoLastAction,
        ),
      ),
    );
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

  Future<_ListDraft?> _showListComposerSheet(BuildContext context) {
    return showModalBottomSheet<_ListDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) => const _ListComposerSheet(),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.list,
    required this.inventoryName,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  final ShoppingList list;
  final String? inventoryName;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: AppListTile(
        title: list.name,
        subtitle: list.inventoryId == null
            ? 'No inventory linked'
            : inventoryName == null
                ? 'Linked to inventory'
                : 'Linked to $inventoryName',
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

class _ListDraft {
  const _ListDraft({
    required this.name,
    required this.inventoryId,
  });

  final String name;
  final String? inventoryId;
}

class _ListComposerSheet extends ConsumerStatefulWidget {
  const _ListComposerSheet();

  @override
  ConsumerState<_ListComposerSheet> createState() => _ListComposerSheetState();
}

class _ListComposerSheetState extends ConsumerState<_ListComposerSheet> {
  late final TextEditingController _controller;
  String? _selectedInventoryId;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Inventory> inventories =
        ref.watch(inventoriesControllerProvider).inventories;

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
          const Text('You can skip inventory linking now and change it later.'),
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
          Text(
            'Linked inventory (optional)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          _InventoryChoiceTile(
            label: 'No inventory',
            subtitle: 'Keep this list standalone for now.',
            selected: _selectedInventoryId == null,
            onTap: () {
              setState(() {
                _selectedInventoryId = null;
              });
            },
          ),
          if (inventories.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'No inventories yet. Create one below if you want to link now.',
              ),
            )
          else
            ...inventories.map(
              (Inventory inventory) => _InventoryChoiceTile(
                label: inventory.name,
                selected: _selectedInventoryId == inventory.id,
                onTap: () {
                  setState(() {
                    _selectedInventoryId = inventory.id;
                  });
                },
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _createAndSelectInventory(context),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create inventory and link'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: const Text('Create list'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createAndSelectInventory(BuildContext context) async {
    final String? name = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const _InventoryNameDialog(),
    );
    if (name == null || !mounted) {
      return;
    }

    final String? inventoryId = await ref
        .read(inventoriesControllerProvider.notifier)
        .createInventory(name);
    if (inventoryId == null || !mounted) {
      return;
    }

    setState(() {
      _selectedInventoryId = inventoryId;
    });
  }

  void _submit() {
    final String name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }
    Navigator.of(context).pop(
      _ListDraft(name: name, inventoryId: _selectedInventoryId),
    );
  }
}

class _InventoryChoiceTile extends StatelessWidget {
  const _InventoryChoiceTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      onTap: onTap,
      child: AppListTile(
        title: label,
        subtitle: subtitle,
        leading: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
        ),
      ),
    );
  }
}

class _InventoryNameDialog extends StatefulWidget {
  const _InventoryNameDialog();

  @override
  State<_InventoryNameDialog> createState() => _InventoryNameDialogState();
}

class _InventoryNameDialogState extends State<_InventoryNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New inventory'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          labelText: 'Inventory name',
          hintText: 'Example: Pantry, Cleaning, Baby supplies',
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Create'),
        ),
      ],
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
