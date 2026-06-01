import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/keyboard_aware_scroll_view.dart';
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
          child: Column(
            children: <Widget>[
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppCard(
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.error_outline),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: Text(state.errorMessage!)),
                        TextButton(
                          onPressed: controller.refresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: state.isEmpty
                    ? EmptyState(
                        title: 'No lists yet',
                        description:
                            'Create a list to start tracking your shopping.',
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
                              margin:
                                  const EdgeInsets.only(bottom: AppSpacing.xs),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
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
            ],
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
      listType: draft.listType,
      routingMode: draft.routingMode,
    );
    if (!context.mounted) {
      return;
    }
    if (newId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to create list. Try again.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('List created')),
    );
    context.go('/lists/$newId');
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
        subtitle: _subtitleForList(list),
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

  String _subtitleForList(ShoppingList value) {
    if (value.listType == ShoppingListType.simple) {
      return 'Simple list';
    }

    return switch (value.routingMode) {
      ShoppingListRoutingMode.inventoryCategories =>
        'Organized inside one inventory',
      ShoppingListRoutingMode.categoryAsInventory =>
        'Organized across inventories',
      ShoppingListRoutingMode.none => 'Organized list',
    };
  }
}

enum _ListAction { rename, delete }

class _ListDraft {
  const _ListDraft({
    required this.name,
    required this.listType,
    required this.routingMode,
  });

  final String name;
  final ShoppingListType listType;
  final ShoppingListRoutingMode routingMode;
}

class _ListComposerSheet extends StatefulWidget {
  const _ListComposerSheet();

  @override
  State<_ListComposerSheet> createState() => _ListComposerSheetState();
}

class _ListComposerSheetState extends State<_ListComposerSheet> {
  late final TextEditingController _controller;
  int _step = 1;
  ShoppingListType? _selectedListType;
  ShoppingListRoutingMode? _selectedRoutingMode;

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
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: KeyboardAwareScrollView(
          fillViewport: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('New list', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Step $_step of 3',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              if (_step == 1) ...<Widget>[
                const Text('Name your list.'),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'List name',
                    hintText: 'Example: Weekly groceries',
                  ),
                  onSubmitted: (_) => _nextFromName(),
                ),
              ] else if (_step == 2) ...<Widget>[
                const Text('Choose how this list should behave.'),
                const SizedBox(height: AppSpacing.md),
                _ChoiceTile(
                  label: 'Simple list',
                  subtitle: 'Quick checklist with no category routing.',
                  selected: _selectedListType == ShoppingListType.simple,
                  onTap: () {
                    setState(() {
                      _selectedListType = ShoppingListType.simple;
                      _selectedRoutingMode = ShoppingListRoutingMode.none;
                    });
                  },
                ),
                _ChoiceTile(
                  label: 'Organized list',
                  subtitle: 'Group items by categories and route destinations.',
                  selected: _selectedListType == ShoppingListType.organized,
                  onTap: () {
                    setState(() {
                      _selectedListType = ShoppingListType.organized;
                    });
                  },
                ),
              ] else ...<Widget>[
                const Text('Choose routing mode.'),
                const SizedBox(height: AppSpacing.md),
                _ChoiceTile(
                  label: 'Organize inside one inventory',
                  subtitle:
                      'Route categories to sections inside a single inventory.',
                  selected: _selectedRoutingMode ==
                      ShoppingListRoutingMode.inventoryCategories,
                  onTap: () {
                    setState(() {
                      _selectedRoutingMode =
                          ShoppingListRoutingMode.inventoryCategories;
                    });
                  },
                ),
                _ChoiceTile(
                  label: 'Organize across inventories',
                  subtitle: 'Route categories to different inventories.',
                  selected: _selectedRoutingMode ==
                      ShoppingListRoutingMode.categoryAsInventory,
                  onTap: () {
                    setState(() {
                      _selectedRoutingMode =
                          ShoppingListRoutingMode.categoryAsInventory;
                    });
                  },
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  if (_step > 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _goBack,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_step > 1) const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: _onPrimaryAction,
                      child: Text(_primaryLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _primaryLabel {
    if (_step == 1) {
      return 'Next';
    }
    if (_step == 2 && _selectedListType == ShoppingListType.simple) {
      return 'Create list';
    }
    if (_step == 2) {
      return 'Continue';
    }
    return 'Create list';
  }

  void _onPrimaryAction() {
    if (_step == 1) {
      _nextFromName();
      return;
    }

    if (_step == 2) {
      if (_selectedListType == null) {
        return;
      }
      if (_selectedListType == ShoppingListType.simple) {
        _submit(
          listType: ShoppingListType.simple,
          routingMode: ShoppingListRoutingMode.none,
        );
        return;
      }
      setState(() {
        _step = 3;
      });
      return;
    }

    if (_selectedRoutingMode == null) {
      return;
    }
    _submit(
      listType: ShoppingListType.organized,
      routingMode: _selectedRoutingMode!,
    );
  }

  void _nextFromName() {
    final String name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }

    setState(() {
      _step = 2;
    });
  }

  void _goBack() {
    setState(() {
      _step = _step - 1;
      if (_step < 1) {
        _step = 1;
      }
    });
  }

  void _submit({
    required ShoppingListType listType,
    required ShoppingListRoutingMode routingMode,
  }) {
    final String name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }

    Navigator.of(context).pop(
      _ListDraft(
        name: name,
        listType: listType,
        routingMode: routingMode,
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
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
