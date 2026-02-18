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
    String title = 'Open bank account',
    String? memo,
    DateTime? dueDate,
    bool completed = false,
  }) {
    return TrackerItem(
      id: id,
      title: title,
      memo: memo,
      dueDate: dueDate,
      completed: completed,
      createdAt: DateTime(2026, 2, 18),
    );
  }

  group('TrackerRepository', () {
    test('getAll returns empty list initially', () {
      expect(repo.getAll(), isEmpty);
    });

    test('add item and getAll retrieves it', () async {
      final item = makeItem();
      final success = await repo.add(item);

      expect(success, isTrue);
      final items = repo.getAll();
      expect(items.length, 1);
      expect(items.first.title, 'Open bank account');
    });

    test('add multiple items and getAll returns all', () async {
      await repo.add(makeItem(id: '1', title: 'Task A'));
      await repo.add(makeItem(id: '2', title: 'Task B'));
      await repo.add(makeItem(id: '3', title: 'Task C'));

      expect(repo.getAll().length, 3);
    });

    test('update changes item fields', () async {
      await repo.add(makeItem(id: 'x', title: 'Original'));

      final updated = makeItem(id: 'x', title: 'Updated');
      await repo.update(updated);

      expect(repo.getAll().first.title, 'Updated');
    });

    test('update returns false for non-existent id', () async {
      final result = await repo.update(makeItem(id: 'ghost'));
      expect(result, isFalse);
    });

    test('toggleComplete toggles completed state', () async {
      await repo.add(makeItem(id: 'x'));

      await repo.toggleComplete('x');
      expect(repo.getAll().first.completed, true);

      await repo.toggleComplete('x');
      expect(repo.getAll().first.completed, false);
    });

    test('toggleComplete returns false for non-existent id', () async {
      final result = await repo.toggleComplete('ghost');
      expect(result, isFalse);
    });

    test('delete removes item', () async {
      await repo.add(makeItem(id: 'a', title: 'A'));
      await repo.add(makeItem(id: 'b', title: 'B'));

      await repo.delete('a');
      final items = repo.getAll();
      expect(items.length, 1);
      expect(items.first.id, 'b');
    });

    test('delete non-existent id does not throw', () async {
      await repo.add(makeItem(id: 'a'));
      await repo.delete('nonexistent');
      expect(repo.getAll().length, 1);
    });

    test('count returns correct number', () async {
      expect(repo.count, 0);
      await repo.add(makeItem(id: '1', title: 'A'));
      expect(repo.count, 1);
      await repo.add(makeItem(id: '2', title: 'B'));
      expect(repo.count, 2);
    });

    test('incomplete items sorted before completed', () async {
      await repo.add(makeItem(id: '1', title: 'Done', completed: true));
      await repo.add(makeItem(id: '2', title: 'Not done', completed: false));

      final items = repo.getAll();
      expect(items.first.title, 'Not done');
      expect(items.last.title, 'Done');
    });

    test('incomplete items with dueDate sorted ascending', () async {
      await repo.add(makeItem(
        id: '1',
        title: 'Later',
        dueDate: DateTime(2026, 6, 1),
      ));
      await repo.add(makeItem(
        id: '2',
        title: 'Sooner',
        dueDate: DateTime(2026, 3, 1),
      ));

      final items = repo.getAll();
      expect(items.first.title, 'Sooner');
      expect(items.last.title, 'Later');
    });

    test('incomplete items without dueDate sorted after those with dueDate',
        () async {
      await repo.add(makeItem(id: '1', title: 'No date'));
      await repo.add(makeItem(
        id: '2',
        title: 'Has date',
        dueDate: DateTime(2026, 3, 1),
      ));

      final items = repo.getAll();
      expect(items.first.title, 'Has date');
      expect(items.last.title, 'No date');
    });
  });
}
