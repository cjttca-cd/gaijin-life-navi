import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/banking/domain/bank.dart';
import 'package:gaijin_life_navi/features/banking/domain/bank_guide.dart';
import 'package:gaijin_life_navi/features/banking/domain/bank_recommendation.dart';

void main() {
  group('Bank', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'bank-1',
        'bank_code': 'mufg',
        'bank_name': 'MUFG Bank',
        'foreigner_friendly_score': 4,
        'multilingual_support': ['en', 'zh'],
        'features': {'monthly_fee': 0, 'online_banking': true},
        'logo_url': 'https://example.com/logo.png',
      };

      final bank = Bank.fromJson(json);

      expect(bank.id, 'bank-1');
      expect(bank.bankCode, 'mufg');
      expect(bank.bankName, 'MUFG Bank');
      expect(bank.foreignerFriendlyScore, 4);
      expect(bank.multilingualSupport, ['en', 'zh']);
      expect(bank.features['monthly_fee'], 0);
      expect(bank.logoUrl, 'https://example.com/logo.png');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'bank-2',
        'bank_code': 'smbc',
        'bank_name': 'SMBC',
        'foreigner_friendly_score': 3,
      };

      final bank = Bank.fromJson(json);

      expect(bank.multilingualSupport, isEmpty);
      expect(bank.features, isEmpty);
      expect(bank.logoUrl, isNull);
      expect(bank.requirements, isNull);
    });
  });

  group('BankRecommendation', () {
    test('fromJson creates valid instance', () {
      final json = {
        'bank': {
          'id': 'bank-1',
          'bank_code': 'mufg',
          'bank_name': 'MUFG Bank',
          'foreigner_friendly_score': 4,
        },
        'match_score': 85,
        'match_reasons': ['Supports English', 'No monthly fee'],
        'warnings': ['May require 6 months residence'],
      };

      final rec = BankRecommendation.fromJson(json);

      expect(rec.bank.bankName, 'MUFG Bank');
      expect(rec.matchScore, 85);
      expect(rec.matchReasons.length, 2);
      expect(rec.warnings.length, 1);
    });
  });

  group('BankGuide', () {
    test('fromJson creates valid instance from flat backend response', () {
      // Backend returns bank fields at root level (flat), not nested.
      final json = {
        'id': 'bank-1',
        'bank_code': 'mufg',
        'bank_name': 'MUFG Bank',
        'foreigner_friendly_score': 4,
        'requirements': {
          'residence_card': true,
          'min_stay_months': 0,
          'documents': ['residence_card', 'passport'],
        },
        'conversation_templates': [
          {
            'situation': 'Opening account',
            'ja': '口座を開設したいです',
            'reading': 'こうざをかいせつしたいです',
            'translation': 'I would like to open an account',
          },
        ],
        'troubleshooting': [
          {
            'problem': "Can't open account without a seal",
            'solution': 'MUFG accepts signature instead of seal.',
          },
        ],
        'source_url': 'https://www.mufg.jp/',
      };

      final guide = BankGuide.fromJson(json);

      expect(guide.bank.bankName, 'MUFG Bank');
      expect(guide.requirements['residence_card'], true);
      expect(guide.requirements['documents'], ['residence_card', 'passport']);
      expect(guide.conversationTemplates.length, 1);
      expect(guide.conversationTemplates.first.japanese, '口座を開設したいです');
      expect(guide.troubleshooting, isNotNull);
      expect(guide.troubleshooting!.length, 1);
      expect(guide.troubleshooting!.first.problem,
          "Can't open account without a seal");
      expect(guide.troubleshooting!.first.solution,
          contains('signature'));
      expect(guide.sourceUrl, 'https://www.mufg.jp/');
    });
  });

  group('ConversationTemplate', () {
    test('fromJson creates valid instance with ja key', () {
      final json = {
        'situation': 'Checking balance',
        'ja': '残高を確認したいです',
        'reading': 'ざんだかをかくにんしたいです',
        'translation': 'I want to check my balance',
      };

      final template = ConversationTemplate.fromJson(json);

      expect(template.situation, 'Checking balance');
      expect(template.japanese, '残高を確認したいです');
      expect(template.reading, 'ざんだかをかくにんしたいです');
      expect(template.translation, 'I want to check my balance');
    });
  });

  group('TroubleshootingItem', () {
    test('fromJson creates valid instance', () {
      final json = {
        'problem': 'Need a Japanese phone number',
        'solution': 'Get a SIM card first.',
      };

      final item = TroubleshootingItem.fromJson(json);

      expect(item.problem, 'Need a Japanese phone number');
      expect(item.solution, 'Get a SIM card first.');
    });
  });
}
