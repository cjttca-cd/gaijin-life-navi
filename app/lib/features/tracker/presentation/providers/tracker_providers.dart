import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../chat/presentation/providers/chat_providers.dart';
import '../../data/tracker_repository.dart';
import '../../domain/tracker_item.dart';

/// Free tier limit for tracker items.
const kFreeTrackerLimit = 3;

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

  /// Remove all items with a given tag (e.g. 'visa_renewal').
  Future<void> removeByTag(String tag) async {
    final repo = await _getRepo();
    await repo.removeByTag(tag);
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

/// Whether the free tier limit (3 items) is reached.
///
/// Returns true if user is on free tier AND has >= 3 items.
/// Standard/Premium users have no limit.
final trackerLimitReachedProvider = Provider<bool>((ref) {
  final tier = ref.watch(userTierProvider);
  if (tier != 'free') return false;
  final count = ref.watch(trackerCountProvider);
  return count >= kFreeTrackerLimit;
});

/// Check if a specific item title is already saved.
final isTrackerItemSavedProvider = Provider.family<bool, String>((
  ref,
  titleKey,
) {
  final items = ref.watch(trackerItemsProvider).valueOrNull ?? [];
  return items.any((e) => e.title.toLowerCase() == titleKey.toLowerCase());
});
