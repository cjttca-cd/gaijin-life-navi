import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/subscription_repository.dart';
import '../../domain/subscription_plan.dart';

// ─── DI ──────────────────────────────────────────────────────

/// Dio client for App Service.
final _subscriptionDioProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Subscription repository provider.
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(apiClient: ref.watch(_subscriptionDioProvider));
});

// ─── Plans ───────────────────────────────────────────────────

/// Available subscription plans.
final subscriptionPlansProvider = FutureProvider<List<SubscriptionPlan>>((
  ref,
) async {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.getPlans();
});

// ─── My Subscription ─────────────────────────────────────────

/// Current user's subscription status.
final mySubscriptionProvider = FutureProvider<UserSubscription>((ref) async {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.getMySubscription();
});

/// Convenience: whether the user is on a paid plan.
final isPremiumProvider = Provider<bool>((ref) {
  final sub = ref.watch(mySubscriptionProvider).valueOrNull;
  return sub != null && sub.isPremium;
});
