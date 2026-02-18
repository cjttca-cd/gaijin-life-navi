import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/tracker/domain/tracker_item.dart';

void main() {
  group('TrackerStatus', () {
    test('toJson and fromJson are symmetric', () {
      for (final status in TrackerStatus.values) {
        final json = status.toJson();
        final parsed = TrackerStatus.fromJson(json);
        expect(parsed, status);
      }
    });

    test('toJson returns snake_case strings', () {
      expect(TrackerStatus.notStarted.toJson(), 'not_started');
      expect(TrackerStatus.inProgress.toJson(), 'in_progress');
      expect(TrackerStatus.completed.toJson(), 'completed');
    });

    test('fromJson handles unknown values', () {
      expect(TrackerStatus.fromJson('unknown'), TrackerStatus.notStarted);
      expect(TrackerStatus.fromJson(''), TrackerStatus.notStarted);
    });

    test('next cycles correctly', () {
      expect(TrackerStatus.notStarted.next, TrackerStatus.inProgress);
      expect(TrackerStatus.inProgress.next, TrackerStatus.completed);
      expect(TrackerStatus.completed.next, TrackerStatus.notStarted);
    });
  });

  group('TrackerItem', () {
    final now = DateTime(2026, 2, 18, 12, 0);
    final sampleItem = TrackerItem(
      id: 'test_id_123',
      type: 'deadline',
      title: 'Open bank account',
      date: '2026-04-01',
      status: TrackerStatus.notStarted,
      savedAt: now,
    );

    test('toJson creates valid map', () {
      final json = sampleItem.toJson();
      expect(json['id'], 'test_id_123');
      expect(json['type'], 'deadline');
      expect(json['title'], 'Open bank account');
      expect(json['date'], '2026-04-01');
      expect(json['status'], 'not_started');
      expect(json['savedAt'], now.toIso8601String());
    });

    test('fromJson creates valid instance', () {
      final json = {
        'id': 'abc',
        'type': 'task',
        'title': 'Get residence card',
        'date': null,
        'status': 'in_progress',
        'savedAt': '2026-02-18T12:00:00.000',
      };

      final item = TrackerItem.fromJson(json);
      expect(item.id, 'abc');
      expect(item.type, 'task');
      expect(item.title, 'Get residence card');
      expect(item.date, isNull);
      expect(item.status, TrackerStatus.inProgress);
      expect(item.savedAt.year, 2026);
    });

    test('toJson/fromJson roundtrip is lossless', () {
      final json = sampleItem.toJson();
      final restored = TrackerItem.fromJson(json);
      expect(restored.id, sampleItem.id);
      expect(restored.type, sampleItem.type);
      expect(restored.title, sampleItem.title);
      expect(restored.date, sampleItem.date);
      expect(restored.status, sampleItem.status);
      expect(restored.savedAt, sampleItem.savedAt);
    });

    test('fromJson handles missing fields gracefully', () {
      final json = <String, dynamic>{};
      final item = TrackerItem.fromJson(json);
      expect(item.id, '');
      expect(item.type, '');
      expect(item.title, '');
      expect(item.date, isNull);
      expect(item.status, TrackerStatus.notStarted);
    });

    test('copyWith preserves unchanged fields', () {
      final updated = sampleItem.copyWith(status: TrackerStatus.completed);
      expect(updated.id, sampleItem.id);
      expect(updated.title, sampleItem.title);
      expect(updated.status, TrackerStatus.completed);
    });

    test('encodeList and decodeList roundtrip', () {
      final items = [
        sampleItem,
        TrackerItem(
          id: 'second',
          type: 'task',
          title: 'Get health insurance',
          status: TrackerStatus.inProgress,
          savedAt: now,
        ),
      ];

      final encoded = TrackerItem.encodeList(items);
      final decoded = TrackerItem.decodeList(encoded);

      expect(decoded.length, 2);
      expect(decoded[0].id, 'test_id_123');
      expect(decoded[1].id, 'second');
      expect(decoded[1].status, TrackerStatus.inProgress);
    });

    test('generateId returns unique values', () {
      final ids = List.generate(100, (_) => TrackerItem.generateId());
      expect(ids.toSet().length, 100);
    });

    test('equality is based on id', () {
      final item1 = TrackerItem(
        id: 'same_id',
        type: 'deadline',
        title: 'Task A',
        status: TrackerStatus.notStarted,
        savedAt: now,
      );
      final item2 = TrackerItem(
        id: 'same_id',
        type: 'task',
        title: 'Task B',
        status: TrackerStatus.completed,
        savedAt: now,
      );
      final item3 = TrackerItem(
        id: 'different_id',
        type: 'deadline',
        title: 'Task A',
        status: TrackerStatus.notStarted,
        savedAt: now,
      );

      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });
  });
}
