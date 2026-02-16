import 'bank.dart';

/// Detailed account opening guide for a bank.
class BankGuide {
  const BankGuide({
    required this.bank,
    required this.requirements,
    required this.conversationTemplates,
    this.troubleshooting,
    this.sourceUrl,
  });

  final Bank bank;

  /// Requirements from backend: a map with keys like
  /// `residence_card`, `min_stay_months`, `documents`, etc.
  final Map<String, dynamic> requirements;
  final List<ConversationTemplate> conversationTemplates;

  /// Troubleshooting items from backend: list of {problem, solution} maps.
  final List<TroubleshootingItem>? troubleshooting;
  final String? sourceUrl;

  factory BankGuide.fromJson(Map<String, dynamic> json) {
    // Backend returns bank fields at root level (flat), not nested under 'bank'.
    // Pass the entire json to Bank.fromJson.
    return BankGuide(
      bank: Bank.fromJson(json),
      requirements: json['requirements'] is Map<String, dynamic>
          ? json['requirements'] as Map<String, dynamic>
          : <String, dynamic>{},
      conversationTemplates: (json['conversation_templates'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ConversationTemplate.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      troubleshooting: (json['troubleshooting'] as List<dynamic>?)
          ?.map((e) =>
              TroubleshootingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceUrl: json['source_url'] as String?,
    );
  }
}

/// A conversation template used at the bank.
class ConversationTemplate {
  const ConversationTemplate({
    required this.situation,
    required this.japanese,
    required this.reading,
    required this.translation,
  });

  final String situation;
  final String japanese;
  final String reading;
  final String translation;

  factory ConversationTemplate.fromJson(Map<String, dynamic> json) {
    return ConversationTemplate(
      situation: json['situation'] as String? ?? '',
      // Backend seed data uses 'ja' key, not 'japanese'.
      japanese: json['ja'] as String? ?? '',
      reading: json['reading'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
    );
  }
}

/// A troubleshooting item with problem and solution.
class TroubleshootingItem {
  const TroubleshootingItem({
    required this.problem,
    required this.solution,
  });

  final String problem;
  final String solution;

  factory TroubleshootingItem.fromJson(Map<String, dynamic> json) {
    return TroubleshootingItem(
      problem: json['problem'] as String? ?? '',
      solution: json['solution'] as String? ?? '',
    );
  }
}
