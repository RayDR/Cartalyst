import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextTheme createTextTheme() {
    return const TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        height: 1.3,
      ),
      bodyMedium: TextStyle(
        height: 1.3,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
