import 'package:flutter/material.dart';

/// Color tokens from DESIGN_SYSTEM.md §1.
///
/// All UI code should reference these tokens or use
/// `Theme.of(context).colorScheme.*` — never hardcode hex values.
class AppColors {
  const AppColors._();

  // ── §1.2 Primary Colors (Trust Blue) ───────────────────────
  static const Color primary = Color(0xFF2563EB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFDBEAFE);
  static const Color onPrimaryContainer = Color(0xFF1E3A5F);
  static const Color primaryFixed = Color(0xFFEFF6FF);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // ── §1.3 Secondary Colors (Empowerment Teal) ──────────────
  static const Color secondary = Color(0xFF0D9488);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFCCFBF1);
  static const Color onSecondaryContainer = Color(0xFF134E4A);

  // ── §1.4 Tertiary Colors (Warmth Amber) ────────────────────
  static const Color tertiary = Color(0xFFF59E0B);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiaryContainer = Color(0xFF78350F);

  // ── §1.5 Semantic Colors ───────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color onSuccessContainer = Color(0xFF14532D);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarningContainer = Color(0xFF78350F);
  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  // ── §1.6 Neutral Colors ────────────────────────────────────
  static const Color background = Color(0xFFFAFBFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceDim = Color(0xFFE2E8F0);
  static const Color onBackground = Color(0xFF0F172A);
  static const Color onSurface = Color(0xFF1E293B);
  static const Color onSurfaceVariant = Color(0xFF64748B);
  static const Color outline = Color(0xFFCBD5E1);
  static const Color outlineVariant = Color(0xFFE2E8F0);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF1E293B);
  static const Color onInverseSurface = Color(0xFFF1F5F9);

  // ── §1.7 Domain Accent Colors ──────────────────────────────
  static const Color bankingAccent = Color(0xFF2563EB);
  static const Color bankingContainer = Color(0xFFDBEAFE);
  static const Color bankingIcon = Color(0xFF1D4ED8);

  static const Color visaAccent = Color(0xFF7C3AED);
  static const Color visaContainer = Color(0xFFEDE9FE);
  static const Color visaIcon = Color(0xFF6D28D9);

  static const Color medicalAccent = Color(0xFFDC2626);
  static const Color medicalContainer = Color(0xFFFEE2E2);
  static const Color medicalIcon = Color(0xFFB91C1C);

  static const Color adminAccent = Color(0xFF4F46E5);
  static const Color adminContainer = Color(0xFFE0E7FF);
  static const Color adminIcon = Color(0xFF4338CA);

  static const Color housingAccent = Color(0xFFEA580C);
  static const Color housingContainer = Color(0xFFFFF7ED);
  static const Color housingIcon = Color(0xFFC2410C);

  static const Color workAccent = Color(0xFF0D9488);
  static const Color workContainer = Color(0xFFCCFBF1);
  static const Color workIcon = Color(0xFF0F766E);

  static const Color transportAccent = Color(0xFF0284C7);
  static const Color transportContainer = Color(0xFFE0F2FE);
  static const Color transportIcon = Color(0xFF0369A1);

  static const Color foodAccent = Color(0xFF16A34A);
  static const Color foodContainer = Color(0xFFDCFCE7);
  static const Color foodIcon = Color(0xFF15803D);
}
