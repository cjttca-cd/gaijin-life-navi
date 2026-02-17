/// Application configuration.
/// API Base URL and other settings are managed here
/// to avoid hardcoding values throughout the app.
class AppConfig {
  const AppConfig._();

  /// API Gateway base URL — Phase 0 unified endpoint (port 8000).
  /// Should be overridden per environment.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// API version prefix
  static const String apiVersion = '/api/v1';

  /// Supported languages
  static const List<String> supportedLanguages = ['en', 'zh', 'vi', 'ko', 'pt'];

  /// Default language fallback
  static const String defaultLanguage = 'en';
}
