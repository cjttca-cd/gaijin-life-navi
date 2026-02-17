import 'package:dio/dio.dart';

import '../domain/subscription_plan.dart';

/// Repository for Subscription/Plans API — Phase 0 (IAP).
///
/// Stripe checkout has been removed. IAP purchase implementation
/// is a separate task.
class SubscriptionRepository {
  SubscriptionRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// GET /api/v1/subscription/plans — fetch available plans + charge packs.
  Future<PlansData> getPlans() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/subscription/plans',
    );
    return PlansData.fromJson(response.data!['data'] as Map<String, dynamic>);
  }
}
