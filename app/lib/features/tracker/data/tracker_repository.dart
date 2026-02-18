import 'package:shared_preferences/shared_preferences.dart';

import '../domain/tracker_item.dart';

/// SharedPreferences-based CRUD for tracker items.
///
/// Phase 0: local-only storage. Phase 1+ will sync to server-side
/// `user_procedures` table (SSOT).
class TrackerRepository {
  TrackerRepository({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  /// SharedPreferences key for tracker items.
  static const _storageKey = 'tracker_items_v1';

  /// Free tier limit per BUSINESS_RULES.md §2.
  static const int freeTierLimit = 3;

  /// Get all saved tracker items, ordered by savedAt descending (newest first).
  List<TrackerItem> getAll() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final items = TrackerItem.decodeList(raw);
      items.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return items;
    } catch (_) {
      return [];
    }
  }

  /// Save a new tracker item. Returns `true` on success, `false` on failure.
  ///
  /// Checks for duplicates (same type + title) and tier limits.
  Future<bool> save(TrackerItem item) async {
    final items = getAll();

    // Check duplicate.
    if (isDuplicate(item.type, item.title, items)) {
      return false;
    }

    items.insert(0, item);
    return _persist(items);
  }

  /// Update the status of a tracker item by ID.
  Future<bool> updateStatus(String id, TrackerStatus status) async {
    final items = getAll();
    final index = items.indexWhere((e) => e.id == id);
    if (index == -1) return false;

    items[index] = items[index].copyWith(status: status);
    return _persist(items);
  }

  /// Delete a tracker item by ID.
  Future<bool> delete(String id) async {
    final items = getAll();
    items.removeWhere((e) => e.id == id);
    return _persist(items);
  }

  /// Check if an item with the same type and title already exists.
  bool isDuplicate(String type, String title, [List<TrackerItem>? existing]) {
    final items = existing ?? getAll();
    return items.any(
      (e) =>
          e.type.toLowerCase() == type.toLowerCase() &&
          e.title.toLowerCase() == title.toLowerCase(),
    );
  }

  /// Current saved count.
  int get count => getAll().length;

  /// Whether free tier limit is reached.
  bool isLimitReached(String tier) {
    if (tier == 'standard' || tier == 'premium') return false;
    return count >= freeTierLimit;
  }

  /// Persist items to SharedPreferences.
  Future<bool> _persist(List<TrackerItem> items) {
    return _prefs.setString(_storageKey, TrackerItem.encodeList(items));
  }
}
