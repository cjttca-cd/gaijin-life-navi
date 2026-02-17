import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/subscription/domain/subscription_plan.dart';

void main() {
  group('SubscriptionPlan', () {
    test('fromJson creates valid instance with List<String> features', () {
      final json = {
        'id': 'premium_monthly',
        'name': 'Premium',
        'price': 500,
        'currency': 'jpy',
        'interval': 'month',
        'features': ['Unlimited AI chat', '30 document scans/month', 'No ads'],
      };

      final plan = SubscriptionPlan.fromJson(json);

      expect(plan.id, 'premium_monthly');
      expect(plan.name, 'Premium');
      expect(plan.price, 500);
      expect(plan.currency, 'jpy');
      expect(plan.interval, 'month');
      expect(plan.features, isA<List<String>>());
      expect(plan.features.length, 3);
      expect(plan.features.first, 'Unlimited AI chat');
      expect(plan.isFree, isFalse);
    });

    test('fromJson handles free plan (null interval)', () {
      final json = {
        'id': 'free',
        'name': 'Free',
        'price': 0,
        'currency': 'JPY',
        'interval': null,
        'features': ['5 AI chats/day', '3 tracker items'],
      };

      final plan = SubscriptionPlan.fromJson(json);

      expect(plan.id, 'free');
      expect(plan.price, 0);
      expect(plan.interval, isNull);
      expect(plan.isFree, isTrue);
      expect(plan.features, hasLength(2));
    });

    test('fromJson handles missing optional fields', () {
      final json = {'id': 'basic'};

      final plan = SubscriptionPlan.fromJson(json);

      expect(plan.id, 'basic');
      expect(plan.name, '');
      expect(plan.price, 0);
      expect(plan.currency, 'JPY');
      expect(plan.features, isEmpty);
    });
  });

  group('ChargePack', () {
    test('fromJson creates valid instance', () {
      final json = {'chats': 100, 'price': 360, 'unit_price': 3.6};

      final pack = ChargePack.fromJson(json);

      expect(pack.chats, 100);
      expect(pack.price, 360);
      expect(pack.unitPrice, 3.6);
    });
  });

  group('PlansData', () {
    test('fromJson creates valid instance with plans and charge_packs', () {
      final json = {
        'plans': [
          {
            'id': 'free',
            'name': 'Free',
            'price': 0,
            'currency': 'JPY',
            'interval': null,
            'features': ['5 AI chats/day'],
          },
          {
            'id': 'premium_monthly',
            'name': 'Premium',
            'price': 500,
            'currency': 'jpy',
            'interval': 'month',
            'features': ['Unlimited AI chat', 'No ads'],
          },
        ],
        'charge_packs': [
          {'chats': 100, 'price': 360, 'unit_price': 3.6},
          {'chats': 50, 'price': 180, 'unit_price': 3.6},
        ],
      };

      final data = PlansData.fromJson(json);

      expect(data.plans.length, 2);
      expect(data.chargePacks.length, 2);
      expect(data.plans.first.id, 'free');
      expect(data.chargePacks.first.chats, 100);
    });

    test('fromJson handles empty data', () {
      final json = <String, dynamic>{};

      final data = PlansData.fromJson(json);

      expect(data.plans, isEmpty);
      expect(data.chargePacks, isEmpty);
    });

    test('fromList creates PlansData from flat list (backend format)', () {
      final list = [
        {
          'id': 'premium_monthly',
          'name': 'Premium',
          'price': 500,
          'currency': 'jpy',
          'interval': 'month',
          'features': ['Unlimited AI chat', 'No ads'],
        },
        {
          'id': 'premium_plus_monthly',
          'name': 'Premium+',
          'price': 1500,
          'currency': 'jpy',
          'interval': 'month',
          'features': ['Everything in Premium', 'Priority AI responses'],
        },
      ];

      final data = PlansData.fromList(list);

      expect(data.plans.length, 2);
      expect(data.chargePacks, isEmpty);
      expect(data.plans.first.id, 'premium_monthly');
      expect(data.plans.last.features, contains('Priority AI responses'));
    });
  });
}
