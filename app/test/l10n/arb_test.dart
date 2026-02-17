import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ARB files', () {
    final arbDir = Directory('lib/l10n');
    final requiredLanguages = ['en', 'zh', 'vi', 'ko', 'pt'];

    test('all 5 language ARB files exist', () {
      for (final lang in requiredLanguages) {
        final file = File('${arbDir.path}/app_$lang.arb');
        expect(file.existsSync(), isTrue, reason: 'app_$lang.arb should exist');
      }
    });

    test('all ARB files are valid JSON', () {
      for (final lang in requiredLanguages) {
        final file = File('${arbDir.path}/app_$lang.arb');
        final content = file.readAsStringSync();
        expect(
          () => json.decode(content),
          returnsNormally,
          reason: 'app_$lang.arb should be valid JSON',
        );
      }
    });

    test('all ARB files have @@locale matching filename', () {
      for (final lang in requiredLanguages) {
        final file = File('${arbDir.path}/app_$lang.arb');
        final content =
            json.decode(file.readAsStringSync()) as Map<String, dynamic>;
        expect(
          content['@@locale'],
          lang,
          reason: 'app_$lang.arb @@locale should be $lang',
        );
      }
    });

    test('non-English ARB files have same keys as English', () {
      final enFile = File('${arbDir.path}/app_en.arb');
      final enContent =
          json.decode(enFile.readAsStringSync()) as Map<String, dynamic>;
      final enKeys = enContent.keys.where((k) => !k.startsWith('@')).toSet();

      for (final lang in requiredLanguages.where((l) => l != 'en')) {
        final file = File('${arbDir.path}/app_$lang.arb');
        final content =
            json.decode(file.readAsStringSync()) as Map<String, dynamic>;
        final keys = content.keys.where((k) => !k.startsWith('@')).toSet();

        // All English keys should be present in each language file.
        for (final key in enKeys) {
          expect(
            keys.contains(key),
            isTrue,
            reason: 'app_$lang.arb missing key: $key',
          );
        }
      }
    });
  });
}
