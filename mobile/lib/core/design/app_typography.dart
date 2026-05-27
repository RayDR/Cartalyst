import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextTheme createTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
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
      titleSmall: TextStyle(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        height: 1.35,
      ),
      bodyMedium: TextStyle(
        height: 1.35,
      ),
      bodySmall: TextStyle(
        height: 1.35,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
