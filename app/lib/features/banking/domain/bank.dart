/// Represents a bank entry from the Banking Navigator API.
class Bank {
  const Bank({
    required this.id,
    required this.bankCode,
    required this.bankName,
    required this.foreignerFriendlyScore,
    required this.multilingualSupport,
    required this.features,
    this.requirements,
    this.logoUrl,
  });

  final String id;
  final String bankCode;
  final String bankName;
  final int foreignerFriendlyScore;
  final List<String> multilingualSupport;
  final Map<String, dynamic> features;
  final Map<String, dynamic>? requirements;
  final String? logoUrl;

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'] as String,
      bankCode: json['bank_code'] as String,
      bankName: json['bank_name'] as String,
      foreignerFriendlyScore: json['foreigner_friendly_score'] as int,
      multilingualSupport:
          (json['multilingual_support'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      features: json['features'] as Map<String, dynamic>? ?? {},
      requirements: json['requirements'] as Map<String, dynamic>?,
      logoUrl: json['logo_url'] as String?,
    );
  }
}
