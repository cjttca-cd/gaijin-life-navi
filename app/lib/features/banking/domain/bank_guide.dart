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
  final List<String> requirements;
  final List<ConversationTemplate> conversationTemplates;
  final List<String>? troubleshooting;
  final String? sourceUrl;

  factory BankGuide.fromJson(Map<String, dynamic> json) {
    return BankGuide(
      bank: Bank.fromJson(json['bank'] as Map<String, dynamic>),
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      conversationTemplates: (json['conversation_templates'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ConversationTemplate.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      troubleshooting: (json['troubleshooting'] as List<dynamic>?)
          ?.map((e) => e as String)
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
      japanese: json['japanese'] as String? ?? '',
      reading: json['reading'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
    );
  }
}
