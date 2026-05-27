import 'package:cartalyst_mobile/core/widgets/placeholder_feature_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PlaceholderFeatureView(
          title: 'Cartalyst Home',
          subtitle: 'Fast list actions, smart suggestions, and pantry snapshots.',
          icon: Icons.insights_rounded,
        ),
      ),
    );
  }
}
