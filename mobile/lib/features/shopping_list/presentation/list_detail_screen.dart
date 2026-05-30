import 'package:cartalyst_mobile/core/design/app_radius.dart';
import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/core/widgets/app_button.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_text_field.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/keyboard_aware_scroll_view.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/shopping_list_state.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListDetailScreen extends ConsumerStatefulWidget {
  const ListDetailScreen({required this.listId, super.key});

  final String listId;

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen> {
  late final TextEditingController _quickAddController;
  bool _draftDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _quickAddController = TextEditingController();
  }

  @override
  void dispose() {
    _quickAddController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ListsState listsState = ref.watch(listsControllerProvider);
    final ShoppingList? currentList =
        _findList(listsState.lists, widget.listId);
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

    if (_quickAddController.text != state.quickAddInput) {
      _quickAddController.value = TextEditingValue(
        text: state.quickAddInput,
        selection: TextSelection.collapsed(offset: state.quickAddInput.length),
      );
    }

    final String listTitle = state.isEditMode
        ? (state.draftName ?? currentList?.name ?? 'Shopping List')
        : (currentList?.name ?? 'Shopping List');

    return Scaffold(
      appBar: AppBar(
        title: currentList == null
            ? Text(listTitle)
            : InkWell(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                onTap: () => _showRenameDialog(context, currentList),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xxs,
                    horizontal: AppSpacing.xs,
                  ),
                  child: Text(listTitle),
                ),
              ),
        actions: <Widget>[
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
                    title: Text('Rename list'),
                  ),
                ),
                const PopupMenuItem<_ListOverflowAction>(
                  value: _ListOverflowAction.link,
                  child: ListTile(
                    leading: Icon(Icons.link_outlined),
                    title: Text('Link inventories'),
                  ),
                ),
                PopupMenuItem<_ListOverflowAction>(
                  value: _ListOverflowAction.manageLink,
                  enabled: linkedInventories.isNotEmpty,
                  child: const ListTile(
                    leading: Icon(Icons.tune_outlined),
                    title: Text('Manage linked inventories'),
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: KeyboardAwareScrollView(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (currentList != null)
                  _ListMetaRow(
                    linkedInventories: linkedInventories,
                    hasDraft: state.hasDraft,
                    isEditMode: state.isEditMode,
                    onManageLink: () => _showInventoryPicker(
                      context,
                      list: currentList,
                      linkedInventoryIds: linkedInventories
                          .map((Inventory inventory) => inventory.id)
                          .toSet(),
                      allowUnlink: linkedInventories.isNotEmpty,
                    ),
                  ),
                const SectionHeader(
                  title: 'Quick product add',
                  subtitle: 'Type once, pick a suggestion, and keep moving.',
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Quick add',
                  hint: 'Try: 2 milk, huevos 18, paper towels 12 pack',
                  prefixIcon: Icons.search,
                  controller: _quickAddController,
                  onChanged: controller.updateQuickAddInput,
                  textInputAction: TextInputAction.done,
                ),
                if (state.suggestions.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.suggestions
                          .map(
                            (suggestion) => Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.xs,
                              ),
                              child: ActionChip(
                                avatar: const Icon(Icons.local_offer_outlined),
                                label: Text(
                                  suggestion.suggestedProduct!.canonicalName,
                                ),
                                onPressed: () => controller.addFromQuickAdd(
                                  selectedSuggestion: suggestion,
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AppButton(
                        label: 'Add best match',
                        onPressed:
                            state.isBusy ? null : controller.addFromQuickAdd,
                        icon: Icons.playlist_add_check_circle_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        label: 'Add custom',
                        onPressed:
                            state.isBusy ? null : controller.addCustomItem,
                        icon: Icons.edit_note_outlined,
                        variant: AppButtonVariant.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile.adaptive(
                  title: const Text('One-handed shopping mode'),
                  subtitle: const Text(
                    'Shows large bottom actions for the selected item.',
                  ),
                  value: state.shoppingModeEnabled,
                  onChanged: controller.setShoppingModeEnabled,
                ),
                if (state.errorMessage != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  AppCard(
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.error_outline),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(child: Text(state.errorMessage!)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                if (state.hasItems)
                  _ItemsView(
                    state: state,
                    controller: controller,
                    isEditMode: state.isEditMode,
                  )
                else
                  EmptyState(
                    title: 'This list is empty',
                    description: 'Use Quick Add to build your list in seconds.',
                    icon: Icons.shopping_cart_outlined,
                    primaryActionLabel: 'Add custom item',
                    onPrimaryActionPressed: controller.addCustomItem,
                  ),
                if (state.shoppingModeEnabled &&
                    state.focusedItem != null) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  _ShoppingModeBar(
                    item: state.focusedItem!,
                    controller: controller,
                  ),
                ],
              ],
            ),
          ),
        ),
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
      case _ListOverflowAction.link:
        await _showInventoryPicker(
          context,
          list: list,
          linkedInventoryIds: linkedInventoryIds,
          allowUnlink: false,
        );
        break;
      case _ListOverflowAction.manageLink:
        await _showInventoryPicker(
          context,
          list: list,
          linkedInventoryIds: linkedInventoryIds,
          allowUnlink: true,
        );
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
  link,
  manageLink,
  archive,
  delete,
}

class _ListMetaRow extends StatelessWidget {
  const _ListMetaRow({
    required this.linkedInventories,
    required this.hasDraft,
    required this.isEditMode,
    required this.onManageLink,
  });

  final List<Inventory> linkedInventories;
  final bool hasDraft;
  final bool isEditMode;
  final VoidCallback onManageLink;

  @override
  Widget build(BuildContext context) {
    final bool isLinked = linkedInventories.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: <Widget>[
          if (!isLinked)
            ActionChip(
              avatar: const Icon(Icons.link_outlined),
              label: const Text('No inventory linked'),
              onPressed: onManageLink,
            )
          else
            ...linkedInventories.map(
              (Inventory inventory) => ActionChip(
                avatar: const Icon(Icons.inventory_2_outlined),
                label: Text(inventory.name),
                onPressed: onManageLink,
              ),
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
              leading: const Icon(Icons.link_off_outlined),
              title: const Text('No inventory'),
              subtitle: const Text('Tap an inventory below to unlink it.'),
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

class _ItemsView extends StatelessWidget {
  const _ItemsView({
    required this.state,
    required this.controller,
    required this.isEditMode,
  });

  final ShoppingListState state;
  final ShoppingListController controller;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    void showUndo(String message, VoidCallback onUndo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(label: 'Undo', onPressed: onUndo),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (state.pendingItems.isNotEmpty) ...<Widget>[
          const SectionHeader(
            title: 'Pending',
            subtitle: 'Items to find first.',
          ),
          const SizedBox(height: AppSpacing.sm),
          ...state.pendingItems.map(
            (ShoppingListItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Dismissible(
                key: ValueKey<String>(item.id),
                direction: DismissDirection.startToEnd,
                background: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.report_gmailerrorred_outlined),
                ),
                confirmDismiss: (_) async => true,
                onDismissed: (_) async {
                  final bool skipped = await controller.markSkipped(item);
                  if (skipped && context.mounted && !isEditMode) {
                    showUndo(
                      'Marked "${item.rawText}" as skipped',
                      controller.undoLastAction,
                    );
                  }
                },
                child: _ItemCard(
                  item: item,
                  controller: controller,
                  statusTone: StatusChipTone.neutral,
                  statusLabel: 'Pending',
                  onDoubleTap: () async {
                    final bool purchased = await controller.markPurchased(item);
                    if (purchased && context.mounted && !isEditMode) {
                      showUndo(
                        'Marked "${item.rawText}" as purchased',
                        controller.undoLastAction,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (state.skippedItems.isNotEmpty) ...<Widget>[
          const SectionHeader(
            title: 'Skipped / Not Found',
            subtitle: 'Items you can revisit later.',
          ),
          const SizedBox(height: AppSpacing.sm),
          ...state.skippedItems.map(
            (ShoppingListItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ItemCard(
                item: item,
                controller: controller,
                statusTone: StatusChipTone.warning,
                statusLabel: 'Skipped',
                isHighlighted: true,
                onDoubleTap: () async {
                  final bool purchased = await controller.markPurchased(item);
                  if (purchased && context.mounted && !isEditMode) {
                    showUndo(
                      'Marked "${item.rawText}" as purchased',
                      controller.undoLastAction,
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (state.purchasedItems.isNotEmpty)
          AppCard(
            child: ExpansionTile(
              initiallyExpanded: !state.purchasedCollapsed,
              onExpansionChanged: (bool expanded) {
                controller.setPurchasedCollapsed(!expanded);
              },
              title: Text('Purchased (${state.purchasedItems.length})'),
              children: state.purchasedItems
                  .map(
                    (ShoppingListItem item) => Padding(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.sm,
                        right: AppSpacing.sm,
                        bottom: AppSpacing.sm,
                      ),
                      child: _ItemCard(
                        item: item,
                        controller: controller,
                        statusTone: StatusChipTone.success,
                        statusLabel: 'Purchased',
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.controller,
    required this.statusTone,
    required this.statusLabel,
    this.onDoubleTap,
    this.isHighlighted = false,
  });

  final ShoppingListItem item;
  final ShoppingListController controller;
  final StatusChipTone statusTone;
  final String statusLabel;
  final VoidCallback? onDoubleTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final String subtitle = _subtitleFromItem(item);

    return AppCard(
      onDoubleTap: onDoubleTap,
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted ? colors.secondaryContainer : null,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          children: <Widget>[
            AppListTile(
              title: item.rawText,
              subtitle: subtitle,
              leading: Icon(
                item.productId == null
                    ? Icons.edit_note
                    : Icons.inventory_2_outlined,
              ),
              trailing: StatusChip(label: statusLabel, tone: statusTone),
              onTap: () => controller.setFocusedItem(item.id),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: _buildActions(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final List<Widget> actions = <Widget>[
      _ActionButton(
        label: 'Edit',
        icon: Icons.edit_outlined,
        onPressed: () => _showEditDialog(context),
      ),
      _ActionButton(
        label: 'Delete',
        icon: Icons.delete_outline,
        onPressed: () => controller.softDelete(item),
      ),
    ];

    if (item.status == ShoppingListItemStatus.pending) {
      actions.insert(
        0,
        _ActionButton(
          label: 'Purchased',
          icon: Icons.check_circle_outline,
          onPressed: () => controller.markPurchased(item),
        ),
      );
      actions.insert(
        1,
        _ActionButton(
          label: 'Skip',
          icon: Icons.report_gmailerrorred_outlined,
          onPressed: () => controller.markSkipped(item),
        ),
      );
    } else {
      actions.insert(
        0,
        _ActionButton(
          label: 'Restore',
          icon: Icons.undo,
          onPressed: () => controller.restorePending(item),
        ),
      );
    }

    return actions;
  }

  Future<void> _showEditDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) =>
          _EditItemSheet(item: item, controller: controller),
    );
  }

  String _subtitleFromItem(ShoppingListItem item) {
    final String quantityText = item.quantity == null
        ? 'Qty not set'
        : (item.quantity! % 1 == 0
            ? item.quantity!.toInt().toString()
            : item.quantity!.toString());
    final String unitText = item.unit?.code ?? 'unit';
    return '$quantityText $unitText';
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(
        minimumSize: const Size(120, AppSpacing.xxl),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _EditItemSheet extends StatefulWidget {
  const _EditItemSheet({
    required this.item,
    required this.controller,
  });

  final ShoppingListItem item;
  final ShoppingListController controller;

  @override
  State<_EditItemSheet> createState() => _EditItemSheetState();
}

class _EditItemSheetState extends State<_EditItemSheet> {
  late final TextEditingController _quantityController;
  late String? _unitCode;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity == null ? '' : widget.item.quantity.toString(),
    );
    _unitCode = widget.item.unit?.code;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> units = Unit.supportedCodes.toList(growable: false)
      ..sort();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Edit quantity and unit',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _quantityController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Quantity',
              hintText: 'Example: 2 or 1.5',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _unitCode,
            items: units
                .map(
                  (String unit) => DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  ),
                )
                .toList(growable: false),
            onChanged: (String? value) {
              setState(() {
                _unitCode = value;
              });
            },
            decoration: const InputDecoration(labelText: 'Unit'),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Save changes',
            onPressed: () async {
              final String raw = _quantityController.text.trim();
              final double? quantity =
                  raw.isEmpty ? null : double.tryParse(raw);
              await widget.controller.updateItemQuantityAndUnit(
                item: widget.item,
                quantity: quantity,
                unitCode: _unitCode,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: Icons.save_outlined,
          ),
        ],
      ),
    );
  }
}

class _ShoppingModeBar extends StatelessWidget {
  const _ShoppingModeBar({required this.item, required this.controller});

  final ShoppingListItem item;
  final ShoppingListController controller;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Shopping mode: ${item.rawText}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: AppButton(
                  label: 'Purchased',
                  onPressed: () => controller.markPurchased(item),
                  icon: Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: AppButton(
                  label: item.status == ShoppingListItemStatus.pending
                      ? 'Skip'
                      : 'Restore',
                  onPressed: () => item.status == ShoppingListItemStatus.pending
                      ? controller.markSkipped(item)
                      : controller.restorePending(item),
                  icon: item.status == ShoppingListItemStatus.pending
                      ? Icons.report_gmailerrorred_outlined
                      : Icons.undo,
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
