import 'package:dio/dio.dart';

import '../domain/procedure_template.dart';
import '../domain/user_procedure.dart';

/// Repository for Admin Tracker API operations.
class TrackerRepository {
  TrackerRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// Fetch procedure templates for adding new procedures.
  Future<List<ProcedureTemplate>> getTemplates({
    String lang = 'en',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/procedures/templates',
      queryParameters: {'lang': lang},
    );
    final items = response.data!['data'] as List<dynamic>;
    return items
        .map((e) => ProcedureTemplate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch user's tracked procedures.
  Future<List<UserProcedure>> getMyProcedures({
    ProcedureStatus? status,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/procedures/my',
      queryParameters: {
        if (status != null) 'status': status.apiValue,
      },
    );
    final items = response.data!['data'] as List<dynamic>;
    return items
        .map((e) => UserProcedure.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Add a procedure to the tracking list.
  /// Throws DioException with 403 when Free tier limit (3) is reached.
  Future<UserProcedure> addProcedure({
    required String procedureRefType,
    required String procedureRefId,
    String? dueDate,
    String? notes,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/procedures/my',
      data: {
        'procedure_ref_type': procedureRefType,
        'procedure_ref_id': procedureRefId,
        if (dueDate != null) 'due_date': dueDate,
        if (notes != null) 'notes': notes,
      },
    );
    return UserProcedure.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }

  /// Update a tracked procedure (status, due_date, notes).
  Future<UserProcedure> updateProcedure(
    String id, {
    ProcedureStatus? status,
    String? dueDate,
    String? notes,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/procedures/my/$id',
      data: {
        if (status != null) 'status': status.apiValue,
        if (dueDate != null) 'due_date': dueDate,
        if (notes != null) 'notes': notes,
      },
    );
    return UserProcedure.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }

  /// Delete a tracked procedure (soft-delete).
  Future<void> deleteProcedure(String id) async {
    await _client.delete<void>('/procedures/my/$id');
  }
}
