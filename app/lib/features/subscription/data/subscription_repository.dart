import 'package:dio/dio.dart';

import '../domain/subscription_plan.dart';

/// Repository for Subscription API operations.
class SubscriptionRepository {
  SubscriptionRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// Fetch available subscription plans.
  Future<List<SubscriptionPlan>> getPlans() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/subscriptions/plans',
    );
    final items = response.data!['data'] as List;
    return items
        .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get current user's subscription status.
  Future<UserSubscription> getMySubscription() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/subscriptions/me',
    );
    return UserSubscription.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }

  /// Create a Stripe Checkout session. Returns checkout URL.
  Future<String> createCheckout({required String planId}) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/subscriptions/checkout',
      data: {'plan_id': planId},
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return data['checkout_url'] as String;
  }

  /// Cancel the current subscription (sets cancel_at_period_end=true).
  Future<void> cancelSubscription() async {
    await _client.post<Map<String, dynamic>>('/subscriptions/cancel');
  }
}
