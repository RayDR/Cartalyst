import 'package:cartalyst_mobile/core/design/app_radius.dart';
import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/keyboard_aware_scroll_view.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_category.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shoppingListCategoriesProvider =
    StreamProvider.family<List<ShoppingListCategory>, String>(
  (Ref ref, String listId) {
    final repository = ref.watch(shoppingListRepositoryProvider);
    return repository.watchCategoriesForList(listId);
  },
);

class ListDetailScreen extends ConsumerStatefulWidget {
  const ListDetailScreen({required this.listId, super.key});

  final String listId;

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen> {
  bool _draftDialogOpen = false;
  final Set<String> _selectedItemIds = <String>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ListsState listsState = ref.watch(listsControllerProvider);
    final ShoppingList? currentList =
        _findList(listsState.lists, widget.listId);
    final bool isOrganized =
        currentList?.listType == ShoppingListType.organized;
    final List<ShoppingListCategory> listCategories =
        ref.watch(shoppingListCategoriesProvider(widget.listId)).valueOrNull ??
            const <ShoppingListCategory>[];
    final List<Inventory> linkedInventories = ref
            .watch(linkedInventoriesForListProvider(widget.listId))
            .valueOrNull ??
        const <Inventory>[];

    final ShoppingListState state =
        ref.watch(shoppingListControllerProvider(widget.listId));
    final ShoppingListController controller =
        ref.read(shoppingListControllerProvider(widget.listId).notifier);
    final ListsController listsController =
        ref.read(listsControllerProvider.notifier);

    if (currentList != null) {
      controller.syncWithList(currentList);
    }

    ref.listen<ShoppingListState>(
      shoppingListControllerProvider(widget.listId),
      (ShoppingListState? previous, ShoppingListState next) {
        final ShoppingList? list = _findList(listsState.lists, widget.listId);
        if (list == null || !next.draftPromptPending || _draftDialogOpen) {
          return;
        }
        _draftDialogOpen = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _showDraftChoiceDialog(context, controller, list);
          _draftDialogOpen = false;
        });
      },
    );

    final String listTitle = state.isEditMode
        ? (state.draftName ?? currentList?.name ?? 'Shopping List')
        : (currentList?.name ?? 'Shopping List');
    final bool isSelectionMode = _selectedItemIds.isNotEmpty;
    final List<ShoppingListItem> selectedItems = _selectedItemsFrom(state);

    return Scaffold(
      appBar: AppBar(
        title: Text(listTitle),
        leading: isSelectionMode
            ? IconButton(
                tooltip: 'Clear selection',
                onPressed: _clearSelection,
                icon: const Icon(Icons.close),
              )
            : null,
        actions: <Widget>[
          if (isSelectionMode)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(
                child: Text('${selectedItems.length} selected'),
              ),
            ),
          if (currentList != null)
            PopupMenuButton<_ListOverflowAction>(
              tooltip: 'More actions',
              icon: const Icon(Icons.more_vert),
              onSelected: (_ListOverflowAction action) => _handleOverflowAction(
                context,
                action,
                list: currentList,
                listsController: listsController,
                linkedInventoryIds: linkedInventories
                    .map((Inventory inventory) => inventory.id)
                    .toSet(),
              ),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<_ListOverflowAction>>[
                const PopupMenuItem<_ListOverflowAction>(
                  value: _ListOverflowAction.rename,
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Rename'),
                  ),
                ),
                PopupMenuItem<_ListOverflowAction>(
                  value: _ListOverflowAction.inventorySettings,
                  child: const ListTile(
                    leading: Icon(Icons.tune_outlined),
                    title: Text('Inventories'),
                  ),
                ),
                PopupMenuItem<_ListOverflowAction>(
                  value: _ListOverflowAction.categorySettings,
                  enabled: isOrganized,
                  child: const ListTile(
                    leading: Icon(Icons.category_outlined),
                    title: Text('Categories'),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<_ListOverflowAction>(
                  value: _ListOverflowAction.archive,
                  child: ListTile(
                    leading: Icon(Icons.archive_outlined),
                    title: Text('Archive list'),
                  ),
                ),
                const PopupMenuItem<_ListOverflowAction>(
                  value: _ListOverflowAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete list'),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            if (state.hasItems)
              isOrganized
                  ? _OrganizedItemsView(
                      state: state,
                      controller: controller,
                      categories: listCategories,
                      selectedItemIds: _selectedItemIds,
                      onToggleSelection: _toggleSelection,
                      onShowUndo: _showUndo,
                    )
                  : _FlatItemsView(
                      state: state,
                      controller: controller,
                      selectedItemIds: _selectedItemIds,
                      onToggleSelection: _toggleSelection,
                      onShowUndo: _showUndo,
                    )
            else
              EmptyState(
                title: 'This list is empty',
                description: 'Tap + to add your first item to this shopping list.',
                icon: Icons.shopping_cart_outlined,
                primaryActionLabel: 'Add item',
                onPrimaryActionPressed: () => _showAddItemSheet(
                  context,
                  controller,
                  listCategories,
                  linkedInventories,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        tooltip: 'Add item',
        onPressed: () => _showAddItemSheet(
          context,
          controller,
          listCategories,
          linkedInventories,
        ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: isSelectionMode
          ? _SelectionActionBar(
              selectedCount: selectedItems.length,
              onClearSelection: _clearSelection,
              onMarkPurchased: () => _applySelectionAction(
                selectedItems,
                controller.markPurchased,
                message: 'Marked selected items as purchased',
              ),
              onMarkSkipped: () => _applySelectionAction(
                selectedItems,
                controller.markSkipped,
                message: 'Marked selected items as skipped',
              ),
              onDelete: () => _applySelectionAction(
                selectedItems,
                controller.softDelete,
                message: 'Deleted selected items',
              ),
            )
          : null,
    );
  }

  void _showUndo(String message, VoidCallback onUndo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'Undo', onPressed: onUndo),
      ),
    );
  }

  void _toggleSelection(String itemId) {
    setState(() {
      if (_selectedItemIds.contains(itemId)) {
        _selectedItemIds.remove(itemId);
      } else {
        _selectedItemIds.add(itemId);
      }
    });
  }

  void _clearSelection() {
    if (_selectedItemIds.isEmpty) {
      return;
    }
    setState(() {
      _selectedItemIds.clear();
    });
  }

  List<ShoppingListItem> _selectedItemsFrom(ShoppingListState state) {
    final List<ShoppingListItem> all = <ShoppingListItem>[
      ...state.pendingItems,
      ...state.skippedItems,
      ...state.purchasedItems,
    ];
    return all
        .where((ShoppingListItem item) => _selectedItemIds.contains(item.id))
        .toList(growable: false);
  }

  Future<void> _applySelectionAction(
    List<ShoppingListItem> selectedItems,
    Future<bool> Function(ShoppingListItem item) action, {
    required String message,
  }) async {
    if (selectedItems.isEmpty) {
      return;
    }

    bool anyUpdated = false;
    for (final ShoppingListItem item in selectedItems) {
      final bool updated = await action(item);
      anyUpdated = anyUpdated || updated;
    }

    if (!mounted) {
      return;
    }

    if (anyUpdated) {
      _showUndo(
        message,
        ref
            .read(shoppingListControllerProvider(widget.listId).notifier)
            .undoLastAction,
      );
    }
    _clearSelection();
  }

  Future<void> _showCreateCategorySheet(
    BuildContext context,
    ShoppingListController controller,
  ) async {
    final String? name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) => const _CategoryNameSheet(),
    );

    if (name == null || name.trim().isEmpty) {
      return;
    }

    await controller.createCategory(name);
  }

  Future<void> _showAddItemSheet(
    BuildContext context,
    ShoppingListController controller,
    List<ShoppingListCategory> categories,
    List<Inventory> linkedInventories,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) => _AddItemSheet(
        controller: controller,
        categories: categories,
        linkedInventories: linkedInventories,
      ),
    );
  }

  Future<void> _handleOverflowAction(
    BuildContext context,
    _ListOverflowAction action, {
    required ShoppingList list,
    required ListsController listsController,
    required Set<String> linkedInventoryIds,
  }) async {
    switch (action) {
      case _ListOverflowAction.rename:
        await _showRenameDialog(context, list);
        break;
      case _ListOverflowAction.inventorySettings:
        await _showInventoryPicker(
          context,
          list: list,
          linkedInventoryIds: linkedInventoryIds,
          allowUnlink: true,
        );
        break;
      case _ListOverflowAction.categorySettings:
        final ShoppingListController controller =
            ref.read(shoppingListControllerProvider(widget.listId).notifier);
        await _showCreateCategorySheet(context, controller);
        break;
      case _ListOverflowAction.archive:
        final bool archived = await listsController.archiveList(list);
        if (archived && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Archived "${list.name}"'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: listsController.undoLastAction,
              ),
            ),
          );
        }
        break;
      case _ListOverflowAction.delete:
        await _confirmDelete(context, list, listsController);
        break;
    }
  }

  ShoppingList? _findList(List<ShoppingList> lists, String id) {
    for (final ShoppingList list in lists) {
      if (list.id == id) {
        return list;
      }
    }
    return null;
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    ShoppingList list,
  ) async {
    final String? newName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) =>
          _RenameListSheet(initialValue: list.name),
    );
    if (newName == null || !context.mounted) {
      return;
    }

    final ListsController controller =
        ref.read(listsControllerProvider.notifier);
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

  Future<void> _showInventoryPicker(
    BuildContext context, {
    required ShoppingList list,
    required Set<String> linkedInventoryIds,
    required bool allowUnlink,
  }) async {
    final _InventorySelectionResult? picked =
        await showModalBottomSheet<_InventorySelectionResult>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) => _InventoryPickerSheet(
        linkedInventoryIds: linkedInventoryIds,
        allowUnlink: allowUnlink,
      ),
    );

    if (picked == null) {
      return;
    }

    final ListsController controller =
        ref.read(listsControllerProvider.notifier);
    if (picked.inventoryId == null || picked.shouldLink == null) {
      return;
    }

    if (picked.shouldLink!) {
      await controller.linkToInventory(list, picked.inventoryId!);
      return;
    }

    await controller.unlinkFromInventory(
      list,
      inventoryId: picked.inventoryId!,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ShoppingList list,
    ListsController listsController,
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

    final bool deleted = await listsController.deleteList(list);
    if (!deleted || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${list.name}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: listsController.undoLastAction,
        ),
      ),
    );
  }

  Future<void> _showDraftChoiceDialog(
    BuildContext context,
    ShoppingListController controller,
    ShoppingList list,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Draft found'),
          content: const Text(
            'This list has unsaved draft changes. What do you want to do?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await controller.discardDraft();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Discard draft'),
            ),
            TextButton(
              onPressed: () async {
                await controller.applyDraft(list);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Apply draft'),
            ),
            FilledButton(
              onPressed: () async {
                await controller.continueDraftEditing(list);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Continue editing'),
            ),
          ],
        );
      },
    );
  }
}

