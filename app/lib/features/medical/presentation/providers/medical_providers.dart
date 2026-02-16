import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/medical_repository.dart';
import '../../domain/emergency_guide.dart';
import '../../domain/medical_phrase.dart';

/// Dio client for App Service.
final _medicalDioProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Medical repository provider.
final medicalRepositoryProvider = Provider<MedicalRepository>((ref) {
  return MedicalRepository(apiClient: ref.watch(_medicalDioProvider));
});

/// Provider for the emergency guide.
final emergencyGuideProvider = FutureProvider<EmergencyGuide>((ref) async {
  final repo = ref.watch(medicalRepositoryProvider);
  return repo.getEmergencyGuide();
});

/// Provider for medical phrases.
/// Family parameter is optional category filter.
final medicalPhrasesProvider =
    FutureProvider.family<List<MedicalPhrase>, String?>(
  (ref, category) async {
    final repo = ref.watch(medicalRepositoryProvider);
    return repo.getPhrases(category: category);
  },
);
