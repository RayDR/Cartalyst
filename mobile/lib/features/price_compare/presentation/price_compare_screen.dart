import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_button.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/app_text_field.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/core/widgets/section_header.dart';
import 'package:cartalyst_mobile/core/widgets/status_chip.dart';
import 'package:cartalyst_mobile/features/price_compare/application/price_compare_controller.dart';
import 'package:cartalyst_mobile/features/price_compare/application/price_compare_state.dart';
import 'package:cartalyst_mobile/features/price_compare/domain/services/package_comparison_service.dart';
import 'package:cartalyst_mobile/features/products/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceCompareScreen extends ConsumerStatefulWidget {
  const PriceCompareScreen({super.key});

  @override
  ConsumerState<PriceCompareScreen> createState() => _PriceCompareScreenState();
}

class _PriceCompareScreenState extends ConsumerState<PriceCompareScreen> {
  final Map<String, TextEditingController> _priceControllers =
      <String, TextEditingController>{};
  final Map<String, TextEditingController> _quantityControllers =
      <String, TextEditingController>{};

  @override
  void dispose() {
    for (final TextEditingController controller in _priceControllers.values) {
      controller.dispose();
    }
    for (final TextEditingController controller
        in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PriceCompareState state = ref.watch(priceCompareControllerProvider);
    final PriceCompareController controller =
        ref.read(priceCompareControllerProvider.notifier);

    return AppScaffold(
      title: 'Price Compare',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Expanded(
                        child: SectionHeader(
                          title: 'Unit price insights',
                          subtitle:
                              'Compare between two and five options, then rank the best value.',
                        ),
                      ),
                      if (state.canAddMoreOptions)
                        AppButton(
                          label: 'Add option',
                          onPressed: controller.addOption,
                          icon: Icons.add_circle_outline,
                          variant: AppButtonVariant.secondary,
                          expanded: false,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...state.options.asMap().entries.map(
                    (MapEntry<int, PriceCompareOptionDraft> entry) {
                      final PriceCompareOptionDraft option = entry.value;
                      final TextEditingController priceController =
                          _controllerFor(
                        _priceControllers,
                        option.id,
                        option.price,
                      );
                      final TextEditingController quantityController =
                          _controllerFor(
                        _quantityControllers,
                        option.id,
                        option.quantity,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: option.showsCompactCard
                            ? _OptionCompactCard(
                                option: option,
                                onEdit: () => controller.editOption(option.id),
                                onRemove: state.canRemoveOptions
                                    ? () => controller.removeOption(option.id)
                                    : null,
                              )
                            : _OptionEditorCard(
                                option: option,
                                products: state.products,
                                unitOptions: PriceCompareController.unitOptions,
                                canRemove: state.canRemoveOptions,
                                priceController: priceController,
                                quantityController: quantityController,
                                onPriceChanged: (String value) => controller
                                    .updateOptionPrice(option.id, value),
                                onQuantityChanged: (String value) => controller
                                    .updateOptionQuantity(option.id, value),
                                onUnitChanged: (String? value) => controller
                                    .updateOptionUnit(option.id, value),
                                onProductChanged: (String? value) => controller
                                    .updateOptionProduct(option.id, value),
                                onDoneEditing: option.hasRequiredFields
                                    ? () => controller.collapseOption(option.id)
                                    : null,
                                onRemove: state.canRemoveOptions
                                    ? () => controller.removeOption(option.id)
                                    : null,
                              ),
                      );
                    },
                  ),
                  if (state.message != null &&
                      state.comparisonResult == null) ...<Widget>[
                    AppCard(child: Text(state.message!)),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  if (state.comparisonResult == null)
                    EmptyState(
                      title: 'No comparison yet',
                      description:
                          'Fill price, quantity, and unit for at least two options, then compare.',
                      icon: Icons.price_check_outlined,
                      primaryActionLabel: 'Compare now',
                      onPrimaryActionPressed: controller.compare,
                    )
                  else
                    _ComparisonResultCard(result: state.comparisonResult!),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SafeArea(
            top: false,
            child: AppCard(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppButton(
                      label: 'Compare',
                      onPressed: state.isBusy ? null : controller.compare,
                      icon: Icons.balance_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: 'Reset',
                      onPressed: controller.reset,
                      icon: Icons.refresh,
                      variant: AppButtonVariant.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController _controllerFor(
    Map<String, TextEditingController> store,
    String id,
    String value,
  ) {
    final TextEditingController controller =
        store.putIfAbsent(id, TextEditingController.new);
    _syncController(controller, value);
    return controller;
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

class _OptionEditorCard extends StatelessWidget {
  const _OptionEditorCard({
    required this.option,
    required this.products,
    required this.unitOptions,
    required this.priceController,
    required this.quantityController,
    required this.onPriceChanged,
    required this.onQuantityChanged,
    required this.onUnitChanged,
    required this.onProductChanged,
    required this.canRemove,
    this.onDoneEditing,
    this.onRemove,
  });

  final PriceCompareOptionDraft option;
  final List<Product> products;
  final List<String> unitOptions;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final ValueChanged<String> onPriceChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String?> onUnitChanged;
  final ValueChanged<String?> onProductChanged;
  final bool canRemove;
  final VoidCallback? onDoneEditing;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  option.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (canRemove && onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remove option',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String?>(
            key: ValueKey('product-${option.id}-${option.productId ?? 'none'}'),
            initialValue: option.productId,
            decoration: const InputDecoration(labelText: 'Product (optional)'),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem<String?>(
                child: Text('No product selected'),
              ),
              ...products.map(
                (Product product) => DropdownMenuItem<String?>(
                  value: product.id,
                  child: Text(product.canonicalName),
                ),
              ),
            ],
            onChanged: onProductChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Price (USD)',
            hint: 'Example: 12.99',
            prefixIcon: Icons.attach_money,
            controller: priceController,
            onChanged: onPriceChanged,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: 'Quantity',
            hint: 'Example: 20',
            prefixIcon: Icons.numbers,
            controller: quantityController,
            onChanged: onQuantityChanged,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String?>(
            key: ValueKey<String>('unit-${option.id}-${option.unit ?? 'none'}'),
            initialValue: option.unit,
            decoration: const InputDecoration(labelText: 'Unit'),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem<String?>(
                child: Text('Select a unit'),
              ),
              ...unitOptions.map(
                (String unit) => DropdownMenuItem<String?>(
                  value: unit,
                  child: Text(unit),
                ),
              ),
            ],
            onChanged: onUnitChanged,
          ),
          if (option.hasRequiredFields) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                label: 'Done editing',
                onPressed: onDoneEditing,
                icon: Icons.check_circle_outline,
                expanded: false,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionCompactCard extends StatelessWidget {
  const _OptionCompactCard({
    required this.option,
    required this.onEdit,
    this.onRemove,
  });

  final PriceCompareOptionDraft option;
  final VoidCallback onEdit;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: <Widget>[
          Expanded(
            child: AppListTile(
              title: option.label,
              subtitle: option.compactSummary,
              leading: const Icon(Icons.inventory_2_outlined),
              onTap: onEdit,
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit option',
          ),
          if (onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove option',
            ),
        ],
      ),
    );
  }
}

class _ComparisonResultCard extends StatelessWidget {
  const _ComparisonResultCard({required this.result});

  final PackageComparisonResult result;

  @override
  Widget build(BuildContext context) {
    final StatusChipTone tone = switch (result.recommendation) {
      PackageRecommendation.winner => StatusChipTone.success,
      PackageRecommendation.tie => StatusChipTone.warning,
      PackageRecommendation.none => StatusChipTone.danger,
    };

    final String status = switch (result.recommendation) {
      PackageRecommendation.winner => 'Winner: ${result.recommendedLabel}',
      PackageRecommendation.tie => 'Both are equal value',
      PackageRecommendation.none => 'Cannot compare',
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              StatusChip(label: status, tone: tone),
              const SizedBox(width: AppSpacing.sm),
              Text('Per ${result.normalizedUnit ?? '-'}'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            result.explanation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Comparison table',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Option')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Unit')),
                DataColumn(label: Text('Unit price')),
                DataColumn(label: Text('Rank')),
              ],
              rows: result.rankedOptions
                  .map(
                    (PackageOptionEvaluation evaluation) => DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(evaluation.option.label),
                        ),
                        DataCell(
                          Text(
                            '\$${evaluation.option.price.toStringAsFixed(2)}',
                          ),
                        ),
                        DataCell(
                          Text(
                            evaluation.option.quantity.toStringAsFixed(
                              evaluation.option.quantity % 1 == 0 ? 0 : 2,
                            ),
                          ),
                        ),
                        DataCell(Text(evaluation.option.unit)),
                        DataCell(
                          Text(
                            '${evaluation.unitPriceResult.unitPrice?.toStringAsFixed(4) ?? 'N/A'} / ${result.normalizedUnit ?? '-'}',
                          ),
                        ),
                        DataCell(
                          Text('#${evaluation.rank ?? '-'}'),
                        ),
                      ],
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}
