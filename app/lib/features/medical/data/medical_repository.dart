import 'package:dio/dio.dart';

import '../domain/emergency_guide.dart';
import '../domain/medical_phrase.dart';

/// Repository for Medical Guide API operations.
class MedicalRepository {
  MedicalRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// Fetch the emergency guide.
  Future<EmergencyGuide> getEmergencyGuide({String lang = 'en'}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/medical/emergency-guide',
      queryParameters: {'lang': lang},
    );
    return EmergencyGuide.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }

  /// Fetch medical phrases, optionally filtered by category.
  Future<List<MedicalPhrase>> getPhrases({
    String lang = 'en',
    String? category,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/medical/phrases',
      queryParameters: {
        'lang': lang,
        if (category != null) 'category': category,
      },
    );
    final items = response.data!['data'] as List<dynamic>;
    return items
        .map((e) => MedicalPhrase.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
