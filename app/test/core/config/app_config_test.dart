import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('has default API base URL', () {
      expect(AppConfig.apiBaseUrl, isNotEmpty);
    });

    test('has AI service base URL', () {
      expect(AppConfig.aiServiceBaseUrl, isNotEmpty);
      expect(AppConfig.aiServiceBaseUrl, contains('8001'));
    });

    test('has API version prefix', () {
      expect(AppConfig.apiVersion, '/api/v1');
    });

    test('supports 5 languages', () {
      expect(AppConfig.supportedLanguages.length, 5);
      expect(AppConfig.supportedLanguages, contains('en'));
      expect(AppConfig.supportedLanguages, contains('zh'));
      expect(AppConfig.supportedLanguages, contains('vi'));
      expect(AppConfig.supportedLanguages, contains('ko'));
      expect(AppConfig.supportedLanguages, contains('pt'));
    });

    test('default language is English', () {
      expect(AppConfig.defaultLanguage, 'en');
    });
  });
}
