/// A subscription plan offered to the user.
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.interval,
    required this.features,
  });

  final String id;
  final String name;
  final int price;
  final String currency;
  final String interval;
  final List<String> features;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'jpy',
      interval: json['interval'] as String? ?? 'month',
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

/// The user's current subscription status.
class UserSubscription {
  const UserSubscription({
    this.id,
    required this.tier,
    this.status,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
    this.cancelledAt,
    this.createdAt,
  });

  final String? id;
  final String tier;
  final String? status;
  final String? stripeCustomerId;
  final String? stripeSubscriptionId;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;
  final DateTime? cancelledAt;
  final DateTime? createdAt;

  bool get isFree => tier == 'free';
  bool get isPremium => tier == 'premium' || tier == 'premium_plus';
  bool get isPremiumPlus => tier == 'premium_plus';
  bool get isActive => status == 'active';
  bool get isCancelling => cancelAtPeriodEnd && isActive;

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] as String?,
      tier: json['tier'] as String? ?? 'free',
      status: json['status'] as String?,
      stripeCustomerId: json['stripe_customer_id'] as String?,
      stripeSubscriptionId: json['stripe_subscription_id'] as String?,
      currentPeriodEnd:
          json['current_period_end'] != null
              ? DateTime.tryParse(json['current_period_end'] as String)
              : null,
      cancelAtPeriodEnd: json['cancel_at_period_end'] as bool? ?? false,
      cancelledAt:
          json['cancelled_at'] != null
              ? DateTime.tryParse(json['cancelled_at'] as String)
              : null,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
    );
  }
}
