import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:cartalyst_mobile/core/widgets/app_card.dart';
import 'package:cartalyst_mobile/core/widgets/app_list_tile.dart';
import 'package:cartalyst_mobile/core/widgets/app_scaffold.dart';
import 'package:cartalyst_mobile/core/widgets/empty_state.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_controller.dart';
import 'package:cartalyst_mobile/features/home/application/home_dashboard_state.dart';
import 'package:cartalyst_mobile/features/inventories/application/inventories_controller.dart';
import 'package:cartalyst_mobile/features/shopping_list/application/lists_controller.dart';
import 'package:cartalyst_mobile/infrastructure/local_db/app_database.dart'
  as local_db;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeDashboardState state = ref.watch(homeDashboardControllerProvider);
    final ListsController listsController = ref.read(
      listsControllerProvider.notifier,
    );
    final InventoriesController inventoriesController = ref.read(
      inventoriesControllerProvider.notifier,
    );

    return AppScaffold(
      title: 'Home',
      padding: EdgeInsets.zero,
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      state.greeting,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      state.identity,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: <Widget>[
                        _MetricChip(
                          label: 'Lists',
                          value: state.lists.length.toString(),
                        ),
                        _MetricChip(
                          label: 'Inventories',
                          value: state.inventories.length.toString(),
                        ),
                        _MetricChip(
                          label: 'Categories',
                          value: state.categories.length.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: TabBar(
                tabs: <Widget>[
                  Tab(text: 'Lists'),
                  Tab(text: 'Inventories'),
                  Tab(text: 'Categories'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _ListsTab(
                    lists: state.lists,
                    onCreateList: () => _showCreateListSheet(
                      context,
                      listsController,
                    ),
                  ),
                  _InventoriesTab(
                    inventories: state.inventories,
                    onCreateInventory: () => _showCreateInventorySheet(
                      context,
                      inventoriesController,
                    ),
                  ),
                  _CategoriesTab(categories: state.categories),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateListSheet(
    BuildContext context,
    ListsController controller,
  ) async {
    final String? name = await _showNameSheet(
      context,
      title: 'New shopping list',
      description: 'Create a simple list or get started with a fresh draft.',
      label: 'List name',
      hint: 'Example: Weekly groceries',
      actionLabel: 'Create list',
    );
    if (name == null || !context.mounted) {
      return;
    }

    final String? newId = await controller.createList(name);
    if (newId != null && context.mounted) {
      context.go('/lists/$newId');
    }
  }

  Future<void> _showCreateInventorySheet(
    BuildContext context,
    InventoriesController controller,
  ) async {
    final String? name = await _showNameSheet(
      context,
      title: 'New inventory',
      description: 'Track pantry, closet, or any other storage space.',
      label: 'Inventory name',
      hint: 'Example: Pantry',
      actionLabel: 'Create inventory',
    );
    if (name == null || !context.mounted) {
      return;
    }

    final String? newId = await controller.createInventory(name);
    if (newId != null && context.mounted) {
      context.go('/inventories/$newId');
    }
  }

  Future<String?> _showNameSheet(
    BuildContext context, {
    required String title,
    required String description,
    required String label,
    required String hint,
    required String actionLabel,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) => _NameSheet(
        title: title,
        description: description,
        label: label,
        hint: hint,
        actionLabel: actionLabel,
      ),
    );
  }
}

class _ListsTab extends StatelessWidget {
  const _ListsTab({required this.lists, required this.onCreateList});

  final List<local_db.ShoppingList> lists;
  final VoidCallback onCreateList;

  @override
  Widget build(BuildContext context) {
    final List<local_db.ShoppingList> recentLists =
      lists.take(3).toList(growable: false);
    final List<local_db.ShoppingList> activeLists = lists
      .where((local_db.ShoppingList list) => list.status == 'active')
      .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      children: <Widget>[
        _SectionHeader(
          title: 'Recent lists',
          actionLabel: 'Create list',
          onActionPressed: onCreateList,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (lists.isEmpty)
          const _EmptyTabState(
            title: 'No lists yet',
            description: 'Create your first shopping list to get started.',
            icon: Icons.shopping_cart_outlined,
          )
        else ...<Widget>[
          ...recentLists.map(
            (local_db.ShoppingList list) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _EntityCard(
                title: list.name,
                subtitle: _recentActivityLabel(list.updatedAt),
                leading: Icons.shopping_cart_outlined,
                onTap: () => context.go('/lists/${list.id}'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(
            title: 'All active lists',
            actionLabel: 'Create list',
            onActionPressed: onCreateList,
          ),
          const SizedBox(height: AppSpacing.xs),
          if (activeLists.isEmpty)
            const _EmptyTabState(
              title: 'No active lists',
              description: 'Archived or completed lists are hidden here.',
              icon: Icons.playlist_remove_outlined,
            )
          else ...activeLists.map(
            (local_db.ShoppingList list) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _EntityCard(
                title: list.name,
                subtitle: list.status,
                leading: Icons.list_alt_outlined,
                onTap: () => context.go('/lists/${list.id}'),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _InventoriesTab extends StatelessWidget {
  const _InventoriesTab({
    required this.inventories,
    required this.onCreateInventory,
  });

  final List<local_db.Inventory> inventories;
  final VoidCallback onCreateInventory;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      children: <Widget>[
        _SectionHeader(
          title: 'Inventories',
          actionLabel: 'Create inventory',
          onActionPressed: onCreateInventory,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (inventories.isEmpty)
          const _EmptyTabState(
            title: 'No inventories yet',
            description: 'Create an inventory for pantry, closet, or storage.',
            icon: Icons.inventory_2_outlined,
          )
        else
          ...inventories.map(
            (local_db.Inventory inventory) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _EntityCard(
                title: inventory.name,
                subtitle: inventory.description ?? 'Inventory',
                leading: Icons.inventory_2_outlined,
                onTap: () => context.go('/inventories/${inventory.id}'),
              ),
            ),
          ),
      ],
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab({required this.categories});

  final List<local_db.Category> categories;

  @override
  Widget build(BuildContext context) {
    final List<local_db.Category> sortedCategories =
        List<local_db.Category>.from(categories)
      ..sort((local_db.Category a, local_db.Category b) {
        final bool aIsUncategorized = a.name.toLowerCase() == 'uncategorized';
        final bool bIsUncategorized = b.name.toLowerCase() == 'uncategorized';
        if (aIsUncategorized && !bIsUncategorized) {
          return -1;
        }
        if (!aIsUncategorized && bIsUncategorized) {
          return 1;
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    final local_db.Category? uncategorized = sortedCategories.isNotEmpty &&
            sortedCategories.first.name.toLowerCase() == 'uncategorized'
        ? sortedCategories.first
        : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      children: <Widget>[
        const _SectionHeader(title: 'Categories'),
        const SizedBox(height: AppSpacing.xs),
        if (categories.isEmpty)
          const _EmptyTabState(
            title: 'No categories yet',
            description:
                'Categories will appear as you organize shopping and inventory.',
            icon: Icons.label_outline,
          )
        else ...<Widget>[
          if (uncategorized != null) ...<Widget>[
            _EntityCard(
              title: uncategorized.name,
              subtitle: 'Fallback category',
              leading: Icons.label_outline,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          ...sortedCategories
              .where((local_db.Category category) => category != uncategorized)
              .map(
                (local_db.Category category) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: _EntityCard(
                    title: category.name,
                    subtitle: category.color ?? 'Category',
                    leading: Icons.label_outline,
                  ),
                ),
              ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (actionLabel != null && onActionPressed != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _EntityCard extends StatelessWidget {
  const _EntityCard({
    required this.title,
    required this.subtitle,
    required this.leading,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: AppListTile(
        title: title,
        subtitle: subtitle,
        leading: Icon(leading),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _EmptyTabState extends StatelessWidget {
  const _EmptyTabState({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: title,
      description: description,
      icon: icon,
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label $value'),
    );
  }
}

class _NameSheet extends StatefulWidget {
  const _NameSheet({
    required this.title,
    required this.description,
    required this.label,
    required this.hint,
    required this.actionLabel,
  });

  final String title;
  final String description;
  final String label;
  final String hint;
  final String actionLabel;

  @override
  State<_NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<_NameSheet> {
  final TextEditingController _controller = TextEditingController();

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
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text(widget.actionLabel),
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

String _recentActivityLabel(DateTime value) {
  final DateTime now = DateTime.now();
  final Duration diff = now.difference(value);
  if (diff.inMinutes < 1) {
    return 'Updated just now';
  }
  if (diff.inHours < 1) {
    return 'Updated ${diff.inMinutes}m ago';
  }
  if (diff.inDays < 1) {
    return 'Updated ${diff.inHours}h ago';
  }
  return 'Updated ${diff.inDays}d ago';
}

