import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/medical/domain/emergency_guide.dart';
import 'package:gaijin_life_navi/features/medical/domain/medical_phrase.dart';

void main() {
  group('EmergencyGuide', () {
    test('fromJson creates valid instance', () {
      final json = {
        'emergency_number': '119',
        'how_to_call': 'Dial 119 for fire and ambulance.',
        'what_to_prepare': 'Health insurance card, residence card',
        'useful_phrases': [
          'Kyuukyuusha wo onegaishimasu',
          'Eigo wo hanasemasu ka',
        ],
        'disclaimer': 'Not a substitute for medical advice.',
      };

      final guide = EmergencyGuide.fromJson(json);

      expect(guide.emergencyNumber, '119');
      expect(guide.howToCall, contains('119'));
      expect(guide.whatToPrepare, isNotEmpty);
      expect(guide.usefulPhrases.length, 2);
      expect(guide.disclaimer, isNotNull);
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final guide = EmergencyGuide.fromJson(json);

      expect(guide.emergencyNumber, '119');
      expect(guide.usefulPhrases, isEmpty);
    });
  });

  group('MedicalPhrase', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'phrase-1',
        'category': 'emergency',
        'phrase_ja': '救急車を呼んでください',
        'phrase_reading': 'きゅうきゅうしゃをよんでください',
        'translation': 'Please call an ambulance',
        'context': 'Use in emergency situations',
      };

      final phrase = MedicalPhrase.fromJson(json);

      expect(phrase.id, 'phrase-1');
      expect(phrase.category, 'emergency');
      expect(phrase.phraseJa, '救急車を呼んでください');
      expect(phrase.phraseReading, 'きゅうきゅうしゃをよんでください');
      expect(phrase.translation, 'Please call an ambulance');
      expect(phrase.context, 'Use in emergency situations');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'phrase-2',
        'category': 'symptom',
        'phrase_ja': '頭が痛いです',
        'translation': 'I have a headache',
      };

      final phrase = MedicalPhrase.fromJson(json);

      expect(phrase.phraseReading, isNull);
      expect(phrase.context, isNull);
    });
  });
}
