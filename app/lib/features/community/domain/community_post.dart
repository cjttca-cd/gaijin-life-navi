/// Moderation status of community content.
enum ModerationStatus {
  pending,
  approved,
  flagged,
  rejected;

  String get apiValue {
    switch (this) {
      case ModerationStatus.pending:
        return 'pending';
      case ModerationStatus.approved:
        return 'approved';
      case ModerationStatus.flagged:
        return 'flagged';
      case ModerationStatus.rejected:
        return 'rejected';
    }
  }

  static ModerationStatus fromString(String value) {
    switch (value) {
      case 'approved':
        return ModerationStatus.approved;
      case 'flagged':
        return ModerationStatus.flagged;
      case 'rejected':
        return ModerationStatus.rejected;
      default:
        return ModerationStatus.pending;
    }
  }
}

/// A community Q&A post.
class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.userId,
    required this.channel,
    required this.category,
    required this.title,
    required this.content,
    required this.isAnswered,
    required this.viewCount,
    required this.upvoteCount,
    required this.replyCount,
    required this.moderationStatus,
    required this.userVoted,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String channel;
  final String category;
  final String title;
  final String content;
  final bool isAnswered;
  final int viewCount;
  final int upvoteCount;
  final int replyCount;
  final ModerationStatus moderationStatus;
  final bool userVoted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      channel: json['channel'] as String? ?? '',
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isAnswered: json['is_answered'] as bool? ?? false,
      viewCount: json['view_count'] as int? ?? 0,
      upvoteCount: json['upvote_count'] as int? ?? 0,
      replyCount: json['reply_count'] as int? ?? 0,
      moderationStatus: ModerationStatus.fromString(
        json['ai_moderation_status'] as String? ?? 'pending',
      ),
      userVoted: json['user_voted'] as bool? ?? false,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'] as String)
              : null,
    );
  }

  CommunityPost copyWith({
    String? id,
    String? userId,
    String? channel,
    String? category,
    String? title,
    String? content,
    bool? isAnswered,
    int? viewCount,
    int? upvoteCount,
    int? replyCount,
    ModerationStatus? moderationStatus,
    bool? userVoted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      channel: channel ?? this.channel,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      isAnswered: isAnswered ?? this.isAnswered,
      viewCount: viewCount ?? this.viewCount,
      upvoteCount: upvoteCount ?? this.upvoteCount,
      replyCount: replyCount ?? this.replyCount,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      userVoted: userVoted ?? this.userVoted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
