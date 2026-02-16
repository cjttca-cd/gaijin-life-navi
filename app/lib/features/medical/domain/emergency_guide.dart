/// Emergency guide content from the Medical Guide API.
class EmergencyGuide {
  const EmergencyGuide({
    required this.emergencyNumber,
    required this.howToCall,
    required this.whatToPrepare,
    this.policeNumber,
    this.usefulPhrases = const [],
    this.importantNotes = const [],
    this.disclaimer,
  });

  final String emergencyNumber;

  /// Backend returns a list of steps, not a single string.
  final List<String> howToCall;

  /// Backend returns a list of items to prepare, not a single string.
  final List<String> whatToPrepare;

  /// Police number returned by backend (e.g. "110").
  final String? policeNumber;

  /// Backend returns phrases with `{ja, reading, translation}`.
  final List<EmergencyPhrase> usefulPhrases;

  /// Additional notes/helplines returned by backend.
  final List<String> importantNotes;

  final String? disclaimer;

  factory EmergencyGuide.fromJson(Map<String, dynamic> json) {
    return EmergencyGuide(
      emergencyNumber: json['emergency_number'] as String? ?? '119',
      howToCall: (json['how_to_call'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      whatToPrepare: (json['what_to_prepare'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      policeNumber: json['police_number'] as String?,
      usefulPhrases: (json['useful_phrases'] as List<dynamic>?)
              ?.map((e) =>
                  EmergencyPhrase.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      importantNotes: (json['important_notes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      disclaimer: json['disclaimer'] as String?,
    );
  }
}

/// A phrase in the emergency guide with Japanese text, reading, and translation.
class EmergencyPhrase {
  const EmergencyPhrase({
    required this.ja,
    required this.reading,
    required this.translation,
  });

  final String ja;
  final String reading;
  final String translation;

  factory EmergencyPhrase.fromJson(Map<String, dynamic> json) {
    return EmergencyPhrase(
      ja: json['ja'] as String? ?? '',
      reading: json['reading'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
    );
  }
}
