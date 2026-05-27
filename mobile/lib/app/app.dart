import 'package:cartalyst_mobile/app/router.dart';
import 'package:cartalyst_mobile/core/design/app_theme.dart';
import 'package:flutter/material.dart';

class CartalystApp extends StatelessWidget {
  const CartalystApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cartalyst',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
