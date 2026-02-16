import 'package:dio/dio.dart';

/// Repository for onboarding API operations against the App Service.
class OnboardingRepository {
  OnboardingRepository({required Dio appClient}) : _client = appClient;

  final Dio _client;

  /// Submit onboarding data.
  Future<void> submitOnboarding({
    String? nationality,
    String? residenceStatus,
    String? residenceRegion,
    String? arrivalDate,
  }) async {
    await _client.post<Map<String, dynamic>>(
      '/users/me/onboarding',
      data: {
        if (nationality != null) 'nationality': nationality,
        if (residenceStatus != null) 'residence_status': residenceStatus,
        if (residenceRegion != null) 'residence_region': residenceRegion,
        if (arrivalDate != null) 'arrival_date': arrivalDate,
      },
    );
  }
}
