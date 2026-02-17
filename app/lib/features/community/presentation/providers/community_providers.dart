import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/community_repository.dart';
import '../../domain/community_post.dart';
import '../../domain/community_reply.dart';

// ─── DI ──────────────────────────────────────────────────────

/// Dio client for App Service.
final _communityDioProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Community repository provider.
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(apiClient: ref.watch(_communityDioProvider));
});

// ─── Filter State ────────────────────────────────────────────

/// Currently selected channel (language code: en, zh, vi, ko, pt).
final communityChannelProvider = StateProvider<String>((ref) => 'en');

/// Currently selected category filter (null = all).
final communityCategoryProvider = StateProvider<String?>((ref) => null);

/// Currently selected sort (newest or popular).
final communitySortProvider = StateProvider<String>((ref) => 'newest');

// ─── Post List ───────────────────────────────────────────────

/// Provider for community post list with current filters.
final communityPostsProvider =
    AsyncNotifierProvider<CommunityPostsNotifier, List<CommunityPost>>(
      CommunityPostsNotifier.new,
    );

class CommunityPostsNotifier extends AsyncNotifier<List<CommunityPost>> {
  String? _nextCursor;
  bool _hasMore = true;

  @override
  Future<List<CommunityPost>> build() async {
    final channel = ref.watch(communityChannelProvider);
    final category = ref.watch(communityCategoryProvider);
    final sort = ref.watch(communitySortProvider);

    _nextCursor = null;
    _hasMore = true;

    final repo = ref.read(communityRepositoryProvider);
    final result = await repo.listPosts(
      channel: channel,
      category: category,
      sort: sort,
    );

    _nextCursor = result.nextCursor;
    _hasMore = result.hasMore;

    return result.items;
  }

  bool get hasMore => _hasMore;

  /// Load more posts (pagination).
  Future<void> loadMore() async {
    if (!_hasMore || _nextCursor == null) return;

    final channel = ref.read(communityChannelProvider);
    final category = ref.read(communityCategoryProvider);
    final sort = ref.read(communitySortProvider);
    final repo = ref.read(communityRepositoryProvider);

    final result = await repo.listPosts(
      channel: channel,
      category: category,
      sort: sort,
      cursor: _nextCursor,
    );

    _nextCursor = result.nextCursor;
    _hasMore = result.hasMore;

    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, ...result.items]);
  }

  /// Refresh the post list.
  Future<void> refresh() async {
    _nextCursor = null;
    _hasMore = true;
    ref.invalidateSelf();
  }
}

// ─── Post Detail ─────────────────────────────────────────────

/// Provider for a single post detail.
final communityPostDetailProvider =
    FutureProvider.family<CommunityPost, String>((ref, postId) async {
      final repo = ref.watch(communityRepositoryProvider);
      return repo.getPost(postId);
    });

// ─── Replies ─────────────────────────────────────────────────

/// Provider for replies of a specific post.
final communityRepliesProvider = AsyncNotifierProvider.family<
  CommunityRepliesNotifier,
  List<CommunityReply>,
  String
>(CommunityRepliesNotifier.new);

class CommunityRepliesNotifier
    extends FamilyAsyncNotifier<List<CommunityReply>, String> {
  String? _nextCursor;
  bool _hasMore = true;

  @override
  Future<List<CommunityReply>> build(String arg) async {
    _nextCursor = null;
    _hasMore = true;

    final repo = ref.read(communityRepositoryProvider);
    final result = await repo.listReplies(postId: arg);

    _nextCursor = result.nextCursor;
    _hasMore = result.hasMore;

    return result.items;
  }

  bool get hasMore => _hasMore;

  Future<void> loadMore() async {
    if (!_hasMore || _nextCursor == null) return;

    final repo = ref.read(communityRepositoryProvider);
    final result = await repo.listReplies(postId: arg, cursor: _nextCursor);

    _nextCursor = result.nextCursor;
    _hasMore = result.hasMore;

    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, ...result.items]);
  }

  /// Add a reply to the list (optimistic update after creation).
  void addReply(CommunityReply reply) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, reply]);
  }
}

// ─── Available categories ────────────────────────────────────

/// Community post categories.
const communityCategories = [
  'visa',
  'housing',
  'banking',
  'work',
  'daily_life',
  'medical',
  'education',
  'tax',
  'other',
];