enum _ListOverflowAction {
  rename,
  inventorySettings,
  categorySettings,
  archive,
  delete,
}

class _ListMetaRow extends StatelessWidget {
  const _ListMetaRow({
    required this.linkedInventories,
    required this.hasDraft,
    required this.isEditMode,
    required this.isOrganized,
    required this.categoryCount,
    this.onManageLink,
  });

  final List<Inventory> linkedInventories;
  final bool hasDraft;
  final bool isEditMode;
  final bool isOrganized;
  final int categoryCount;
  final VoidCallback? onManageLink;

  @override
  Widget build(BuildContext context) {
    final bool hasAnyMeta =
        linkedInventories.isNotEmpty || hasDraft || isOrganized;

    if (!hasAnyMeta) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: <Widget>[
          if (linkedInventories.isNotEmpty)
            ...linkedInventories.map(
              (Inventory inventory) => ActionChip(
                avatar: const Icon(Icons.inventory_2_outlined),
                label: Text(inventory.name),
                onPressed: onManageLink,
              ),
            ),
          if (isOrganized)
            Chip(
              avatar: const Icon(Icons.category_outlined),
              label: Text('$categoryCount categories'),
            ),
          if (hasDraft)
            Chip(
              avatar: Icon(
                isEditMode ? Icons.edit_note_outlined : Icons.info_outline,
              ),
              label: Text(
                isEditMode ? 'Draft editing enabled' : 'Unsaved draft changes',
              ),
            ),
        ],
      ),
    );
  }
}

