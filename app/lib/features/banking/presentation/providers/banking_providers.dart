import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/banking_repository.dart';
import '../../domain/bank.dart';
import '../../domain/bank_guide.dart';
import '../../domain/bank_recommendation.dart';

/// Dio client for App Service.
final _bankingDioProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Banking repository provider.
final bankingRepositoryProvider = Provider<BankingRepository>((ref) {
  return BankingRepository(apiClient: ref.watch(_bankingDioProvider));
});

/// Provider for the list of banks.
final bankListProvider = FutureProvider<List<Bank>>((ref) async {
  final repo = ref.watch(bankingRepositoryProvider);
  return repo.getBanks();
});

/// Provider for bank recommendations.
/// Pass priorities as family parameter.
final bankRecommendationsProvider =
    FutureProvider.family<List<BankRecommendation>, List<String>>(
  (ref, priorities) async {
    final repo = ref.watch(bankingRepositoryProvider);
    return repo.getRecommendations(priorities: priorities);
  },
);

/// Provider for a specific bank guide.
final bankGuideProvider = FutureProvider.family<BankGuide, String>(
  (ref, bankId) async {
    final repo = ref.watch(bankingRepositoryProvider);
    return repo.getBankGuide(bankId);
  },
);
