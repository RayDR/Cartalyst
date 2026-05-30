import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/domain/value_objects/unit.dart';
import 'package:cartalyst_mobile/core/widgets/app_button.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/app_text_field.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/keyboard_aware_scroll_view.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_state.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_controller.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventory_detail_state.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/inventory_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryDetailScreen extends ConsumerStatefulWidget {
  const InventoryDetailScreen({required this.inventoryId, super.key});

  final String inventoryId;

  @override
  ConsumerState<InventoryDetailScreen> createState() =>
      _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends ConsumerState<InventoryDetailScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;

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
    final InventoriesState inventoriesState =
        ref.watch(inventoriesControllerProvider);
    final String title = _findInventoryName(inventoriesState);

    final InventoryDetailState state =
        ref.watch(inventoryDetailControllerProvider(widget.inventoryId));
    final InventoryDetailController controller = ref.read(
      inventoryDetailControllerProvider(widget.inventoryId).notifier,
    );

    _syncController(_nameController, state.nameInput);
    _syncController(_quantityController, state.quantityInput);

    return AppScaffold(
      title: title,
      child: KeyboardAwareScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionHeader(
              title: 'Inventory overview',
              subtitle: 'Track stock, low items, and finished essentials.',
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: <StatusChip>[
                StatusChip(
                  label: 'In stock ${state.inStockItems.length}',
                  tone: StatusChipTone.success,
                ),
                StatusChip(
                  label: 'Running low ${state.lowItems.length}',
                  tone: StatusChipTone.warning,
                ),
                StatusChip(
                  label: 'Finished recent ${state.finishedItems.length}',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _AddItemCard(
              state: state,
              nameController: _nameController,
              quantityController: _quantityController,
              onNameChanged: controller.updateNameInput,
              onQuantityChanged: controller.updateQuantityInput,
              onProductChanged: controller.updateSelectedProduct,
              onUnitChanged: controller.updateUnitCode,
              onAddPressed: controller.addItem,
            ),
            const SizedBox(height: AppSpacing.md),
            if (state.message != null) ...<Widget>[
              AppCard(
                child: AppListTile(
                  title: state.message!,
                  leading: const Icon(Icons.info_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (state.hasAnyItems)
              _ItemSections(
                state: state,
                inventoryId: widget.inventoryId,
              )
            else
              EmptyState(
                title: 'No items yet',
                description: 'Add items to this inventory to track your stock.',
                icon: Icons.inventory_2_outlined,
                primaryActionLabel: 'Add item',
                onPrimaryActionPressed: controller.addItem,
              ),
          ],
        ),
      ),
    );
  }

  String _findInventoryName(InventoriesState state) {
    for (final inv in state.inventories) {
      if (inv.id == widget.inventoryId) return inv.name;
    }
    return 'Inventory';
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}

class _AddItemCard extends StatelessWidget {
  const _AddItemCard({
    required this.state,
    required this.nameController,
    required this.quantityController,
    required this.onNameChanged,
    required this.onQuantityChanged,
    required this.onProductChanged,
    required this.onUnitChanged,
    required this.onAddPressed,
  });

  final InventoryDetailState state;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String?> onProductChanged;
  final ValueChanged<String> onUnitChanged;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final List<String> units = Unit.supportedCodes.toList(growable: false)
      ..sort();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Add item',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            key: ValueKey('inv-product-${state.selectedProductId ?? 'none'}'),
            initialValue: state.selectedProductId,
            decoration: const InputDecoration(
              labelText: 'Link product (optional)',
            ),
            items: <DropdownMenuItem<String>>[
              const DropdownMenuItem<String>(child: Text('No product linked')),
              ...state.products.map(
                (product) => DropdownMenuItem<String>(
                  value: product.id,
                  child: Text(product.canonicalName),
                ),
              ),
            ],
            onChanged: onProductChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Custom name (optional)',
            hint: 'Example: oatmeal jar',
            prefixIcon: Icons.edit_note,
            controller: nameController,
            onChanged: onNameChanged,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Estimated quantity',
            hint: 'Example: 2',
            prefixIcon: Icons.numbers,
            controller: quantityController,
            onChanged: onQuantityChanged,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            key: ValueKey('inv-unit-${state.unitCode}'),
            initialValue: state.unitCode,
            decoration: const InputDecoration(labelText: 'Unit'),
            items: units
                .map(
                  (String unit) => DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  ),
                )
                .toList(growable: false),
            onChanged: (String? value) {
              if (value != null) onUnitChanged(value);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Add to inventory',
            onPressed: state.isBusy ? null : onAddPressed,
            icon: Icons.add_circle_outline,
          ),
        ],
      ),
    );
  }
}

