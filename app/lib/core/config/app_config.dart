/// Application configuration.
/// API Base URL and other settings are managed here
/// to avoid hardcoding values throughout the app.
class AppConfig {
  const AppConfig._();

  /// API base URL — should be overridden per environment.
  /// Defaults to localhost for development.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// API version prefix
  static const String apiVersion = '/api/v1';

  /// Supported languages
  static const List<String> supportedLanguages = [
    'en',
    'zh',
    'vi',
    'ko',
    'pt',
  ];

  /// Default language fallback
  static const String defaultLanguage = 'en';
}
