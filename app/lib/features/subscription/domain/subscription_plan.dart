/// A subscription plan from GET /api/v1/subscriptions/plans.
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    this.interval,
    required this.features,
  });

  final String id;
  final String name;
  final int price;
  final String currency;

  /// null for free plan, "month" for paid.
  final String? interval;

  /// Feature descriptions (backend returns a list of strings).
  final List<String> features;

  bool get isFree => id == 'free';

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'JPY',
      interval: json['interval'] as String?,
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

/// A charge pack option.
class ChargePack {
  const ChargePack({
    required this.chats,
    required this.price,
    required this.unitPrice,
  });

  final int chats;
  final int price;
  final double unitPrice;

  factory ChargePack.fromJson(Map<String, dynamic> json) {
    return ChargePack(
      chats: json['chats'] as int? ?? 0,
      price: json['price'] as int? ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Plans data combining plans + charge packs.
class PlansData {
  const PlansData({required this.plans, required this.chargePacks});

  final List<SubscriptionPlan> plans;
  final List<ChargePack> chargePacks;

  /// Parse from a JSON map with "plans" and optional "charge_packs" keys.
  factory PlansData.fromJson(Map<String, dynamic> json) {
    return PlansData(
      plans:
          (json['plans'] as List<dynamic>?)
              ?.map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      chargePacks:
          (json['charge_packs'] as List<dynamic>?)
              ?.map((e) => ChargePack.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  /// Create from a flat list of plans (backend returns data as List directly).
  factory PlansData.fromList(List<dynamic> list) {
    return PlansData(
      plans:
          list
              .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
              .toList(),
      chargePacks: const [],
    );
  }
}
