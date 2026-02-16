/// Emergency guide content from the Medical Guide API.
class EmergencyGuide {
  const EmergencyGuide({
    required this.emergencyNumber,
    required this.howToCall,
    required this.whatToPrepare,
    this.usefulPhrases = const [],
    this.disclaimer,
  });

  final String emergencyNumber;
  final String howToCall;
  final String whatToPrepare;
  final List<String> usefulPhrases;
  final String? disclaimer;

  factory EmergencyGuide.fromJson(Map<String, dynamic> json) {
    return EmergencyGuide(
      emergencyNumber: json['emergency_number'] as String? ?? '119',
      howToCall: json['how_to_call'] as String? ?? '',
      whatToPrepare: json['what_to_prepare'] as String? ?? '',
      usefulPhrases: (json['useful_phrases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      disclaimer: json['disclaimer'] as String?,
    );
  }
}