class _RenameListSheet extends StatefulWidget {
  const _RenameListSheet({required this.initialValue});

  final String initialValue;

  @override
  State<_RenameListSheet> createState() => _RenameListSheetState();
}

class _RenameListSheetState extends State<_RenameListSheet> {
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
            'Rename list',
            style: Theme.of(context).textTheme.titleMedium,
          ),
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

class _InventorySelectionResult {
  const _InventorySelectionResult({
    required this.inventoryId,
    required this.shouldLink,
  });

  final String? inventoryId;
  final bool? shouldLink;
}

class _InventoryPickerSheet extends ConsumerStatefulWidget {
  const _InventoryPickerSheet({
    required this.linkedInventoryIds,
    required this.allowUnlink,
  });

  final Set<String> linkedInventoryIds;
  final bool allowUnlink;

  @override
  ConsumerState<_InventoryPickerSheet> createState() =>
      _InventoryPickerSheetState();
}

class _InventoryPickerSheetState extends ConsumerState<_InventoryPickerSheet> {
  @override
  Widget build(BuildContext context) {
    final List<Inventory> inventories =
        ref.watch(inventoriesControllerProvider).inventories;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Manage inventory link',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (widget.allowUnlink)
            const ListTile(
              leading: Icon(Icons.link_off_outlined),
              title: Text('No inventory'),
              subtitle: Text('Tap an inventory below to unlink it.'),
            ),
          if (widget.allowUnlink) const Divider(),
          if (inventories.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                'No inventories yet. Create one now or keep this list standalone.',
              ),
            )
          else
            ...inventories.map(
              (Inventory inventory) => ListTile(
                leading: Icon(
                  widget.linkedInventoryIds.contains(inventory.id)
                      ? Icons.check_circle
                      : Icons.inventory_2_outlined,
                ),
                title: Text(inventory.name),
                subtitle: Text(
                  widget.linkedInventoryIds.contains(inventory.id)
                      ? 'Linked'
                      : 'Not linked',
                ),
                onTap: () => Navigator.of(context).pop(
                  _InventorySelectionResult(
                    inventoryId: inventory.id,
                    shouldLink:
                        !widget.linkedInventoryIds.contains(inventory.id),
                  ),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _createInventoryAndLink(context),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Create inventory and link'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createInventoryAndLink(BuildContext context) async {
    final NavigatorState navigator = Navigator.of(context);
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

    navigator.pop(
      _InventorySelectionResult(
        inventoryId: inventoryId,
        shouldLink: true,
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

class _CategoryNameSheet extends StatefulWidget {
  const _CategoryNameSheet();

  @override
  State<_CategoryNameSheet> createState() => _CategoryNameSheetState();
}

class _CategoryNameSheetState extends State<_CategoryNameSheet> {
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
          Text('New category', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Category name',
              hintText: 'Example: Produce',
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: const Text('Create category'),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final String value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }
    Navigator.of(context).pop(value);
  }
}

class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet({
    required this.controller,
    required this.categories,
    required this.linkedInventories,
  });

  final ShoppingListController controller;
  final List<ShoppingListCategory> categories;
  final List<Inventory> linkedInventories;

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  String? _unitCode;
  String? _selectedInventoryId;
  String? _selectedCategoryId;
  bool _categoryTouchedByUser = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> units = Unit.supportedCodes.toList(growable: false)
      ..sort();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: KeyboardAwareScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Add item', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _nameController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Item name',
                hintText: 'Example: Milk',
              ),
              onChanged: _updateSuggestedCategory,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _quantityController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Quantity (optional)',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String?>(
              initialValue: _selectedInventoryId,
              decoration:
                  const InputDecoration(labelText: 'Inventory (optional)'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('None'),
                ),
                ...widget.linkedInventories.map(
                  (Inventory inventory) => DropdownMenuItem<String?>(
                    value: inventory.id,
                    child: Text(inventory.name),
                  ),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _selectedInventoryId = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String?>(
              initialValue: _unitCode,
              decoration: const InputDecoration(labelText: 'Unit (optional)'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('No unit'),
                ),
                ...units.map(
                  (String value) => DropdownMenuItem<String?>(
                    value: value,
                    child: Text(value),
                  ),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _unitCode = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String?>(
              initialValue: _selectedCategoryId,
              decoration: const InputDecoration(labelText: 'Category (optional)'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Auto / none'),
                ),
                ...widget.categories.map(
                  (ShoppingListCategory option) => DropdownMenuItem<String?>(
                    value: option.categoryId,
                    child: Text(option.categoryName ?? option.categoryId),
                  ),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _categoryTouchedByUser = true;
                  _selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Save item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateSuggestedCategory(String value) async {
    if (_categoryTouchedByUser) {
      return;
    }
    final String? suggestion =
        await widget.controller.suggestCategoryForInput(value);
    if (!mounted || suggestion == null) {
      return;
    }
    final bool exists = widget.categories.any(
      (ShoppingListCategory option) => option.categoryId == suggestion,
    );
    if (!exists) {
      return;
    }
    setState(() {
      _selectedCategoryId = suggestion;
    });
  }

  Future<void> _submit() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }
    final String rawQty = _quantityController.text.trim();
    final double? quantity = rawQty.isEmpty ? null : double.tryParse(rawQty);

    final bool saved = await widget.controller.addItemWithDetails(
      name: name,
      quantity: quantity,
      unitCode: _unitCode,
      targetInventoryId: _selectedInventoryId,
      categoryId: _selectedCategoryId,
    );
    if (saved && mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _OrganizedItemsView extends StatelessWidget {
  const _OrganizedItemsView({
    required this.state,
    required this.controller,
    required this.categories,
    required this.selectedItemIds,
    required this.onToggleSelection,
    required this.onShowUndo,
  });

  final ShoppingListState state;
  final ShoppingListController controller;
  final List<ShoppingListCategory> categories;
  final Set<String> selectedItemIds;
  final ValueChanged<String> onToggleSelection;
  final void Function(String message, VoidCallback onUndo) onShowUndo;

  @override
  Widget build(BuildContext context) {
    final List<ShoppingListItem> allItems = <ShoppingListItem>[
      ...state.pendingItems,
      ...state.skippedItems,
      ...state.purchasedItems,
    ];
    final Map<String, List<ShoppingListItem>> grouped =
        <String, List<ShoppingListItem>>{};
    final Map<String, String> labelByCategoryId = <String, String>{
      for (final ShoppingListCategory c in categories)
        c.categoryId: c.categoryName ?? c.categoryId,
    };

    for (final ShoppingListItem item in allItems) {
      final String key = item.categoryId ?? '__uncategorized__';
      grouped.putIfAbsent(key, () => <ShoppingListItem>[]).add(item);
    }

    final List<String> orderedKeys = <String>[
      ...categories.map((ShoppingListCategory c) => c.categoryId),
      ...grouped.keys.where(
        (String key) => !categories.any(
          (ShoppingListCategory c) => c.categoryId == key,
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: orderedKeys
          .where((String key) =>
              (grouped[key] ?? const <ShoppingListItem>[]).isNotEmpty)
          .map(
        (String key) {
          final List<ShoppingListItem> items = grouped[key]!;
          final String title = key == '__uncategorized__'
              ? 'Uncategorized'
              : (labelByCategoryId[key] ?? 'Uncategorized');

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionHeader(title: title),
                const SizedBox(height: AppSpacing.xs),
                ...items.map(
                  (ShoppingListItem item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: _MinimalItemRow(
                      item: item,
                      controller: controller,
                      selected: selectedItemIds.contains(item.id),
                      selectionMode: selectedItemIds.isNotEmpty,
                      onToggleSelection: () => onToggleSelection(item.id),
                      onShowUndo: onShowUndo,
                      onDoubleTap: () async {
                        final bool purchased =
                            await controller.markPurchased(item);
                        if (purchased) {
                          onShowUndo(
                            'Marked "${item.rawText}" as purchased',
                            controller.undoLastAction,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(growable: false),
    );
  }
}

class _FlatItemsView extends StatelessWidget {
  const _FlatItemsView({
    required this.state,
    required this.controller,
    required this.selectedItemIds,
    required this.onToggleSelection,
    required this.onShowUndo,
  });

  final ShoppingListState state;
  final ShoppingListController controller;
  final Set<String> selectedItemIds;
  final ValueChanged<String> onToggleSelection;
  final void Function(String message, VoidCallback onUndo) onShowUndo;

  @override
  Widget build(BuildContext context) {
    final List<ShoppingListItem> allItems = <ShoppingListItem>[
      ...state.pendingItems,
      ...state.skippedItems,
      ...state.purchasedItems,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: allItems
          .map(
            (ShoppingListItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _MinimalItemRow(
                item: item,
                controller: controller,
                selected: selectedItemIds.contains(item.id),
                selectionMode: selectedItemIds.isNotEmpty,
                onToggleSelection: () => onToggleSelection(item.id),
                onShowUndo: onShowUndo,
                onDoubleTap: () async {
                  final bool purchased = await controller.markPurchased(item);
                  if (purchased && context.mounted) {
                    onShowUndo(
                      'Marked "${item.rawText}" as purchased',
                      controller.undoLastAction,
                    );
                  }
                },
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _MinimalItemRow extends StatelessWidget {
  const _MinimalItemRow({
    required this.item,
    required this.controller,
    required this.selected,
    required this.selectionMode,
    required this.onToggleSelection,
    required this.onShowUndo,
    this.onDoubleTap,
  });

  final ShoppingListItem item;
  final ShoppingListController controller;
  final bool selected;
  final bool selectionMode;
  final VoidCallback onToggleSelection;
  final void Function(String message, VoidCallback onUndo) onShowUndo;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Theme.of(context).colorScheme.secondaryContainer
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onLongPress: onToggleSelection,
        onTap: selectionMode ? onToggleSelection : null,
        onDoubleTap: onDoubleTap,
        child: Dismissible(
          key: ValueKey<String>('row-${item.id}'),
          direction: item.status == ShoppingListItemStatus.pending
              ? DismissDirection.startToEnd
              : DismissDirection.none,
          confirmDismiss: (_) async {
            final bool skipped = await controller.markSkipped(item);
            if (skipped && context.mounted) {
              onShowUndo(
                'Marked "${item.rawText}" as skipped',
                controller.undoLastAction,
              );
            }
            return false;
          },
          background: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.report_gmailerrorred_outlined),
          ),
          child: AppListTile(
            title: item.rawText,
            subtitle: _subtitleFromItem(item),
            leading: Icon(
              selected
                  ? Icons.check_circle
                  : (item.productId == null
                      ? Icons.edit_note
                      : Icons.inventory_2_outlined),
            ),
            trailing: Text(item.status.name),
          ),
        ),
      ),
    );
  }
}

String _subtitleFromItem(ShoppingListItem item) {
  final String quantityText = item.quantity == null
      ? 'Qty -'
      : (item.quantity! % 1 == 0
          ? item.quantity!.toInt().toString()
          : item.quantity!.toString());
  final String unitText = item.unit?.code ?? 'unit';
  return '$quantityText $unitText';
}

class _SelectionActionBar extends StatelessWidget {
  const _SelectionActionBar({
    required this.selectedCount,
    required this.onClearSelection,
    required this.onMarkPurchased,
    required this.onMarkSkipped,
    required this.onDelete,
  });

  final int selectedCount;
  final VoidCallback onClearSelection;
  final VoidCallback onMarkPurchased;
  final VoidCallback onMarkSkipped;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: <Widget>[
            Text('$selectedCount selected'),
            const Spacer(),
            IconButton(
              tooltip: 'Mark purchased',
              onPressed: onMarkPurchased,
              icon: const Icon(Icons.check_circle_outline),
            ),
            IconButton(
              tooltip: 'Mark skipped',
              onPressed: onMarkSkipped,
              icon: const Icon(Icons.report_gmailerrorred_outlined),
            ),
            IconButton(
              tooltip: 'Delete',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              tooltip: 'Clear selection',
              onPressed: onClearSelection,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
