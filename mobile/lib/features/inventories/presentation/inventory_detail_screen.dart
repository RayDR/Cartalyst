import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/keyboard_aware_scroll_view.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_state.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_category.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/domain/entities/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryDetailScreen extends ConsumerWidget {
  const InventoryDetailScreen({required this.inventoryId, super.key});

  final String inventoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InventoriesState inventoriesState =
        ref.watch(inventoriesControllerProvider);
    final InventoryDetailState state =
        ref.watch(inventoryDetailControllerProvider(inventoryId));
    final InventoryDetailController controller =
        ref.read(inventoryDetailControllerProvider(inventoryId).notifier);
    final List<ShoppingList> linkedLists =
        ref.watch(linkedListsForInventoryProvider(inventoryId)).valueOrNull ??
            const <ShoppingList>[];

    return AppScaffold(
      title: _findInventoryName(inventoriesState, inventoryId),
      trailing: PopupMenuButton<_InventoryOverflowAction>(
        onSelected: (_InventoryOverflowAction action) {
          if (action == _InventoryOverflowAction.linkedLists) {
            _showLinkedListsSheet(context, linkedLists);
          }
        },
        itemBuilder: (_) => const <PopupMenuEntry<_InventoryOverflowAction>>[
          PopupMenuItem<_InventoryOverflowAction>(
            value: _InventoryOverflowAction.linkedLists,
            child: ListTile(
              leading: Icon(Icons.link_outlined),
              title: Text('Linked lists'),
            ),
          ),
        ],
      ),
      child: KeyboardAwareScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _InventoryActionsBar(
              onAddItem: () => _showAddItemSheet(context, controller, state),
              onAddCategory: () => _showAddCategorySheet(context, controller),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (state.message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  child: AppListTile(
                    leading: const Icon(Icons.info_outline),
                    title: state.message!,
                  ),
                ),
              ),
            if (state.hasAnyItems)
              _CategorizedItemSections(
                state: state,
                inventoryId: inventoryId,
              )
            else
              EmptyState(
                title: 'No items yet',
                description: 'Add your first item to this inventory.',
                icon: Icons.inventory_2_outlined,
                primaryActionLabel: 'Add item',
                onPrimaryActionPressed: () => _showAddItemSheet(
                  context,
                  controller,
                  state,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _findInventoryName(InventoriesState state, String inventoryId) {
    for (final inventory in state.inventories) {
      if (inventory.id == inventoryId) {
        return inventory.name;
      }
    }
    return 'Inventory';
  }

  static Future<void> _showAddCategorySheet(
    BuildContext context,
    InventoryDetailController controller,
  ) async {
    final String? name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const _CategoryNameSheet(),
    );
    if (name == null || name.trim().isEmpty) {
      return;
    }

    await controller.createCategory(name);
  }

  static Future<void> _showAddItemSheet(
    BuildContext context,
    InventoryDetailController controller,
    InventoryDetailState state,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => _AddItemSheet(controller: controller, state: state),
    );
  }

  static Future<void> _showLinkedListsSheet(
    BuildContext context,
    List<ShoppingList> linkedLists,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Linked lists',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            if (linkedLists.isEmpty)
              const Text('No linked lists yet.')
            else
              ...linkedLists.map(
                (ShoppingList list) => ListTile(
                  leading: const Icon(Icons.shopping_cart_outlined),
                  title: Text(list.name),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _InventoryOverflowAction { linkedLists }

class _InventoryActionsBar extends StatelessWidget {
  const _InventoryActionsBar(
      {required this.onAddItem, required this.onAddCategory});

  final VoidCallback onAddItem;
  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FilledButton.tonalIcon(
          onPressed: onAddItem,
          icon: const Icon(Icons.add),
          label: const Text('+ Item'),
        ),
        const SizedBox(width: AppSpacing.xs),
        FilledButton.tonalIcon(
          onPressed: onAddCategory,
          icon: const Icon(Icons.playlist_add),
          label: const Text('+ Category'),
        ),
      ],
    );
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
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Category name'),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.sm),
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
    final String name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }
    Navigator.of(context).pop(name);
  }
}

class _AddItemSheet extends StatefulWidget {
  const _AddItemSheet({required this.controller, required this.state});

  final InventoryDetailController controller;
  final InventoryDetailState state;

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  String? _unitCode;
  String? _selectedProductId;
  String? _selectedCategoryId;
  bool _categoryTouched = false;

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
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _nameController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Item name'),
              onChanged: _handleNameChanged,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _quantityController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration:
                  const InputDecoration(labelText: 'Quantity (optional)'),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String?>(
              initialValue: _unitCode,
              decoration: const InputDecoration(labelText: 'Unit (optional)'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                    value: null, child: Text('No unit')),
                ...units.map(
                  (String unit) => DropdownMenuItem<String?>(
                    value: unit,
                    child: Text(unit),
                  ),
                ),
              ],
              onChanged: (String? value) => setState(() => _unitCode = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String?>(
              initialValue: _selectedProductId,
              decoration:
                  const InputDecoration(labelText: 'Product link (optional)'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                    value: null, child: Text('No product link')),
                ...widget.state.products
                    .where(
                      (product) => _nameController.text.trim().isEmpty
                          ? false
                          : product.canonicalName.toLowerCase().contains(
                              _nameController.text.trim().toLowerCase()),
                    )
                    .take(8)
                    .map(
                      (product) => DropdownMenuItem<String?>(
                        value: product.id,
                        child: Text(product.canonicalName),
                      ),
                    ),
              ],
              onChanged: (String? value) =>
                  setState(() => _selectedProductId = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String?>(
              initialValue: _selectedCategoryId,
              decoration:
                  const InputDecoration(labelText: 'Category (optional)'),
              items: <DropdownMenuItem<String?>>[
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Auto (fallback Uncategorized)'),
                ),
                ...widget.state.categories.map(
                  (InventoryCategory category) => DropdownMenuItem<String?>(
                    value: category.id,
                    child: Text(category.name),
                  ),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _categoryTouched = true;
                  _selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: const Text('Save item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNameChanged(String value) async {
    if (_categoryTouched) {
      return;
    }
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final String suggested = await widget.controller.suggestCategoryForName(
      trimmed,
      productId: _selectedProductId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedCategoryId = suggested;
    });
  }

  Future<void> _save() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }

    final String rawQty = _quantityController.text.trim();
    final double? quantity = rawQty.isEmpty ? null : double.tryParse(rawQty);

    await widget.controller.addItemWithDetails(
      name: name,
      quantity: quantity,
      unitCode: _unitCode,
      productId: _selectedProductId,
      inventoryCategoryId: _selectedCategoryId,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _CategorizedItemSections extends ConsumerWidget {
  const _CategorizedItemSections(
      {required this.state, required this.inventoryId});

  final InventoryDetailState state;
  final String inventoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InventoryDetailController controller =
        ref.read(inventoryDetailControllerProvider(inventoryId).notifier);
    final List<InventoryItem> items = <InventoryItem>[
      ...state.inStockItems,
      ...state.lowItems,
      ...state.finishedItems,
    ];
    final Map<String, List<InventoryItem>> byCategory =
        <String, List<InventoryItem>>{};

    for (final InventoryItem item in items) {
      final String key = item.inventoryCategoryId ?? '__uncategorized__';
      byCategory.putIfAbsent(key, () => <InventoryItem>[]).add(item);
    }

    final Map<String, String> nameById = <String, String>{
      for (final InventoryCategory category in state.categories)
        category.id: category.name,
    };
    final List<String> ordered = <String>[
      ...state.categories.map((InventoryCategory category) => category.id),
      ...byCategory.keys.where(
        (String id) =>
            !state.categories.any((InventoryCategory c) => c.id == id),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ordered
          .where((String key) =>
              (byCategory[key] ?? const <InventoryItem>[]).isNotEmpty)
          .map(
            (String key) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SectionHeader(
                    title: key == '__uncategorized__'
                        ? 'Uncategorized'
                        : (nameById[key] ?? 'Uncategorized'),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ...byCategory[key]!.map(
                    (InventoryItem item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: _InventoryItemCard(
                        item: item,
                        categories: state.categories,
                        controller: controller,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _InventoryItemCard extends StatelessWidget {
  const _InventoryItemCard({
    required this.item,
    required this.categories,
    required this.controller,
  });

  final InventoryItem item;
  final List<InventoryCategory> categories;
  final InventoryDetailController controller;

  @override
  Widget build(BuildContext context) {
    final String title = item.rawName ?? item.productId ?? 'Unnamed item';
    final String subtitle = item.quantityEstimated == null
        ? 'Qty -'
        : 'Qty ${item.quantityEstimated} ${item.unit?.code ?? ''}'.trim();

    return AppCard(
      child: AppListTile(
        title: title,
        subtitle: subtitle,
        trailing: PopupMenuButton<String>(
          onSelected: (String action) async {
            if (action == 'in_stock') {
              await controller.markInStock(item);
            } else if (action == 'low') {
              await controller.markRunningLow(item);
            } else if (action == 'out') {
              await controller.markFinished(item);
            } else if (action == 'move') {
              await _showMoveCategorySheet(context);
            } else if (action == 'delete') {
              await controller.softDelete(item);
            }
          },
          itemBuilder: (_) => const <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
                value: 'in_stock', child: Text('Mark in stock')),
            PopupMenuItem<String>(
                value: 'low', child: Text('Mark running low')),
            PopupMenuItem<String>(value: 'out', child: Text('Mark finished')),
            PopupMenuItem<String>(value: 'move', child: Text('Move category')),
            PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
          ],
        ),
        leading: StatusChip(
          label: _statusLabel(item.status),
          tone: _statusTone(item.status),
        ),
      ),
    );
  }

  Future<void> _showMoveCategorySheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Move to category',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...categories.map(
              (InventoryCategory category) => ListTile(
                title: Text(category.name),
                onTap: () async {
                  await controller.assignItemToCategory(
                    item: item,
                    inventoryCategoryId: category.id,
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(InventoryItemStatus status) {
    return switch (status) {
      InventoryItemStatus.inStock => 'In stock',
      InventoryItemStatus.low => 'Low',
      InventoryItemStatus.out => 'Finished',
      InventoryItemStatus.unknown => 'Unknown',
    };
  }

  StatusChipTone _statusTone(InventoryItemStatus status) {
    return switch (status) {
      InventoryItemStatus.inStock => StatusChipTone.success,
      InventoryItemStatus.low => StatusChipTone.warning,
      InventoryItemStatus.out => StatusChipTone.neutral,
      InventoryItemStatus.unknown => StatusChipTone.neutral,
    };
  }
}
