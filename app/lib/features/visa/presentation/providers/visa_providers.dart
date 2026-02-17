import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/visa_repository.dart';
import '../../domain/visa_procedure.dart';

/// Dio client for App Service.
final _visaDioProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Visa repository provider.
final visaRepositoryProvider = Provider<VisaRepository>((ref) {
  return VisaRepository(apiClient: ref.watch(_visaDioProvider));
});

/// Provider for the list of visa procedures.
/// Family parameter is optional residence status filter.
final visaProceduresProvider =
    FutureProvider.family<List<VisaProcedure>, String?>((ref, status) async {
      final repo = ref.watch(visaRepositoryProvider);
      return repo.getProcedures(status: status);
    });

/// Provider for a specific visa procedure detail.
final visaProcedureDetailProvider =
    FutureProvider.family<VisaProcedure, String>((ref, procedureId) async {
      final repo = ref.watch(visaRepositoryProvider);
      return repo.getProcedure(procedureId);
    });