class _ItemSections extends ConsumerWidget {
  const _ItemSections({
    required this.state,
    required this.inventoryId,
  });

  final InventoryDetailState state;
  final String inventoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final InventoryDetailController controller =
        ref.read(inventoryDetailControllerProvider(inventoryId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (state.inStockItems.isNotEmpty) ...<Widget>[
          const SectionHeader(title: 'In stock', subtitle: 'Ready to use.'),
          const SizedBox(height: AppSpacing.sm),
          ...state.inStockItems.map(
            (InventoryItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ItemCard(item: item, controller: controller),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (state.lowItems.isNotEmpty) ...<Widget>[
          const SectionHeader(
            title: 'Running low',
            subtitle: 'Remember to buy soon.',
          ),
          const SizedBox(height: AppSpacing.sm),
          ...state.lowItems.map(
            (InventoryItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ItemCard(
                item: item,
                controller: controller,
                highlightLow: true,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (state.finishedItems.isNotEmpty) ...<Widget>[
          const SectionHeader(
            title: 'Finished recently',
            subtitle: 'Completed items from the last 7 days.',
          ),
          const SizedBox(height: AppSpacing.sm),
          ...state.finishedItems.map(
            (InventoryItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ItemCard(item: item, controller: controller),
            ),
          ),
        ],
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.controller,
    this.highlightLow = false,
  });

  final InventoryItem item;
  final InventoryDetailController controller;
  final bool highlightLow;

  @override
  Widget build(BuildContext context) {
    final String title = item.rawName ?? item.productId ?? 'Unnamed item';
    final String quantityText = item.quantityEstimated == null
        ? 'Quantity unknown'
        : '${item.quantityEstimated} ${item.unit?.code ?? ''}'.trim();

    return AppCard(
      child: Column(
        children: <Widget>[
          AppListTile(
            title: title,
            subtitle: quantityText,
            leading: Icon(
              item.status == InventoryItemStatus.low
                  ? Icons.warning_amber_rounded
                  : Icons.inventory_2_outlined,
            ),
            trailing: StatusChip(
              label: _statusLabel(item.status),
              tone: _statusTone(item.status),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: _buildActions(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      if (item.status != InventoryItemStatus.inStock)
        _ActionButton(
          label: 'In stock',
          icon: Icons.check_circle_outline,
          onPressed: () => controller.markInStock(item),
        ),
      if (item.status != InventoryItemStatus.low)
        _ActionButton(
          label: 'Running low',
          icon: Icons.warning_amber_rounded,
          onPressed: () => controller.markRunningLow(item),
        ),
      if (item.status != InventoryItemStatus.out)
        _ActionButton(
          label: 'Finished',
          icon: Icons.remove_circle_outline,
          onPressed: () => controller.markFinished(item),
        ),
      _ActionButton(
        label: 'Delete',
        icon: Icons.delete_outline,
        onPressed: () => controller.softDelete(item),
      ),
    ];
  }

  String _statusLabel(InventoryItemStatus status) {
    return switch (status) {
      InventoryItemStatus.inStock => 'In stock',
      InventoryItemStatus.low => 'Running low',
      InventoryItemStatus.out => 'Finished',
      InventoryItemStatus.unknown => 'Unknown',
    };
  }

  StatusChipTone _statusTone(InventoryItemStatus status) {
    return switch (status) {
      InventoryItemStatus.inStock => StatusChipTone.success,
      InventoryItemStatus.low => StatusChipTone.warning,
      InventoryItemStatus.out => StatusChipTone.danger,
      InventoryItemStatus.unknown => StatusChipTone.neutral,
    };
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
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        textStyle: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
