import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/tracker/domain/tracker_item.dart';

void main() {
  group('TrackerItem', () {
    final now = DateTime(2026, 2, 18, 12, 0);
    final sampleItem = TrackerItem(
      id: 'test_id_123',
      title: 'Open bank account',
      memo: 'Need passport and residence card',
      dueDate: DateTime(2026, 4, 1),
      completed: false,
      createdAt: now,
    );

    test('toJson creates valid map', () {
      final json = sampleItem.toJson();
      expect(json['id'], 'test_id_123');
      expect(json['title'], 'Open bank account');
      expect(json['memo'], 'Need passport and residence card');
      expect(json['dueDate'], DateTime(2026, 4, 1).toIso8601String());
      expect(json['completed'], false);
      expect(json['createdAt'], now.toIso8601String());
    });

    test('fromJson creates valid instance', () {
      final json = {
        'id': 'abc',
        'title': 'Get residence card',
        'memo': null,
        'dueDate': null,
        'completed': true,
        'createdAt': '2026-02-18T12:00:00.000',
      };

      final item = TrackerItem.fromJson(json);
      expect(item.id, 'abc');
      expect(item.title, 'Get residence card');
      expect(item.memo, isNull);
      expect(item.dueDate, isNull);
      expect(item.completed, true);
      expect(item.createdAt.year, 2026);
    });

    test('toJson/fromJson roundtrip is lossless', () {
      final json = sampleItem.toJson();
      final restored = TrackerItem.fromJson(json);
      expect(restored.id, sampleItem.id);
      expect(restored.title, sampleItem.title);
      expect(restored.memo, sampleItem.memo);
      expect(restored.dueDate, sampleItem.dueDate);
      expect(restored.completed, sampleItem.completed);
      expect(restored.createdAt, sampleItem.createdAt);
    });

    test('fromJson handles missing fields gracefully', () {
      final json = <String, dynamic>{};
      final item = TrackerItem.fromJson(json);
      expect(item.id, '');
      expect(item.title, '');
      expect(item.memo, isNull);
      expect(item.dueDate, isNull);
      expect(item.completed, false);
    });

    test('copyWith preserves unchanged fields', () {
      final updated = sampleItem.copyWith(completed: true);
      expect(updated.id, sampleItem.id);
      expect(updated.title, sampleItem.title);
      expect(updated.completed, true);
    });

    test('copyWith clearMemo and clearDueDate work', () {
      final cleared = sampleItem.copyWith(clearMemo: true, clearDueDate: true);
      expect(cleared.memo, isNull);
      expect(cleared.dueDate, isNull);
      expect(cleared.title, sampleItem.title);
    });

    test('encodeList and decodeList roundtrip', () {
      final items = [
        sampleItem,
        TrackerItem(
          id: 'second',
          title: 'Get health insurance',
          completed: false,
          createdAt: now,
        ),
      ];

      final encoded = TrackerItem.encodeList(items);
      final decoded = TrackerItem.decodeList(encoded);

      expect(decoded.length, 2);
      expect(decoded[0].id, 'test_id_123');
      expect(decoded[1].id, 'second');
      expect(decoded[1].completed, false);
    });

    test('generateId returns unique values', () {
      final ids = List.generate(100, (_) => TrackerItem.generateId());
      expect(ids.toSet().length, 100);
    });

    test('equality is based on id', () {
      final item1 = TrackerItem(
        id: 'same_id',
        title: 'Task A',
        completed: false,
        createdAt: now,
      );
      final item2 = TrackerItem(
        id: 'same_id',
        title: 'Task B',
        completed: true,
        createdAt: now,
      );
      final item3 = TrackerItem(
        id: 'different_id',
        title: 'Task A',
        completed: false,
        createdAt: now,
      );

      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });
  });
}
