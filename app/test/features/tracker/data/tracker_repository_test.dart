import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gaijin_life_navi/features/tracker/data/tracker_repository.dart';
import 'package:gaijin_life_navi/features/tracker/domain/tracker_item.dart';

void main() {
  late TrackerRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repo = TrackerRepository(prefs: prefs);
  });

  TrackerItem makeItem({
    String id = 'id_1',
    String type = 'deadline',
    String title = 'Open bank account',
    String? date = '2026-04-01',
    TrackerStatus status = TrackerStatus.notStarted,
  }) {
    return TrackerItem(
      id: id,
      type: type,
      title: title,
      date: date,
      status: status,
      savedAt: DateTime(2026, 2, 18),
    );
  }

  group('TrackerRepository', () {
    test('getAll returns empty list initially', () {
      expect(repo.getAll(), isEmpty);
    });

    test('save adds item and getAll retrieves it', () async {
      final item = makeItem();
      final success = await repo.save(item);

      expect(success, isTrue);
      final items = repo.getAll();
      expect(items.length, 1);
      expect(items.first.title, 'Open bank account');
    });

    test('save multiple items and getAll returns all', () async {
      await repo.save(makeItem(id: '1', title: 'Task A'));
      await repo.save(makeItem(id: '2', title: 'Task B'));
      await repo.save(makeItem(id: '3', title: 'Task C'));

      expect(repo.getAll().length, 3);
    });

    test('save rejects duplicate (same type + title)', () async {
      await repo.save(makeItem(id: '1', title: 'Bank Account'));
      final success = await repo.save(makeItem(id: '2', title: 'Bank Account'));

      expect(success, isFalse);
      expect(repo.getAll().length, 1);
    });

    test('duplicate check is case-insensitive', () async {
      await repo.save(makeItem(id: '1', title: 'Bank Account'));
      final success = await repo.save(makeItem(id: '2', title: 'bank account'));

      expect(success, isFalse);
    });

    test('updateStatus changes status', () async {
      await repo.save(makeItem(id: 'x'));

      await repo.updateStatus('x', TrackerStatus.inProgress);
      expect(repo.getAll().first.status, TrackerStatus.inProgress);

      await repo.updateStatus('x', TrackerStatus.completed);
      expect(repo.getAll().first.status, TrackerStatus.completed);
    });

    test('updateStatus returns false for non-existent id', () async {
      final result = await repo.updateStatus('ghost', TrackerStatus.completed);
      expect(result, isFalse);
    });

    test('delete removes item', () async {
      await repo.save(makeItem(id: 'a', title: 'A'));
      await repo.save(makeItem(id: 'b', title: 'B'));

      await repo.delete('a');
      final items = repo.getAll();
      expect(items.length, 1);
      expect(items.first.id, 'b');
    });

    test('delete non-existent id does not throw', () async {
      await repo.save(makeItem(id: 'a'));
      await repo.delete('nonexistent');
      expect(repo.getAll().length, 1);
    });

    test('count returns correct number', () async {
      expect(repo.count, 0);
      await repo.save(makeItem(id: '1', title: 'A'));
      expect(repo.count, 1);
      await repo.save(makeItem(id: '2', title: 'B'));
      expect(repo.count, 2);
    });

    test('isLimitReached returns true for free tier at 3 items', () async {
      await repo.save(makeItem(id: '1', title: 'A'));
      await repo.save(makeItem(id: '2', title: 'B'));
      await repo.save(makeItem(id: '3', title: 'C'));

      expect(repo.isLimitReached('free'), isTrue);
      expect(repo.isLimitReached('standard'), isFalse);
      expect(repo.isLimitReached('premium'), isFalse);
    });

    test('isLimitReached returns false for free tier under 3 items', () async {
      await repo.save(makeItem(id: '1', title: 'A'));
      await repo.save(makeItem(id: '2', title: 'B'));

      expect(repo.isLimitReached('free'), isFalse);
    });

    test('free tier limit is exactly 3 per BUSINESS_RULES.md §2', () {
      expect(TrackerRepository.freeTierLimit, 3);
    });

    test('isDuplicate checks type and title', () async {
      await repo.save(makeItem(type: 'deadline', title: 'Bank'));

      expect(repo.isDuplicate('deadline', 'Bank'), isTrue);
      expect(repo.isDuplicate('deadline', 'bank'), isTrue);
      expect(repo.isDuplicate('task', 'Bank'), isFalse);
      expect(repo.isDuplicate('deadline', 'Visa'), isFalse);
    });

    test('items are sorted by savedAt descending (newest first)', () async {
      final item1 = TrackerItem(
        id: '1',
        type: 'task',
        title: 'First',
        status: TrackerStatus.notStarted,
        savedAt: DateTime(2026, 1, 1),
      );
      final item2 = TrackerItem(
        id: '2',
        type: 'task',
        title: 'Second',
        status: TrackerStatus.notStarted,
        savedAt: DateTime(2026, 3, 1),
      );

      await repo.save(item1);
      await repo.save(item2);

      final items = repo.getAll();
      expect(items.first.title, 'Second');
      expect(items.last.title, 'First');
    });
  });
}
