import 'package:dio/dio.dart';

import '../domain/community_post.dart';
import '../domain/community_reply.dart';

/// Paginated response wrapper.
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    this.nextCursor,
    required this.hasMore,
  });

  final List<T> items;
  final String? nextCursor;
  final bool hasMore;
}

/// Repository for Community Q&A API operations.
class CommunityRepository {
  CommunityRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  // ─── Posts ──────────────────────────────────────────────────

  /// List community posts with filters.
  Future<PaginatedResponse<CommunityPost>> listPosts({
    required String channel,
    String? category,
    String sort = 'newest',
    int limit = 20,
    String? cursor,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/community/posts',
      queryParameters: {
        'channel': channel,
        if (category != null) 'category': category,
        'sort': sort,
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );

    final data = response.data!['data'] as List;
    final pagination = response.data!['pagination'] as Map<String, dynamic>;

    return PaginatedResponse(
      items:
          data
              .map((e) => CommunityPost.fromJson(e as Map<String, dynamic>))
              .toList(),
      nextCursor: pagination['next_cursor'] as String?,
      hasMore: pagination['has_more'] as bool? ?? false,
    );
  }

  /// Get a single post detail.
  Future<CommunityPost> getPost(String postId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/community/posts/$postId',
    );
    return CommunityPost.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  /// Create a new post. Requires Premium.
  Future<CommunityPost> createPost({
    required String channel,
    required String category,
    required String title,
    required String content,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/community/posts',
      data: {
        'channel': channel,
        'category': category,
        'title': title,
        'content': content,
      },
    );
    return CommunityPost.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  // ─── Replies ───────────────────────────────────────────────

  /// List replies for a post.
  Future<PaginatedResponse<CommunityReply>> listReplies({
    required String postId,
    int limit = 20,
    String? cursor,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/community/posts/$postId/replies',
      queryParameters: {'limit': limit, if (cursor != null) 'cursor': cursor},
    );

    final data = response.data!['data'] as List;
    final pagination = response.data!['pagination'] as Map<String, dynamic>;

    return PaginatedResponse(
      items:
          data
              .map((e) => CommunityReply.fromJson(e as Map<String, dynamic>))
              .toList(),
      nextCursor: pagination['next_cursor'] as String?,
      hasMore: pagination['has_more'] as bool? ?? false,
    );
  }

  /// Create a reply on a post. Requires Premium.
  Future<CommunityReply> createReply({
    required String postId,
    required String content,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/community/posts/$postId/replies',
      data: {'content': content},
    );
    return CommunityReply.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  // ─── Votes ─────────────────────────────────────────────────

  /// Toggle vote on a post. Returns (voted, upvoteCount).
  Future<({bool voted, int upvoteCount})> votePost(String postId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/community/posts/$postId/vote',
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return (
      voted: data['voted'] as bool,
      upvoteCount: data['upvote_count'] as int,
    );
  }

  /// Toggle vote on a reply. Returns (voted, upvoteCount).
  Future<({bool voted, int upvoteCount})> voteReply(String replyId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/community/replies/$replyId/vote',
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return (
      voted: data['voted'] as bool,
      upvoteCount: data['upvote_count'] as int,
    );
  }

  // ─── Best Answer ───────────────────────────────────────────

  /// Set/toggle best answer on a reply (post author only).
  Future<({bool isBestAnswer, bool postIsAnswered})> setBestAnswer(
    String replyId,
  ) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/community/replies/$replyId/best-answer',
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return (
      isBestAnswer: data['is_best_answer'] as bool,
      postIsAnswered: data['post_is_answered'] as bool,
    );
  }
}
