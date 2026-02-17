import 'package:flutter/material.dart';

/// Typography scale from DESIGN_SYSTEM.md §2.
class AppTypography {
  const AppTypography._();

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 40 / 32,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 36 / 28,
      letterSpacing: 0,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 32 / 24,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 28 / 20,
      letterSpacing: 0.15,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 26 / 18,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 24 / 16,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 16 / 12,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 16 / 12,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 16 / 11,
      letterSpacing: 0.5,
    ),
  );
}
