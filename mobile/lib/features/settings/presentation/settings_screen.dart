import 'package:cartalyst_mobile/core/widgets/placeholder_feature_view.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: PlaceholderFeatureView(
          title: 'Settings',
          subtitle: 'Control app preferences and future sync behavior in one place.',
          icon: Icons.tune_rounded,
        ),
      ),
    );
  }
}
