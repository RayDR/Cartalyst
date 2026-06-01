import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_notification.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InventoriesScreen extends ConsumerWidget {
  const InventoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InventoriesState state = ref.watch(inventoriesControllerProvider);
    final InventoriesController controller =
        ref.read(inventoriesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventories')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('New inventory'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: state.isEmpty
              ? EmptyState(
                  title: 'No inventories yet',
                  description:
                      'Create an inventory to track what you have at home — '
                      'pantry, storage, baby supplies, and more.',
                  icon: Icons.inventory_2_outlined,
                  primaryActionLabel: 'Create inventory',
                  onPrimaryActionPressed: () =>
                      _showCreateDialog(context, controller),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: state.inventories.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (BuildContext context, int index) {
                    final Inventory inventory = state.inventories[index];
                    return _InventoryCard(
                      inventory: inventory,
                      onTap: () => context.go('/inventories/${inventory.id}'),
                      onRename: () =>
                          _showRenameDialog(context, controller, inventory),
                      onDelete: () =>
                          _confirmDelete(context, controller, inventory),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _showCreateDialog(
    BuildContext context,
    InventoriesController controller,
  ) async {
    final String? name = await _showNameSheet(
      context,
      title: 'New inventory',
      initialValue: '',
      hint: 'Example: Pantry, Hall closet, Baby supplies',
    );
    if (name == null || !context.mounted) return;
    final String? newId = await controller.createInventory(name);
    if (newId != null && context.mounted) {
      showAppNotification(
        context,
        title: 'Inventory created',
        message: '"$name" is ready.',
      );
      context.go('/inventories/$newId');
    }
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    InventoriesController controller,
    Inventory inventory,
  ) async {
    final String? newName = await _showNameSheet(
      context,
      title: 'Rename inventory',
      initialValue: inventory.name,
      hint: 'Example: Pantry, Kitchen storage, Cleaning',
    );
    if (newName == null) return;
    await controller.renameInventory(inventory, newName);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    InventoriesController controller,
    Inventory inventory,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete inventory?'),
        content: Text('Delete "${inventory.name}"? You can undo this.'),
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

    if (confirmed != true || !context.mounted) return;

    await controller.deleteInventory(inventory);

    if (context.mounted) {
      showAppNotification(
        context,
        title: 'Inventory deleted',
        message: '"${inventory.name}" deleted.',
        actionLabel: 'Undo',
        onAction: controller.restoreLastDeleted,
      );
    }
  }

  Future<String?> _showNameSheet(
    BuildContext context, {
    required String title,
    required String initialValue,
    required String hint,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) => _NameSheet(
        title: title,
        initialValue: initialValue,
        hint: hint,
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({
    required this.inventory,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  final Inventory inventory;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: AppListTile(
        title: inventory.name,
        subtitle: inventory.description,
        leading: const Icon(Icons.inventory_2_outlined),
        trailing: PopupMenuButton<_InventoryAction>(
          onSelected: (_InventoryAction action) {
            switch (action) {
              case _InventoryAction.rename:
                onRename();
              case _InventoryAction.delete:
                onDelete();
            }
          },
          itemBuilder: (_) => const <PopupMenuEntry<_InventoryAction>>[
            PopupMenuItem<_InventoryAction>(
              value: _InventoryAction.rename,
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Rename'),
              ),
            ),
            PopupMenuItem<_InventoryAction>(
              value: _InventoryAction.delete,
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

enum _InventoryAction { rename, delete }

class _NameSheet extends StatefulWidget {
  const _NameSheet({
    required this.title,
    required this.initialValue,
    required this.hint,
  });

  final String title;
  final String initialValue;
  final String hint;

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
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Inventory name',
              hintText: widget.hint,
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
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }
}
