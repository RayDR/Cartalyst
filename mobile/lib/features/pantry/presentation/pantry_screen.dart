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
import 'package:cartalyst_mobile/features/pantry/application/pantry_controller.dart';
import 'package:cartalyst_mobile/features/pantry/application/pantry_state.dart';
import 'package:cartalyst_mobile/features/pantry/domain/entities/pantry_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
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
    final PantryState state = ref.watch(pantryControllerProvider);
    final PantryController controller = ref.read(pantryControllerProvider.notifier);

    _syncController(_nameController, state.nameInput);
    _syncController(_quantityController, state.quantityInput);

    return AppScaffold(
        title: 'Inventory',
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
              StatusChip(label: 'Finished recent ${state.finishedItems.length}'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _AddPantryItemCard(
            state: state,
            nameController: _nameController,
            quantityController: _quantityController,
            onNameChanged: controller.updateNameInput,
            onQuantityChanged: controller.updateQuantityInput,
            onProductChanged: controller.updateSelectedProduct,
            onUnitChanged: controller.updateUnitCode,
            onAddPressed: controller.addPantryItem,
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
          Expanded(
            child: state.hasAnyItems
                ? _PantrySections(state: state)
                : EmptyState(
                  title: 'No inventory items yet',
                    description:
                    'Add inventory items manually and keep your home essentials in sync.',
                    icon: Icons.inventory_2_outlined,
                  primaryActionLabel: 'Add inventory item',
                    onPrimaryActionPressed: controller.addPantryItem,
                  ),
          ),
        ],
      ),
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }

    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}

class _AddPantryItemCard extends StatelessWidget {
  const _AddPantryItemCard({
    required this.state,
    required this.nameController,
    required this.quantityController,
    required this.onNameChanged,
    required this.onQuantityChanged,
    required this.onProductChanged,
    required this.onUnitChanged,
    required this.onAddPressed,
  });

  final PantryState state;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String?> onProductChanged;
  final ValueChanged<String> onUnitChanged;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    final List<String> units = Unit.supportedCodes.toList(growable: false)..sort();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Add inventory item', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            key: ValueKey('pantry-product-${state.selectedProductId ?? 'none'}'),
            initialValue: state.selectedProductId,
            decoration: const InputDecoration(labelText: 'Link product (optional)'),
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
            key: ValueKey('pantry-unit-${state.unitCode}'),
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
              if (value != null) {
                onUnitChanged(value);
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Add item to inventory',
            onPressed: state.isBusy ? null : onAddPressed,
            icon: Icons.add_circle_outline,
          ),
        ],
      ),
    );
  }
}

class _PantrySections extends ConsumerWidget {
  const _PantrySections({required this.state});

  final PantryState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PantryController controller = ref.read(pantryControllerProvider.notifier);

    return ListView(
      children: <Widget>[
        if (state.inStockItems.isNotEmpty) ...<Widget>[
          const SectionHeader(title: 'In stock', subtitle: 'Ready to use.'),
          const SizedBox(height: AppSpacing.sm),
          ...state.inStockItems.map(
            (PantryItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _PantryItemCard(item: item, controller: controller),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (state.lowItems.isNotEmpty) ...<Widget>[
          const SectionHeader(title: 'Running low', subtitle: 'Remember to buy soon.'),
          const SizedBox(height: AppSpacing.sm),
          ...state.lowItems.map(
            (PantryItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _PantryItemCard(item: item, controller: controller, highlightLow: true),
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
            (PantryItem item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _PantryItemCard(item: item, controller: controller),
            ),
          ),
        ],
      ],
    );
  }
}

class _PantryItemCard extends StatelessWidget {
  const _PantryItemCard({
    required this.item,
    required this.controller,
    this.highlightLow = false,
  });

  final PantryItem item;
  final PantryController controller;
  final bool highlightLow;

  @override
  Widget build(BuildContext context) {
    final String title = item.rawName ?? item.productId ?? 'Unnamed inventory item';
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
              item.status == PantryItemStatus.low
                  ? Icons.warning_amber_rounded
                  : Icons.inventory_2_outlined,
            ),
            trailing: StatusChip(
              label: _statusLabel(item.status),
              tone: highlightLow ? StatusChipTone.warning : StatusChipTone.neutral,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              _ActionButton(
                label: 'In stock',
                icon: Icons.check_circle_outline,
                onPressed: () => controller.markInStock(item),
              ),
              _ActionButton(
                label: 'Running low',
                icon: Icons.report_gmailerrorred_outlined,
                onPressed: () => controller.markRunningLow(item),
              ),
              _ActionButton(
                label: 'Finished',
                icon: Icons.done_all,
                onPressed: () => controller.markFinished(item),
              ),
              _ActionButton(
                label: 'Adjust',
                icon: Icons.tune,
                onPressed: () => _openAdjustSheet(context),
              ),
              _ActionButton(
                label: 'Delete',
                icon: Icons.delete_outline,
                onPressed: () => controller.softDelete(item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openAdjustSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return _AdjustSheet(item: item, controller: controller);
      },
    );
  }

  String _statusLabel(PantryItemStatus status) {
    return switch (status) {
      PantryItemStatus.unknown => 'Unknown',
      PantryItemStatus.inStock => 'In stock',
      PantryItemStatus.low => 'Running low',
      PantryItemStatus.out => 'Finished',
    };
  }
}

class _AdjustSheet extends StatefulWidget {
  const _AdjustSheet({required this.item, required this.controller});

  final PantryItem item;
  final PantryController controller;

  @override
  State<_AdjustSheet> createState() => _AdjustSheetState();
}

class _AdjustSheetState extends State<_AdjustSheet> {
  late final TextEditingController _quantityController;
  late String _unitCode;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantityEstimated?.toString() ?? '',
    );
    _unitCode = widget.item.unit?.code ?? 'unit';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> units = Unit.supportedCodes.toList(growable: false)..sort();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Adjust inventory quantity', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Quantity',
            hint: 'Example: 1.5',
            prefixIcon: Icons.numbers,
            controller: _quantityController,
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            initialValue: _unitCode,
            decoration: const InputDecoration(labelText: 'Unit'),
            items: units
                .map(
                  (String unit) => DropdownMenuItem<String>(value: unit, child: Text(unit)),
                )
                .toList(growable: false),
            onChanged: (String? value) {
              if (value == null) {
                return;
              }
              setState(() {
                _unitCode = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Save adjustment',
            onPressed: () async {
              final double? quantity = double.tryParse(_quantityController.text.trim());
              await widget.controller.adjustItem(
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
      style: FilledButton.styleFrom(minimumSize: const Size(128, AppSpacing.xxl)),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
