import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/community/domain/community_post.dart';
import 'package:gaijin_life_navi/features/community/domain/community_reply.dart';

void main() {
  group('ModerationStatus', () {
    test('fromString parses all statuses', () {
      expect(
          ModerationStatus.fromString('pending'), ModerationStatus.pending);
      expect(ModerationStatus.fromString('approved'),
          ModerationStatus.approved);
      expect(
          ModerationStatus.fromString('flagged'), ModerationStatus.flagged);
      expect(ModerationStatus.fromString('rejected'),
          ModerationStatus.rejected);
    });

    test('fromString defaults to pending for unknown', () {
      expect(
          ModerationStatus.fromString('unknown'), ModerationStatus.pending);
    });

    test('apiValue returns correct strings', () {
      expect(ModerationStatus.pending.apiValue, 'pending');
      expect(ModerationStatus.approved.apiValue, 'approved');
      expect(ModerationStatus.flagged.apiValue, 'flagged');
      expect(ModerationStatus.rejected.apiValue, 'rejected');
    });
  });

  group('CommunityPost', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'post-1',
        'user_id': 'user-1',
        'channel': 'en',
        'category': 'visa',
        'title': 'How to renew work visa?',
        'content': 'I need to renew my engineer visa...',
        'is_answered': true,
        'view_count': 42,
        'upvote_count': 5,
        'reply_count': 3,
        'ai_moderation_status': 'approved',
        'user_voted': false,
        'created_at': '2026-02-16T10:00:00Z',
        'updated_at': '2026-02-16T12:00:00Z',
      };

      final post = CommunityPost.fromJson(json);

      expect(post.id, 'post-1');
      expect(post.userId, 'user-1');
      expect(post.channel, 'en');
      expect(post.category, 'visa');
      expect(post.title, 'How to renew work visa?');
      expect(post.isAnswered, isTrue);
      expect(post.viewCount, 42);
      expect(post.upvoteCount, 5);
      expect(post.replyCount, 3);
      expect(post.moderationStatus, ModerationStatus.approved);
      expect(post.userVoted, isFalse);
      expect(post.createdAt, isNotNull);
      expect(post.createdAt!.year, 2026);
    });

    test('fromJson handles pending moderation', () {
      final json = {
        'id': 'post-2',
        'user_id': 'user-1',
        'channel': 'zh',
        'category': 'housing',
        'title': '如何找公寓？',
        'content': '我想找一个便宜的公寓...',
        'is_answered': false,
        'view_count': 0,
        'upvote_count': 0,
        'reply_count': 0,
        'ai_moderation_status': 'pending',
        'user_voted': false,
        'created_at': '2026-02-16T10:00:00Z',
      };

      final post = CommunityPost.fromJson(json);

      expect(post.moderationStatus, ModerationStatus.pending);
      expect(post.isAnswered, isFalse);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'post-3',
      };

      final post = CommunityPost.fromJson(json);

      expect(post.id, 'post-3');
      expect(post.userId, '');
      expect(post.channel, '');
      expect(post.isAnswered, isFalse);
      expect(post.viewCount, 0);
      expect(post.moderationStatus, ModerationStatus.pending);
      expect(post.userVoted, isFalse);
      expect(post.createdAt, isNull);
    });

    test('copyWith creates modified copy', () {
      final post = CommunityPost.fromJson({
        'id': 'post-1',
        'user_id': 'user-1',
        'channel': 'en',
        'category': 'visa',
        'title': 'Original',
        'content': 'Content',
        'is_answered': false,
        'view_count': 0,
        'upvote_count': 0,
        'reply_count': 0,
        'ai_moderation_status': 'pending',
        'user_voted': false,
      });

      final modified = post.copyWith(
        title: 'Modified',
        upvoteCount: 10,
        userVoted: true,
      );

      expect(modified.id, 'post-1'); // unchanged
      expect(modified.title, 'Modified');
      expect(modified.upvoteCount, 10);
      expect(modified.userVoted, isTrue);
    });
  });

  group('CommunityReply', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'reply-1',
        'post_id': 'post-1',
        'user_id': 'user-2',
        'content': 'You need to go to the immigration office.',
        'is_best_answer': true,
        'upvote_count': 3,
        'ai_moderation_status': 'approved',
        'user_voted': true,
        'created_at': '2026-02-16T11:00:00Z',
      };

      final reply = CommunityReply.fromJson(json);

      expect(reply.id, 'reply-1');
      expect(reply.postId, 'post-1');
      expect(reply.userId, 'user-2');
      expect(reply.content, 'You need to go to the immigration office.');
      expect(reply.isBestAnswer, isTrue);
      expect(reply.upvoteCount, 3);
      expect(reply.moderationStatus, ModerationStatus.approved);
      expect(reply.userVoted, isTrue);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'reply-2',
      };

      final reply = CommunityReply.fromJson(json);

      expect(reply.id, 'reply-2');
      expect(reply.postId, '');
      expect(reply.isBestAnswer, isFalse);
      expect(reply.upvoteCount, 0);
      expect(reply.createdAt, isNull);
    });

    test('copyWith creates modified copy', () {
      final reply = CommunityReply.fromJson({
        'id': 'reply-1',
        'post_id': 'post-1',
        'user_id': 'user-2',
        'content': 'Original reply',
        'is_best_answer': false,
        'upvote_count': 0,
        'ai_moderation_status': 'pending',
        'user_voted': false,
      });

      final modified = reply.copyWith(
        isBestAnswer: true,
        upvoteCount: 5,
      );

      expect(modified.id, 'reply-1');
      expect(modified.isBestAnswer, isTrue);
      expect(modified.upvoteCount, 5);
      expect(modified.content, 'Original reply');
    });
  });
}
