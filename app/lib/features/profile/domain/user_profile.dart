/// User profile model matching GET /api/v1/users/me response.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.nationality,
    this.residenceStatus,
    this.residenceRegion,
    this.arrivalDate,
    required this.preferredLanguage,
    required this.subscriptionTier,
    required this.onboardingCompleted,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String? nationality;
  final String? residenceStatus;
  final String? residenceRegion;
  final String? arrivalDate;
  final String preferredLanguage;
  final String subscriptionTier;
  final bool onboardingCompleted;
  final DateTime createdAt;

  /// Human-readable tier label.
  String get tierLabel {
    switch (subscriptionTier) {
      case 'premium':
        return 'Premium';
      case 'premium_plus':
        return 'Premium+';
      default:
        return 'Free';
    }
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      nationality: json['nationality'] as String?,
      residenceStatus: json['residence_status'] as String?,
      residenceRegion: json['residence_region'] as String?,
      arrivalDate: json['arrival_date'] as String?,
      preferredLanguage: json['preferred_language'] as String? ?? 'en',
      subscriptionTier: json['subscription_tier'] as String? ?? 'free',
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'nationality': nationality,
      'residence_status': residenceStatus,
      'residence_region': residenceRegion,
      'arrival_date': arrivalDate,
      'preferred_language': preferredLanguage,
      'subscription_tier': subscriptionTier,
      'onboarding_completed': onboardingCompleted,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
