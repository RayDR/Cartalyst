import 'package:cartalyst_mobile/features/home/presentation/home_screen.dart';
import 'package:cartalyst_mobile/features/inventories/presentation/inventories_screen.dart';
import 'package:cartalyst_mobile/features/inventories/presentation/inventory_detail_screen.dart';
import 'package:cartalyst_mobile/features/price_compare/presentation/price_compare_screen.dart';
import 'package:cartalyst_mobile/features/settings/presentation/settings_screen.dart';
import 'package:cartalyst_mobile/features/shopping_list/presentation/list_detail_screen.dart';
import 'package:cartalyst_mobile/features/shopping_list/presentation/lists_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

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

class AppNavigationShell extends StatelessWidget {
  const AppNavigationShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
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
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
