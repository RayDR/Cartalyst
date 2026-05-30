import 'package:cartalyst_mobile/core/design/app_radius.dart';
import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/core/widgets/app_button.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/app_text_field.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
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

    final ShoppingListState state =
        ref.watch(shoppingListControllerProvider(widget.listId));
    final ShoppingListController controller =
        ref.read(shoppingListControllerProvider(widget.listId).notifier);

    if (_quickAddController.text != state.quickAddInput) {
      _quickAddController.value = TextEditingValue(
        text: state.quickAddInput,
        selection: TextSelection.collapsed(offset: state.quickAddInput.length),
      );
    }

    return AppScaffold(
      title: currentList?.name ?? 'Shopping List',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (currentList != null) _InventoryLinkCard(list: currentList),
          const SectionHeader(
            title: 'Quick product add',
            subtitle: 'Type once, pick a suggestion, and keep moving.',
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Product',
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
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: ActionChip(
                          avatar: const Icon(Icons.local_offer_outlined),
                          label:
                              Text(suggestion.suggestedProduct!.canonicalName),
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
                  onPressed: state.isBusy ? null : controller.addFromQuickAdd,
                  icon: Icons.playlist_add_check_circle_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: 'Add custom',
                  onPressed: state.isBusy ? null : controller.addCustomItem,
                  icon: Icons.edit_note_outlined,
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile.adaptive(
            title: const Text('One-handed shopping mode'),
            subtitle:
                const Text('Shows large bottom actions for the selected item.'),
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
          Expanded(
            child: state.hasItems
                ? _ItemsView(state: state, controller: controller)
                : EmptyState(
                    title: 'This list is empty',
                    description: 'Use Quick Add to build your list in seconds.',
                    icon: Icons.shopping_cart_outlined,
                    primaryActionLabel: 'Add custom item',
                    onPrimaryActionPressed: controller.addCustomItem,
                  ),
          ),
          if (state.shoppingModeEnabled &&
              state.focusedItem != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            _ShoppingModeBar(item: state.focusedItem!, controller: controller),
          ],
        ],
      ),
    );
  }

  ShoppingList? _findList(List<ShoppingList> lists, String id) {
    for (final ShoppingList list in lists) {
      if (list.id == id) {
        return list;
      }
    }
    return null;
  }
}

class _InventoryLinkCard extends ConsumerWidget {
  const _InventoryLinkCard({required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Inventory> inventories =
        ref.watch(inventoriesControllerProvider).inventories;
    final Inventory? linkedInventory = list.inventoryId == null
        ? null
        : _findInventory(inventories, list.inventoryId!);
    final bool hasLinkedInventory = list.inventoryId != null;
    final String title = hasLinkedInventory
        ? linkedInventory?.name ?? 'Linked inventory'
        : 'No inventory linked yet';
    final String description = hasLinkedInventory
        ? 'You can change or remove this link later.'
        : 'Link this list to an inventory to keep shopping decisions grounded in what you already have.';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  hasLinkedInventory
                      ? Icons.inventory_2_outlined
                      : Icons.link_outlined,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                TextButton(
                  onPressed: () => _showInventoryPicker(
                    context,
                    ref,
                    selectedInventoryId: list.inventoryId,
                    allowUnlink: hasLinkedInventory,
                  ),
                  child: Text(
                    hasLinkedInventory ? 'Change link' : 'Link inventory',
                  ),
                ),
                if (hasLinkedInventory)
                  TextButton(
                    onPressed: () => ref
                        .read(listsControllerProvider.notifier)
                        .unlinkFromInventory(list),
                    child: const Text('Remove link'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showInventoryPicker(
    BuildContext context,
    WidgetRef ref, {
    required String? selectedInventoryId,
    required bool allowUnlink,
  }) async {
    final _InventorySelectionResult? picked =
        await showModalBottomSheet<_InventorySelectionResult>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) => _InventoryPickerSheet(
        selectedInventoryId: selectedInventoryId,
        allowUnlink: allowUnlink,
      ),
    );

    if (picked == null) {
      return;
    }

    final ListsController controller =
        ref.read(listsControllerProvider.notifier);
    if (picked.inventoryId == null) {
      await controller.unlinkFromInventory(list);
      return;
    }

    await controller.linkToInventory(list, picked.inventoryId!);
  }

  Inventory? _findInventory(List<Inventory> inventories, String id) {
    for (final Inventory inventory in inventories) {
      if (inventory.id == id) {
        return inventory;
      }
    }
    return null;
  }
}

class _InventorySelectionResult {
  const _InventorySelectionResult({required this.inventoryId});

  final String? inventoryId;
}

class _InventoryPickerSheet extends ConsumerStatefulWidget {
  const _InventoryPickerSheet({
    required this.selectedInventoryId,
    required this.allowUnlink,
  });

  final String? selectedInventoryId;
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
            ListTile(
              leading: const Icon(Icons.link_off_outlined),
              title: const Text('No inventory'),
              subtitle: const Text('Keep this list standalone.'),
              onTap: () => Navigator.of(context).pop(
                const _InventorySelectionResult(inventoryId: null),
              ),
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
                  widget.selectedInventoryId == inventory.id
                      ? Icons.radio_button_checked
                      : Icons.inventory_2_outlined,
                ),
                title: Text(inventory.name),
                onTap: () => Navigator.of(context).pop(
                  _InventorySelectionResult(inventoryId: inventory.id),
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
      _InventorySelectionResult(inventoryId: inventoryId),
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
  const _ItemsView({required this.state, required this.controller});

  final ShoppingListState state;
  final ShoppingListController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
              child: _ItemCard(
                item: item,
                controller: controller,
                statusTone: StatusChipTone.neutral,
                statusLabel: 'Pending',
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
    this.isHighlighted = false,
  });

  final ShoppingListItem item;
  final ShoppingListController controller;
  final StatusChipTone statusTone;
  final String statusLabel;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final String subtitle = _subtitleFromItem(item);

    return AppCard(
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
