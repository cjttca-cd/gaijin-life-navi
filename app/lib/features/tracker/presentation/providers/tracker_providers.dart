import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/tracker_repository.dart';
import '../../domain/tracker_item.dart';

// ─── Repository ──────────────────────────────────────────────

/// Provides the TrackerRepository (async init of SharedPreferences).
final trackerRepositoryProvider = FutureProvider<TrackerRepository>((
  ref,
) async {
  final prefs = await SharedPreferences.getInstance();
  return TrackerRepository(prefs: prefs);
});

// ─── Items list ──────────────────────────────────────────────

/// All saved tracker (to-do) items.
final trackerItemsProvider =
    AsyncNotifierProvider<TrackerItemsNotifier, List<TrackerItem>>(
      TrackerItemsNotifier.new,
    );

class TrackerItemsNotifier extends AsyncNotifier<List<TrackerItem>> {
  TrackerRepository? _repo;

  Future<TrackerRepository> _getRepo() async {
    _repo ??= await ref.read(trackerRepositoryProvider.future);
    return _repo!;
  }

  @override
  Future<List<TrackerItem>> build() async {
    final repo = await _getRepo();
    return repo.getAll();
  }

  /// Add a new to-do item.
  Future<void> add(TrackerItem item) async {
    final repo = await _getRepo();
    await repo.add(item);
    state = AsyncData(repo.getAll());
  }

  /// Update an existing item.
  Future<void> updateItem(TrackerItem item) async {
    final repo = await _getRepo();
    await repo.update(item);
    state = AsyncData(repo.getAll());
  }

  /// Toggle complete state.
  Future<void> toggleComplete(String id) async {
    final repo = await _getRepo();
    await repo.toggleComplete(id);
    state = AsyncData(repo.getAll());
  }

  /// Delete an item.
  Future<void> delete(String id) async {
    final repo = await _getRepo();
    await repo.delete(id);
    state = AsyncData(repo.getAll());
  }

  /// Save a to-do from chat AI suggestion.
  ///
  /// Converts a chat-suggested item (title + optional date string) into a
  /// TrackerItem.
  Future<bool> saveFromChat({
    required String title,
    String? dateString,
  }) async {
    final repo = await _getRepo();

    // Check duplicate by title.
    final existing = repo.getAll();
    if (existing.any(
      (e) => e.title.toLowerCase() == title.toLowerCase(),
    )) {
      return false;
    }

    DateTime? dueDate;
    if (dateString != null && dateString.isNotEmpty) {
      dueDate = DateTime.tryParse(dateString);
    }

    final item = TrackerItem(
      id: TrackerItem.generateId(),
      title: title,
      dueDate: dueDate,
      completed: false,
      createdAt: DateTime.now(),
    );

    await repo.add(item);
    state = AsyncData(repo.getAll());
    return true;
  }
}

// ─── Derived providers ───────────────────────────────────────

/// Number of saved tracker items.
final trackerCountProvider = Provider<int>((ref) {
  return ref.watch(trackerItemsProvider).valueOrNull?.length ?? 0;
});

/// Incomplete items only.
final trackerIncompleteProvider = Provider<List<TrackerItem>>((ref) {
  final items = ref.watch(trackerItemsProvider).valueOrNull ?? [];
  return items.where((e) => !e.completed).toList();
});

/// Whether the free tier limit is reached.
///
/// In the new to-do design there is no tier limit — always returns false.
/// Kept for backward compatibility with chat tracker_item_card.
final trackerLimitReachedProvider = Provider<bool>((ref) {
  return false;
});

/// Check if a specific item title is already saved.
final isTrackerItemSavedProvider = Provider.family<bool, String>((
  ref,
  titleKey,
) {
  final items = ref.watch(trackerItemsProvider).valueOrNull ?? [];
  return items.any((e) => e.title.toLowerCase() == titleKey.toLowerCase());
});
