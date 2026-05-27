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
  late final TextEditingController _optionOnePriceController;
  late final TextEditingController _optionOneQuantityController;
  late final TextEditingController _optionTwoPriceController;
  late final TextEditingController _optionTwoQuantityController;

  @override
  void initState() {
    super.initState();
    _optionOnePriceController = TextEditingController();
    _optionOneQuantityController = TextEditingController();
    _optionTwoPriceController = TextEditingController();
    _optionTwoQuantityController = TextEditingController();
  }

  @override
  void dispose() {
    _optionOnePriceController.dispose();
    _optionOneQuantityController.dispose();
    _optionTwoPriceController.dispose();
    _optionTwoQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PriceCompareState state = ref.watch(priceCompareControllerProvider);
    final PriceCompareController controller = ref.read(priceCompareControllerProvider.notifier);

    _syncController(_optionOnePriceController, state.optionOnePrice);
    _syncController(_optionOneQuantityController, state.optionOneQuantity);
    _syncController(_optionTwoPriceController, state.optionTwoPrice);
    _syncController(_optionTwoQuantityController, state.optionTwoQuantity);

    return AppScaffold(
      title: 'Price Compare',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeader(
            title: 'Unit price insights',
            subtitle: 'Compare two options and find the best value instantly.',
          ),
          const SizedBox(height: AppSpacing.md),
          _OptionCard(
            title: 'Option A',
            products: state.products,
            selectedProductId: state.optionOneProductId,
            selectedUnit: state.optionOneUnit,
            unitOptions: PriceCompareController.unitOptions,
            priceController: _optionOnePriceController,
            quantityController: _optionOneQuantityController,
            onPriceChanged: controller.updateOptionOnePrice,
            onQuantityChanged: controller.updateOptionOneQuantity,
            onUnitChanged: controller.updateOptionOneUnit,
            onProductChanged: controller.updateOptionOneProduct,
          ),
          const SizedBox(height: AppSpacing.sm),
          _OptionCard(
            title: 'Option B',
            products: state.products,
            selectedProductId: state.optionTwoProductId,
            selectedUnit: state.optionTwoUnit,
            unitOptions: PriceCompareController.unitOptions,
            priceController: _optionTwoPriceController,
            quantityController: _optionTwoQuantityController,
            onPriceChanged: controller.updateOptionTwoPrice,
            onQuantityChanged: controller.updateOptionTwoQuantity,
            onUnitChanged: controller.updateOptionTwoUnit,
            onProductChanged: controller.updateOptionTwoProduct,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
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
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: state.comparisonResult == null
                ? EmptyState(
                    title: 'No comparison yet',
                    description:
                        'Enter price, quantity, and unit for both options to compare unit price.',
                    icon: Icons.price_check_outlined,
                    primaryActionLabel: 'Compare now',
                    onPrimaryActionPressed: controller.compare,
                  )
                : _ComparisonResultCard(result: state.comparisonResult!, message: state.message),
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

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.title,
    required this.products,
    required this.selectedProductId,
    required this.selectedUnit,
    required this.unitOptions,
    required this.priceController,
    required this.quantityController,
    required this.onPriceChanged,
    required this.onQuantityChanged,
    required this.onUnitChanged,
    required this.onProductChanged,
  });

  final String title;
  final List<Product> products;
  final String? selectedProductId;
  final String selectedUnit;
  final List<String> unitOptions;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final ValueChanged<String> onPriceChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<String?> onProductChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            key: ValueKey('product-$title-${selectedProductId ?? 'none'}'),
            initialValue: selectedProductId,
            decoration: const InputDecoration(labelText: 'Product (optional)'),
            items: <DropdownMenuItem<String>>[
              const DropdownMenuItem<String>(child: Text('No product selected')),
              ...products.map(
                (Product product) => DropdownMenuItem<String>(
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
          DropdownButtonFormField<String>(
            key: ValueKey<String>('unit-$title-$selectedUnit'),
            initialValue: selectedUnit,
            decoration: const InputDecoration(labelText: 'Unit'),
            items: unitOptions
                .map(
                  (String unit) => DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  ),
                )
                .toList(growable: false),
            onChanged: (String? unit) {
              if (unit != null) {
                onUnitChanged(unit);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ComparisonResultCard extends StatelessWidget {
  const _ComparisonResultCard({
    required this.result,
    required this.message,
  });

  final PackageComparisonResult result;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final StatusChipTone tone = switch (result.recommendation) {
      PackageRecommendation.first || PackageRecommendation.second => StatusChipTone.success,
      PackageRecommendation.tie => StatusChipTone.warning,
      PackageRecommendation.none => StatusChipTone.danger,
    };

    final String status = switch (result.recommendation) {
      PackageRecommendation.first => 'Best value: Option A',
      PackageRecommendation.second => 'Best value: Option B',
      PackageRecommendation.tie => 'Both are equal value',
      PackageRecommendation.none => 'Cannot compare',
    };

    final String firstUnitPrice = result.firstOption.unitPriceResult.unitPrice == null
        ? 'N/A'
        : result.firstOption.unitPriceResult.unitPrice!.toStringAsFixed(4);

    final String secondUnitPrice = result.secondOption.unitPriceResult.unitPrice == null
        ? 'N/A'
        : result.secondOption.unitPriceResult.unitPrice!.toStringAsFixed(4);

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
          AppListTile(
            title: 'Option A unit price',
            subtitle: '$firstUnitPrice / ${result.normalizedUnit ?? '-'}',
            leading: const Icon(Icons.looks_one_outlined),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppListTile(
            title: 'Option B unit price',
            subtitle: '$secondUnitPrice / ${result.normalizedUnit ?? '-'}',
            leading: const Icon(Icons.looks_two_outlined),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message ?? result.explanation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
