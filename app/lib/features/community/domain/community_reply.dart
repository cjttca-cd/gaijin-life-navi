import 'community_post.dart';

/// A reply to a community post.
class CommunityReply {
  const CommunityReply({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.isBestAnswer,
    required this.upvoteCount,
    required this.moderationStatus,
    required this.userVoted,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String postId;
  final String userId;
  final String content;
  final bool isBestAnswer;
  final int upvoteCount;
  final ModerationStatus moderationStatus;
  final bool userVoted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CommunityReply.fromJson(Map<String, dynamic> json) {
    return CommunityReply(
      id: json['id'] as String,
      postId: json['post_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isBestAnswer: json['is_best_answer'] as bool? ?? false,
      upvoteCount: json['upvote_count'] as int? ?? 0,
      moderationStatus: ModerationStatus.fromString(
          json['ai_moderation_status'] as String? ?? 'pending'),
      userVoted: json['user_voted'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  CommunityReply copyWith({
    String? id,
    String? postId,
    String? userId,
    String? content,
    bool? isBestAnswer,
    int? upvoteCount,
    ModerationStatus? moderationStatus,
    bool? userVoted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommunityReply(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      isBestAnswer: isBestAnswer ?? this.isBestAnswer,
      upvoteCount: upvoteCount ?? this.upvoteCount,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      userVoted: userVoted ?? this.userVoted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
