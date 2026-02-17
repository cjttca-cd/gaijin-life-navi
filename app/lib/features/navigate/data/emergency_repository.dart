import 'package:dio/dio.dart';

import '../domain/emergency_data.dart';

/// Repository for Emergency API — GET /api/v1/emergency.
///
/// No authentication required. Provides emergency contacts and guide.
class EmergencyRepository {
  const EmergencyRepository({required this.apiClient});

  final Dio apiClient;

  /// Fetch emergency contacts and guide.
  Future<EmergencyData> getEmergency() async {
    final response = await apiClient.get<Map<String, dynamic>>('/emergency');
    return EmergencyData.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }
}
