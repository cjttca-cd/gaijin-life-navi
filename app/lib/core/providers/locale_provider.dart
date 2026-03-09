import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';

/// Key used in SharedPreferences to persist the selected display language.
const _kLocaleKey = 'app_display_language';

/// Manages the selected locale for the app.
/// Persists the language selection via SharedPreferences and provides it
/// to the MaterialApp.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _readyCompleter = Completer<void>();
    _loadSavedLocale();
  }

  late final Completer<void> _readyCompleter;

  /// Completes when the persisted locale has been loaded from storage.
  /// Callers (e.g. SplashScreen) should await this before reading state.
  Future<void> get ready => _readyCompleter.future;

  /// Load the persisted locale from SharedPreferences on startup.
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kLocaleKey);
      if (saved != null && AppConfig.supportedLanguages.contains(saved)) {
        state = Locale(saved);
      }
    } finally {
      _readyCompleter.complete();
    }
  }

  /// Set the locale from a language code (e.g. 'en', 'zh').
  /// Persists the selection to SharedPreferences.
  void setLocale(String languageCode) {
    if (AppConfig.supportedLanguages.contains(languageCode)) {
      state = Locale(languageCode);
      _persist(languageCode);
    }
  }

  /// Clear locale selection (revert to system default).
  void clearLocale() {
    state = null;
    _remove();
  }

  /// Whether a language has been selected (including restored from storage).
  bool get hasSelectedLanguage => state != null;

  Future<void> _persist(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, code);
  }

  Future<void> _remove() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLocaleKey);
  }
}

/// Provider for the [LocaleNotifier].
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
