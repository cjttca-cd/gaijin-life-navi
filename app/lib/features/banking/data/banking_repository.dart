import 'package:dio/dio.dart';

import '../domain/bank.dart';
import '../domain/bank_guide.dart';
import '../domain/bank_recommendation.dart';

/// Repository for Banking Navigator API operations.
class BankingRepository {
  BankingRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// Fetch bank list (public, sorted by foreigner_friendly_score).
  Future<List<Bank>> getBanks({String lang = 'en'}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/banking/banks',
      queryParameters: {'lang': lang},
    );
    final items = response.data!['data'] as List<dynamic>;
    return items.map((e) => Bank.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Get bank recommendations based on user profile and priorities.
  Future<List<BankRecommendation>> getRecommendations({
    List<String> priorities = const [],
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/banking/recommend',
      data: {if (priorities.isNotEmpty) 'priorities': priorities},
    );
    final items = response.data!['data'] as List<dynamic>;
    return items
        .map((e) => BankRecommendation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get detailed account opening guide for a specific bank.
  Future<BankGuide> getBankGuide(String bankId, {String lang = 'en'}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/banking/banks/$bankId/guide',
      queryParameters: {'lang': lang},
    );
    return BankGuide.fromJson(response.data!['data'] as Map<String, dynamic>);
  }
}
