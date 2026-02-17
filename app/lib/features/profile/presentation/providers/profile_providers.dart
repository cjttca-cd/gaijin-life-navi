import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/profile_repository.dart';
import '../../domain/user_profile.dart';

// ─── DI ──────────────────────────────────────────────────────

/// Dio client for App Service (profile).
final _profileDioProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Profile repository provider.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(apiClient: ref.watch(_profileDioProvider));
});

// ─── Profile Data ────────────────────────────────────────────

/// Current user profile — auto-refresh on invalidation.
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getProfile();
});

/// Update profile and refresh provider.
final updateProfileProvider =
    FutureProvider.family<UserProfile, Map<String, dynamic>>((
      ref,
      fields,
    ) async {
      final repo = ref.read(profileRepositoryProvider);
      final updated = await repo.updateProfile(fields);
      ref.invalidate(userProfileProvider);
      return updated;
    });
