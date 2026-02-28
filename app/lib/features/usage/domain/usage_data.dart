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

  /// "lifetime" for guest/free, "month" for standard, null for unlimited.
  final String period;
  final String tier;

  bool get isUnlimited => chatLimit == null;

  /// Parse from backend JSON.
  /// Supports new Plan C format: used, limit, period, tier
  /// Also backward-compatible with legacy: queries_used_today, daily_limit, monthly_limit
  factory UsageData.fromJson(Map<String, dynamic> json) {
    // New Plan C format (preferred)
    if (json.containsKey('used') && json.containsKey('period')) {
      final used = json['used'] as int? ?? 0;
      final limit = json['limit'] as int?;
      final period = json['period'] as String? ?? 'lifetime';
      final tier = json['tier'] as String? ?? 'free';

      final int? remaining;
      if (limit != null) {
        remaining = (limit - used).clamp(0, limit);
      } else {
        remaining = null;
      }

      return UsageData(
        chatCount: used,
        chatLimit: limit,
        chatRemaining: remaining,
        period: period,
        tier: tier,
      );
    }

    // Legacy format (backward compat)
    final queriesUsed = json['queries_used_today'] as int? ?? 0;
    final dailyLimit = json['daily_limit'] as int?;
    final monthlyLimit = json['monthly_limit'] as int?;

    final effectiveLimit = dailyLimit ?? monthlyLimit;

    final int? remaining;
    if (effectiveLimit != null) {
      remaining = (effectiveLimit - queriesUsed).clamp(0, effectiveLimit);
    } else {
      remaining = null;
    }

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
