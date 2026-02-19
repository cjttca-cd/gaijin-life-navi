import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/profile/domain/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 'test_uid',
        'email': 'test@example.com',
        'display_name': 'Test User',
        'nationality': 'US',
        'residence_status': 'engineer_specialist',
        'residence_region': '東京都 新宿区',
        'visa_expiry': '2027-03-15',
        'preferred_language': 'en',
        'subscription_tier': 'free',
        'onboarding_completed': true,
        'created_at': '2026-02-16T02:25:00Z',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.id, 'test_uid');
      expect(profile.email, 'test@example.com');
      expect(profile.displayName, 'Test User');
      expect(profile.nationality, 'US');
      expect(profile.residenceStatus, 'engineer_specialist');
      expect(profile.residenceRegion, '東京都 新宿区');
      expect(profile.visaExpiry, '2027-03-15');
      expect(profile.preferredLanguage, 'en');
      expect(profile.subscriptionTier, 'free');
      expect(profile.onboardingCompleted, true);
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'id': 'uid1',
        'email': 'a@b.com',
        'display_name': '',
        'subscription_tier': 'free',
        'onboarding_completed': false,
        'created_at': '2026-01-01T00:00:00Z',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.nationality, isNull);
      expect(profile.residenceStatus, isNull);
      expect(profile.residenceRegion, isNull);
      expect(profile.visaExpiry, isNull);
      expect(profile.preferredLanguage, isNull);
    });

    test('tierLabel returns correct labels', () {
      expect(UserProfile.fromJson(_minJson(tier: 'free')).tierLabel, 'Free');
      expect(
        UserProfile.fromJson(_minJson(tier: 'standard')).tierLabel,
        'Standard',
      );
      expect(
        UserProfile.fromJson(_minJson(tier: 'premium')).tierLabel,
        'Premium',
      );
    });

    test('toJson produces correct keys', () {
      final profile = UserProfile.fromJson({
        'id': 'uid',
        'email': 'e@e.com',
        'display_name': 'Name',
        'nationality': 'JP',
        'visa_expiry': '2027-06-01',
        'preferred_language': 'zh',
        'subscription_tier': 'premium',
        'onboarding_completed': true,
        'created_at': '2026-02-16T00:00:00Z',
      });

      final json = profile.toJson();

      expect(json['id'], 'uid');
      expect(json['display_name'], 'Name');
      expect(json['nationality'], 'JP');
      expect(json['visa_expiry'], '2027-06-01');
      expect(json['preferred_language'], 'zh');
      expect(json['subscription_tier'], 'premium');
    });
  });
}

Map<String, dynamic> _minJson({String tier = 'free'}) {
  return {
    'id': 'uid',
    'email': 'e@e.com',
    'display_name': '',
    'subscription_tier': tier,
    'onboarding_completed': false,
    'created_at': '2026-01-01T00:00:00Z',
  };
}
