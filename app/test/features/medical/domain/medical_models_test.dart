import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/medical/domain/emergency_guide.dart';
import 'package:gaijin_life_navi/features/medical/domain/medical_phrase.dart';

void main() {
  group('EmergencyGuide', () {
    test('fromJson creates valid instance from backend response', () {
      // Backend returns List<String> for how_to_call and what_to_prepare,
      // List<dict> for useful_phrases, and includes police_number & important_notes.
      final json = {
        'emergency_number': '119',
        'police_number': '110',
        'how_to_call': [
          'Dial 119 from any phone (free call)',
          "Say 'Kyuukyuu desu' (救急です)",
          'State your location clearly',
        ],
        'what_to_prepare': [
          'Residence card (在留カード)',
          'Health insurance card (健康保険証)',
        ],
        'useful_phrases': [
          {
            'ja': '救急車を呼んでください',
            'reading': 'きゅうきゅうしゃをよんでください',
            'translation': 'Please call an ambulance',
          },
          {
            'ja': 'ここが痛いです',
            'reading': 'ここがいたいです',
            'translation': 'It hurts here',
          },
        ],
        'important_notes': [
          'Japan Medical Info Service (AMDA): 03-6233-9266',
          'Japan Helpline: 0570-000-911 (24/7)',
        ],
        'disclaimer': 'Not a substitute for medical advice.',
      };

      final guide = EmergencyGuide.fromJson(json);

      expect(guide.emergencyNumber, '119');
      expect(guide.policeNumber, '110');
      expect(guide.howToCall.length, 3);
      expect(guide.howToCall.first, contains('119'));
      expect(guide.whatToPrepare.length, 2);
      expect(guide.usefulPhrases.length, 2);
      expect(guide.usefulPhrases.first.ja, '救急車を呼んでください');
      expect(guide.usefulPhrases.first.reading, 'きゅうきゅうしゃをよんでください');
      expect(guide.usefulPhrases.first.translation,
          'Please call an ambulance');
      expect(guide.importantNotes.length, 2);
      expect(guide.disclaimer, isNotNull);
    });

    test('fromJson handles missing fields with defaults', () {
      final json = <String, dynamic>{};

      final guide = EmergencyGuide.fromJson(json);

      expect(guide.emergencyNumber, '119');
      expect(guide.howToCall, isEmpty);
      expect(guide.whatToPrepare, isEmpty);
      expect(guide.usefulPhrases, isEmpty);
      expect(guide.importantNotes, isEmpty);
      expect(guide.policeNumber, isNull);
    });
  });

  group('EmergencyPhrase', () {
    test('fromJson creates valid instance', () {
      final json = {
        'ja': 'アレルギーがあります',
        'reading': 'アレルギーがあります',
        'translation': 'I have allergies',
      };

      final phrase = EmergencyPhrase.fromJson(json);

      expect(phrase.ja, 'アレルギーがあります');
      expect(phrase.reading, 'アレルギーがあります');
      expect(phrase.translation, 'I have allergies');
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
