/// Usage data from GET /api/v1/usage.
class UsageData {
  const UsageData({
    required this.chatCount,
    this.chatLimit,
    this.chatRemaining,
    required this.period,
    required this.tier,
  });

  final int chatCount;
  final int? chatLimit;
  final int? chatRemaining;

  /// "day" for free, "month" for paid tiers.
  final String period;
  final String tier;

  bool get isUnlimited => chatLimit == null;

  factory UsageData.fromJson(Map<String, dynamic> json) {
    return UsageData(
      chatCount: json['chat_count'] as int? ?? 0,
      chatLimit: json['chat_limit'] as int?,
      chatRemaining: json['chat_remaining'] as int?,
      period: json['period'] as String? ?? 'day',
      tier: json['tier'] as String? ?? 'free',
    );
  }
}
