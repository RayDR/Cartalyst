import 'package:cartalyst_mobile/core/widgets/placeholder_feature_view.dart';
import 'package:flutter/material.dart';

class PriceCompareScreen extends StatelessWidget {
  const PriceCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PlaceholderFeatureView(
          title: 'Price Compare',
          subtitle: 'Compare unit prices clearly for smarter in-store decisions.',
          icon: Icons.balance_outlined,
        ),
      ),
    );
  }
}
