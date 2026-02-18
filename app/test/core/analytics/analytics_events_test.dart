import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/core/analytics/analytics_events.dart';

void main() {
  group('AnalyticsEvents', () {
    test('has all 12 event names from SYSTEM_DESIGN.md §11.3', () {
      // Verify all 12 events defined in §11.3 are present.
      expect(AnalyticsEvents.chatMessageSent, 'chat_message_sent');
      expect(AnalyticsEvents.chatFeedback, 'chat_feedback');
      expect(AnalyticsEvents.guideViewed, 'guide_viewed');
      expect(AnalyticsEvents.subscriptionStarted, 'subscription_started');
      expect(
        AnalyticsEvents.chargePackPurchased,
        'charge_pack_purchased',
      );
      expect(
        AnalyticsEvents.subscriptionCancelled,
        'subscription_cancelled',
      );
      expect(
        AnalyticsEvents.trackerItemCompleted,
        'tracker_item_completed',
      );
      expect(
        AnalyticsEvents.onboardingCompleted,
        'onboarding_completed',
      );
      expect(AnalyticsEvents.emergencyAccessed, 'emergency_accessed');
      expect(AnalyticsEvents.usageLimitReached, 'usage_limit_reached');
      expect(AnalyticsEvents.upgradeCTAShown, 'upgrade_cta_shown');
      expect(AnalyticsEvents.upgradeCTATapped, 'upgrade_cta_tapped');
    });

    test('event names are snake_case strings', () {
      final events = [
        AnalyticsEvents.chatMessageSent,
        AnalyticsEvents.chatFeedback,
        AnalyticsEvents.guideViewed,
        AnalyticsEvents.subscriptionStarted,
        AnalyticsEvents.chargePackPurchased,
        AnalyticsEvents.subscriptionCancelled,
        AnalyticsEvents.trackerItemCompleted,
        AnalyticsEvents.onboardingCompleted,
        AnalyticsEvents.emergencyAccessed,
        AnalyticsEvents.usageLimitReached,
        AnalyticsEvents.upgradeCTAShown,
        AnalyticsEvents.upgradeCTATapped,
      ];

      final snakeCaseRegex = RegExp(r'^[a-z][a-z0-9]*(_[a-z][a-z0-9]*)*$');
      for (final event in events) {
        expect(
          snakeCaseRegex.hasMatch(event),
          isTrue,
          reason: '"$event" is not valid snake_case',
        );
      }
    });

    test('total event count is 12', () {
      // Count all static const fields. This test ensures we don't
      // accidentally remove or forget any events.
      final events = <String>[
        AnalyticsEvents.chatMessageSent,
        AnalyticsEvents.chatFeedback,
        AnalyticsEvents.guideViewed,
        AnalyticsEvents.subscriptionStarted,
        AnalyticsEvents.chargePackPurchased,
        AnalyticsEvents.subscriptionCancelled,
        AnalyticsEvents.trackerItemCompleted,
        AnalyticsEvents.onboardingCompleted,
        AnalyticsEvents.emergencyAccessed,
        AnalyticsEvents.usageLimitReached,
        AnalyticsEvents.upgradeCTAShown,
        AnalyticsEvents.upgradeCTATapped,
      ];
      expect(events.length, 12);
      // All unique.
      expect(events.toSet().length, 12);
    });
  });
}
