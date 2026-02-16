import 'package:dio/dio.dart';

import '../domain/user_profile.dart';

/// Repository for User Profile API operations.
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

  /// DELETE /api/v1/users/me — soft-delete account.
  Future<void> deleteAccount() async {
    await _client.delete<Map<String, dynamic>>('/users/me');
  }
}
