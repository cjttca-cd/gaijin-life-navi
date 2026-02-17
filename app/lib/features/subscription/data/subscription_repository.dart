import 'package:dio/dio.dart';

import '../domain/subscription_plan.dart';

/// Repository for Subscription/Plans API — Phase 0 (IAP).
///
/// Stripe checkout has been removed. IAP purchase implementation
/// is a separate task.
class SubscriptionRepository {
  SubscriptionRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// GET /api/v1/subscriptions/plans — fetch available plans + charge packs.
  Future<PlansData> getPlans() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/subscriptions/plans',
    );
    final data = response.data!['data'];

    // Backend returns a flat list of plans (no charge_packs wrapper).
    if (data is List) {
      return PlansData.fromList(data);
    }

    // Fallback: if backend returns {"plans": [...], "charge_packs": [...]}.
    return PlansData.fromJson(data as Map<String, dynamic>);
  }
}
