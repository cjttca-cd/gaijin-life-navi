import 'package:dio/dio.dart';

import '../domain/visa_procedure.dart';

/// Repository for Visa Navigator API operations.
class VisaRepository {
  VisaRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// Fetch visa procedures list, optionally filtered by residence status.
  Future<List<VisaProcedure>> getProcedures({
    String lang = 'en',
    String? status,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/visa/procedures',
      queryParameters: {
        'lang': lang,
        if (status != null) 'status': status,
      },
    );
    final items = response.data!['data'] as List<dynamic>;
    return items
        .map((e) => VisaProcedure.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch detailed procedure information.
  Future<VisaProcedure> getProcedure(String procedureId,
      {String lang = 'en'}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/visa/procedures/$procedureId',
      queryParameters: {'lang': lang},
    );
    return VisaProcedure.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }
}
