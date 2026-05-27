import 'package:cartalyst_mobile/core/widgets/placeholder_feature_view.dart';
import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PlaceholderFeatureView(
          title: 'Shopping List',
          subtitle: 'Build lists quickly with suggestion-ready product input.',
          icon: Icons.shopping_cart_outlined,
        ),
      ),
    );
  }
}
