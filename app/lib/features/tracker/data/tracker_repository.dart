import 'package:shared_preferences/shared_preferences.dart';

import '../domain/tracker_item.dart';

/// SharedPreferences-based CRUD for to-do items.
///
/// Pure local storage — no backend required.
class TrackerRepository {
  TrackerRepository({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  /// SharedPreferences key for tracker items (v2 = todo rewrite).
  static const _storageKey = 'tracker_items_v2';

  /// Get all saved items.
  ///
  /// Sort order:
  /// 1. Incomplete items first, completed items last.
  /// 2. Within incomplete: items with dueDate sorted ascending, no-date last.
  /// 3. Within completed: most recently created first.
  List<TrackerItem> getAll() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final items = TrackerItem.decodeList(raw);
      items.sort(_compare);
      return items;
    } catch (_) {
      return [];
    }
  }

  /// Add a new item.
  Future<bool> add(TrackerItem item) async {
    final items = getAll();
    items.add(item);
    return _persist(items);
  }

  /// Update an existing item.
  Future<bool> update(TrackerItem item) async {
    final items = getAll();
    final index = items.indexWhere((e) => e.id == item.id);
    if (index == -1) return false;
    items[index] = item;
    return _persist(items);
  }

  /// Delete an item by ID.
  Future<bool> delete(String id) async {
    final items = getAll();
    items.removeWhere((e) => e.id == id);
    return _persist(items);
  }

  /// Remove all items with a given tag (e.g. 'visa_renewal').
  Future<bool> removeByTag(String tag) async {
    final items = getAll();
    items.removeWhere((e) => e.tag == tag);
    return _persist(items);
  }

  /// Toggle the completed state of an item.
  Future<bool> toggleComplete(String id) async {
    final items = getAll();
    final index = items.indexWhere((e) => e.id == id);
    if (index == -1) return false;
    items[index] = items[index].copyWith(completed: !items[index].completed);
    return _persist(items);
  }

  /// Current saved count.
  int get count => getAll().length;

  /// Sort comparator:
  /// - Incomplete before completed.
  /// - Within incomplete: by dueDate ascending (null last).
  /// - Within completed: by createdAt descending.
  int _compare(TrackerItem a, TrackerItem b) {
    // Completed items go last.
    if (a.completed != b.completed) {
      return a.completed ? 1 : -1;
    }

    if (!a.completed) {
      // Both incomplete — sort by dueDate ascending, null last.
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      if (a.dueDate != null) return -1;
      if (b.dueDate != null) return 1;
      // Both null dueDate — sort by createdAt descending (newest first).
      return b.createdAt.compareTo(a.createdAt);
    }

    // Both completed — most recently created first.
    return b.createdAt.compareTo(a.createdAt);
  }

  /// Persist items to SharedPreferences.
  Future<bool> _persist(List<TrackerItem> items) {
    return _prefs.setString(_storageKey, TrackerItem.encodeList(items));
  }
}
