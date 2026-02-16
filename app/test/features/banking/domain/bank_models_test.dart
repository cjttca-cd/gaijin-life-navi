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
    test('fromJson creates valid instance', () {
      final json = {
        'bank': {
          'id': 'bank-1',
          'bank_code': 'mufg',
          'bank_name': 'MUFG Bank',
          'foreigner_friendly_score': 4,
        },
        'requirements': ['Passport', 'Residence card'],
        'conversation_templates': [
          {
            'situation': 'Opening account',
            'japanese': '口座を開設したいです',
            'reading': 'こうざをかいせつしたいです',
            'translation': 'I would like to open an account',
          },
        ],
        'troubleshooting': ['Bring hanko if required'],
        'source_url': 'https://www.mufg.jp/',
      };

      final guide = BankGuide.fromJson(json);

      expect(guide.bank.bankName, 'MUFG Bank');
      expect(guide.requirements.length, 2);
      expect(guide.conversationTemplates.length, 1);
      expect(guide.conversationTemplates.first.japanese, '口座を開設したいです');
      expect(guide.troubleshooting!.length, 1);
      expect(guide.sourceUrl, 'https://www.mufg.jp/');
    });
  });

  group('ConversationTemplate', () {
    test('fromJson creates valid instance', () {
      final json = {
        'situation': 'Checking balance',
        'japanese': '残高を確認したいです',
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
}
