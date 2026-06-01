import 'package:cartalyst_mobile/features/home/presentation/home_screen.dart';
import 'package:cartalyst_mobile/features/inventories/presentation/inventories_screen.dart';
import 'package:cartalyst_mobile/features/inventories/presentation/inventory_detail_screen.dart';
import 'package:cartalyst_mobile/features/price_compare/presentation/price_compare_screen.dart';
import 'package:cartalyst_mobile/features/settings/presentation/settings_screen.dart';
import 'package:cartalyst_mobile/features/shopping_list/presentation/list_detail_screen.dart';
import 'package:cartalyst_mobile/features/shopping_list/presentation/lists_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _listsNavigatorKey =
  GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _inventoriesNavigatorKey =
  GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _priceCompareNavigatorKey =
  GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingsNavigatorKey =
  GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return AppNavigationShell(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              builder: (BuildContext context, GoRouterState state) {
                return const HomeScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _listsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/lists',
              builder: (BuildContext context, GoRouterState state) {
                return const ListsScreen();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: ':id',
                  builder: (BuildContext context, GoRouterState state) {
                    final String listId = state.pathParameters['id']!;
                    return ListDetailScreen(listId: listId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _inventoriesNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/inventories',
              builder: (BuildContext context, GoRouterState state) {
                return const InventoriesScreen();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: ':id',
                  builder: (BuildContext context, GoRouterState state) {
                    final String inventoryId = state.pathParameters['id']!;
                    return InventoryDetailScreen(inventoryId: inventoryId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _priceCompareNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/price-compare',
              builder: (BuildContext context, GoRouterState state) {
                return const PriceCompareScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) {
                return const SettingsScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class AppNavigationShell extends StatefulWidget {
  const AppNavigationShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell> {
  NavigatorState? _currentBranchNavigator() {
    switch (widget.navigationShell.currentIndex) {
      case 0:
        return _homeNavigatorKey.currentState;
      case 1:
        return _listsNavigatorKey.currentState;
      case 2:
        return _inventoriesNavigatorKey.currentState;
      case 3:
        return _priceCompareNavigatorKey.currentState;
      case 4:
        return _settingsNavigatorKey.currentState;
      default:
        return null;
    }
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Exit Cartalyst?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, void result) async {
        if (didPop) {
          return;
        }

        final NavigatorState? currentNavigator = _currentBranchNavigator();
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
          return;
        }

        if (widget.navigationShell.currentIndex != 0) {
          widget.navigationShell.goBranch(0);
          return;
        }

        final bool shouldExit = await _showExitConfirmationDialog(context);
        if (!shouldExit) {
          return;
        }

        await SystemNavigator.pop();
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Lists',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventories',
          ),
          NavigationDestination(
            icon: Icon(Icons.balance_outlined),
            selectedIcon: Icon(Icons.balance),
            label: 'Compare',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (int index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
      ),
      ),
    );
  }
}
