import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/subscription/domain/subscription_plan.dart';

void main() {
  group('SubscriptionPlan', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'standard',
        'name': 'Standard',
        'price': 720,
        'currency': 'JPY',
        'interval': 'month',
        'features': {
          'chat_limit': '300/month',
          'tracker_limit': null,
          'ads': false,
        },
      };

      final plan = SubscriptionPlan.fromJson(json);

      expect(plan.id, 'standard');
      expect(plan.name, 'Standard');
      expect(plan.price, 720);
      expect(plan.currency, 'JPY');
      expect(plan.interval, 'month');
      expect(plan.features, isNotEmpty);
      expect(plan.isFree, isFalse);
    });

    test('fromJson handles free plan (null interval)', () {
      final json = {
        'id': 'free',
        'name': 'Free',
        'price': 0,
        'currency': 'JPY',
        'interval': null,
        'features': {'chat_limit': '5/day', 'tracker_limit': 3, 'ads': true},
      };

      final plan = SubscriptionPlan.fromJson(json);

      expect(plan.id, 'free');
      expect(plan.price, 0);
      expect(plan.interval, isNull);
      expect(plan.isFree, isTrue);
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
    test('fromJson creates valid instance', () {
      final json = {
        'plans': [
          {
            'id': 'free',
            'name': 'Free',
            'price': 0,
            'currency': 'JPY',
            'interval': null,
            'features': {'chat_limit': '5/day'},
          },
          {
            'id': 'standard',
            'name': 'Standard',
            'price': 720,
            'currency': 'JPY',
            'interval': 'month',
            'features': {'chat_limit': '300/month'},
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
  });
}
