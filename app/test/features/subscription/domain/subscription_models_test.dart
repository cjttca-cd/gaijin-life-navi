import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/subscription/domain/subscription_plan.dart';

void main() {
  group('SubscriptionPlan', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'premium_monthly',
        'name': 'Premium',
        'price': 500,
        'currency': 'jpy',
        'interval': 'month',
        'features': [
          'Unlimited AI chat',
          '30 document scans/month',
          'Community Q&A posting',
        ],
      };

      final plan = SubscriptionPlan.fromJson(json);

      expect(plan.id, 'premium_monthly');
      expect(plan.name, 'Premium');
      expect(plan.price, 500);
      expect(plan.currency, 'jpy');
      expect(plan.interval, 'month');
      expect(plan.features, hasLength(3));
      expect(plan.features.first, 'Unlimited AI chat');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'basic',
      };

      final plan = SubscriptionPlan.fromJson(json);

      expect(plan.id, 'basic');
      expect(plan.name, '');
      expect(plan.price, 0);
      expect(plan.currency, 'jpy');
      expect(plan.features, isEmpty);
    });
  });

  group('UserSubscription', () {
    test('fromJson creates free user', () {
      final json = {
        'tier': 'free',
        'status': null,
        'current_period_end': null,
        'cancel_at_period_end': false,
      };

      final sub = UserSubscription.fromJson(json);

      expect(sub.tier, 'free');
      expect(sub.isFree, isTrue);
      expect(sub.isPremium, isFalse);
      expect(sub.isPremiumPlus, isFalse);
      expect(sub.cancelAtPeriodEnd, isFalse);
    });

    test('fromJson creates premium user', () {
      final json = {
        'id': 'sub-1',
        'tier': 'premium',
        'status': 'active',
        'stripe_customer_id': 'cus_123',
        'stripe_subscription_id': 'sub_123',
        'current_period_end': '2026-03-16T10:00:00Z',
        'cancel_at_period_end': false,
        'created_at': '2026-02-16T10:00:00Z',
      };

      final sub = UserSubscription.fromJson(json);

      expect(sub.id, 'sub-1');
      expect(sub.tier, 'premium');
      expect(sub.isFree, isFalse);
      expect(sub.isPremium, isTrue);
      expect(sub.isPremiumPlus, isFalse);
      expect(sub.isActive, isTrue);
      expect(sub.isCancelling, isFalse);
      expect(sub.currentPeriodEnd, isNotNull);
      expect(sub.currentPeriodEnd!.month, 3);
    });

    test('fromJson creates premium_plus user', () {
      final json = {
        'id': 'sub-2',
        'tier': 'premium_plus',
        'status': 'active',
        'cancel_at_period_end': false,
      };

      final sub = UserSubscription.fromJson(json);

      expect(sub.isPremium, isTrue);
      expect(sub.isPremiumPlus, isTrue);
    });

    test('isCancelling is true when cancel_at_period_end and active', () {
      final json = {
        'tier': 'premium',
        'status': 'active',
        'cancel_at_period_end': true,
        'cancelled_at': '2026-02-20T10:00:00Z',
        'current_period_end': '2026-03-16T10:00:00Z',
      };

      final sub = UserSubscription.fromJson(json);

      expect(sub.isActive, isTrue);
      expect(sub.isCancelling, isTrue);
      expect(sub.cancelledAt, isNotNull);
    });

    test('fromJson handles missing fields gracefully', () {
      final json = <String, dynamic>{};

      final sub = UserSubscription.fromJson(json);

      expect(sub.tier, 'free');
      expect(sub.isFree, isTrue);
      expect(sub.status, isNull);
      expect(sub.cancelAtPeriodEnd, isFalse);
    });
  });
}
