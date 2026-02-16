import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/core/providers/locale_provider.dart';

void main() {
  group('LocaleNotifier', () {
    late LocaleNotifier notifier;

    setUp(() {
      notifier = LocaleNotifier();
    });

    test('initial state is null', () {
      expect(notifier.state, isNull);
      expect(notifier.hasSelectedLanguage, isFalse);
    });

    test('setLocale sets valid locale', () {
      notifier.setLocale('en');
      expect(notifier.state, const Locale('en'));
      expect(notifier.hasSelectedLanguage, isTrue);
    });

    test('setLocale ignores unsupported language', () {
      notifier.setLocale('ja');
      expect(notifier.state, isNull);
      expect(notifier.hasSelectedLanguage, isFalse);
    });

    test('supports all 5 languages', () {
      for (final lang in ['en', 'zh', 'vi', 'ko', 'pt']) {
        notifier.setLocale(lang);
        expect(notifier.state, Locale(lang));
      }
    });

    test('clearLocale resets state', () {
      notifier.setLocale('zh');
      expect(notifier.hasSelectedLanguage, isTrue);

      notifier.clearLocale();
      expect(notifier.state, isNull);
      expect(notifier.hasSelectedLanguage, isFalse);
    });
  });
}
