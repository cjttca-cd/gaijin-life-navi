import 'bank.dart';

/// A bank recommendation with match score and reasons.
class BankRecommendation {
  const BankRecommendation({
    required this.bank,
    required this.matchScore,
    required this.matchReasons,
    this.warnings = const [],
  });

  final Bank bank;
  final int matchScore;
  final List<String> matchReasons;
  final List<String> warnings;

  factory BankRecommendation.fromJson(Map<String, dynamic> json) {
    return BankRecommendation(
      bank: Bank.fromJson(json['bank'] as Map<String, dynamic>),
      matchScore: json['match_score'] as int,
      matchReasons: (json['match_reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
