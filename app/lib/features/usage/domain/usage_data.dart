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

  /// Parse from backend JSON (SSOT field names):
  ///   queries_used_today, daily_limit, monthly_limit, tier
  factory UsageData.fromJson(Map<String, dynamic> json) {
    final queriesUsed = json['queries_used_today'] as int? ?? 0;
    final dailyLimit = json['daily_limit'] as int?;
    final monthlyLimit = json['monthly_limit'] as int?;

    // Use daily_limit if set, otherwise monthly_limit.
    final effectiveLimit = dailyLimit ?? monthlyLimit;

    // Compute remaining from limit − used.
    final int? remaining;
    if (effectiveLimit != null) {
      remaining = (effectiveLimit - queriesUsed).clamp(0, effectiveLimit);
    } else {
      remaining = null; // unlimited
    }

    // Derive period: daily if daily_limit is set, else monthly.
    final period = dailyLimit != null ? 'day' : 'month';

    return UsageData(
      chatCount: queriesUsed,
      chatLimit: effectiveLimit,
      chatRemaining: remaining,
      period: period,
      tier: json['tier'] as String? ?? 'free',
    );
  }
}
