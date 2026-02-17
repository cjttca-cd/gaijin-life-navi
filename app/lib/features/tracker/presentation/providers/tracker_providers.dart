import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/tracker_repository.dart';
import '../../domain/procedure_template.dart';
import '../../domain/user_procedure.dart';

/// Dio client for App Service.
final _trackerDioProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Tracker repository provider.
final trackerRepositoryProvider = Provider<TrackerRepository>((ref) {
  return TrackerRepository(apiClient: ref.watch(_trackerDioProvider));
});

/// Provider for user's tracked procedures.
final myProceduresProvider = FutureProvider<List<UserProcedure>>((ref) async {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.getMyProcedures();
});

/// Provider for procedure templates (for adding new ones).
final procedureTemplatesProvider = FutureProvider<List<ProcedureTemplate>>((
  ref,
) async {
  final repo = ref.watch(trackerRepositoryProvider);
  return repo.getTemplates();
});
