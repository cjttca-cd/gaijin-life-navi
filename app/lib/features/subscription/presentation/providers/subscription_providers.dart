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

/// Available plans data (plans + charge packs).
final plansDataProvider = FutureProvider<PlansData>((ref) async {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.getPlans();
});

/// Available subscription plans (convenience accessor).
final subscriptionPlansProvider = FutureProvider<List<SubscriptionPlan>>((
  ref,
) async {
  final data = await ref.watch(plansDataProvider.future);
  return data.plans;
});
