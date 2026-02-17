import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';

/// Manages the selected locale for the app.
/// Persists the language selection and provides it to the MaterialApp.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null);

  /// Set the locale from a language code (e.g. 'en', 'zh').
  void setLocale(String languageCode) {
    if (AppConfig.supportedLanguages.contains(languageCode)) {
      state = Locale(languageCode);
    }
  }

  /// Clear locale selection (revert to system default).
  void clearLocale() {
    state = null;
  }

  /// Whether a language has been selected.
  bool get hasSelectedLanguage => state != null;
}

/// Provider for the [LocaleNotifier].
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
