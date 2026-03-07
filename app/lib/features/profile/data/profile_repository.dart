import 'package:dio/dio.dart';

import '../domain/user_profile.dart';

/// Repository for User Profile API operations.
///
/// Phase 0: Uses /users/me endpoints (GET, PATCH) as the primary interface.
/// Also supports /profile (GET, PUT) as alias endpoints.
class ProfileRepository {
  ProfileRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// GET /api/v1/users/me — fetch current user profile.
  Future<UserProfile> getProfile() async {
    final response = await _client.get<Map<String, dynamic>>('/users/me');
    final data = response.data!['data'] as Map<String, dynamic>;
    return UserProfile.fromJson(data);
  }

  /// PATCH /api/v1/users/me — update profile fields.
  Future<UserProfile> updateProfile(Map<String, dynamic> fields) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/users/me',
      data: fields,
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return UserProfile.fromJson(data);
  }

  /// POST /api/v1/auth/delete-account — delete account.
  Future<void> deleteAccount() async {
    await _client.post<Map<String, dynamic>>('/auth/delete-account');
  }

  /// POST /api/v1/profile/trial-setup — TestFlight trial profile setup.
  ///
  /// Creates a profile for anonymous TestFlight users with the 3 required
  /// fields and grants trial credits.
  Future<UserProfile> trialSetup({
    required String nationality,
    required String residenceStatus,
    required String residenceRegion,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/profile/trial-setup',
      data: {
        'nationality': nationality,
        'residence_status': residenceStatus,
        'residence_region': residenceRegion,
      },
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return UserProfile.fromJson(data);
  }
}
