import 'package:cartalyst_mobile/core/widgets/placeholder_feature_view.dart';
import 'package:flutter/material.dart';

class PantryScreen extends StatelessWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PlaceholderFeatureView(
          title: 'Pantry',
          subtitle: 'Track essential items and keep inventory lightweight.',
          icon: Icons.kitchen_outlined,
        ),
      ),
    );
  }
}
