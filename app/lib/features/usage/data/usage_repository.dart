import 'package:dio/dio.dart';

import '../domain/usage_data.dart';

/// Repository for Usage API — GET /api/v1/usage.
class UsageRepository {
  const UsageRepository({required this.apiClient});

  final Dio apiClient;

  /// Fetch current usage data (chat count, limits, tier).
  Future<UsageData> getUsage() async {
    final response = await apiClient.get<Map<String, dynamic>>('/usage');
    return UsageData.fromJson(response.data!['data'] as Map<String, dynamic>);
  }
}
