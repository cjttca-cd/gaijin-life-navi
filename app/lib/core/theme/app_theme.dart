import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Application theme — Design System v1.0.0 compliant.
///
/// All color values come from [AppColors] (DESIGN_SYSTEM.md §1).
/// Typography from [AppTypography] (DESIGN_SYSTEM.md §2).
/// Phase 0: Light theme only.
class AppTheme {
  const AppTheme._();

  /// The light [ColorScheme] per DESIGN_SYSTEM.md Appendix A.
  static final ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    scrim: AppColors.scrim,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.onInverseSurface,
  );

  /// Light theme — the only theme in Phase 0.
  static ThemeData get light {
    final textTheme = AppTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,

      // AppBar — §6.6.1
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.onSurface,
        ),
      ),

      // NavigationBar — §6.5.1
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        backgroundColor: AppColors.surface,
        elevation: 0,
        indicatorColor: AppColors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(
            color: AppColors.onSurfaceVariant,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(color: AppColors.primary);
          }
          return textTheme.labelMedium?.copyWith(
            color: AppColors.onSurfaceVariant,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // InputDecoration — §6.3.1
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
      ),

      // FilledButton (Primary) — §6.1.1
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.surfaceDim,
          disabledForegroundColor: AppColors.onSurfaceVariant,
          minimumSize: const Size(120, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: textTheme.labelLarge,
          elevation: 0,
        ),
      ),

      // ElevatedButton — map to Primary style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.surfaceDim,
          disabledForegroundColor: AppColors.onSurfaceVariant,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: textTheme.labelLarge,
          elevation: 0,
        ),
      ),

      // OutlinedButton — §6.1.3
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(120, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppColors.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // TextButton — §6.1.4
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // Card — §6.2
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),

      // Dialog — §6.8.1
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
      ),

      // BottomSheet — §6.8.2
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        elevation: 6,
      ),

      // Snackbar — §6.8.3
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        labelStyle: textTheme.labelMedium,
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
    );
  }
}
