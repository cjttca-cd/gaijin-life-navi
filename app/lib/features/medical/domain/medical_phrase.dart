/// A medical phrase with Japanese text, reading, and translation.
class MedicalPhrase {
  const MedicalPhrase({
    required this.id,
    required this.category,
    required this.phraseJa,
    this.phraseReading,
    required this.translation,
    this.context,
  });

  final String id;
  final String category;
  final String phraseJa;
  final String? phraseReading;
  final String translation;
  final String? context;

  factory MedicalPhrase.fromJson(Map<String, dynamic> json) {
    return MedicalPhrase(
      id: json['id'] as String,
      category: json['category'] as String? ?? '',
      phraseJa: json['phrase_ja'] as String? ?? '',
      phraseReading: json['phrase_reading'] as String?,
      translation: json['translation'] as String? ?? '',
      context: json['context'] as String?,
    );
  }
}
