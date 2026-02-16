import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/chat/domain/chat_message.dart';
import 'package:gaijin_life_navi/features/chat/domain/chat_session.dart';

void main() {
  group('ChatSession', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'session-1',
        'user_id': 'user-1',
        'title': 'Banking question',
        'category': 'banking',
        'language': 'en',
        'message_count': 5,
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T01:00:00Z',
      };

      final session = ChatSession.fromJson(json);

      expect(session.id, 'session-1');
      expect(session.userId, 'user-1');
      expect(session.title, 'Banking question');
      expect(session.category, 'banking');
      expect(session.language, 'en');
      expect(session.messageCount, 5);
    });

    test('fromJson handles null title', () {
      final json = {
        'id': 'session-1',
        'user_id': 'user-1',
        'title': null,
        'category': 'general',
        'language': 'en',
        'message_count': 0,
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
      };

      final session = ChatSession.fromJson(json);
      expect(session.title, isNull);
    });

    test('fromJson uses defaults for missing fields', () {
      final json = {
        'id': 'session-1',
        'user_id': 'user-1',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
      };

      final session = ChatSession.fromJson(json);
      expect(session.category, 'general');
      expect(session.language, 'en');
      expect(session.messageCount, 0);
    });

    test('copyWith creates modified copy', () {
      final session = ChatSession(
        id: 's1',
        userId: 'u1',
        title: 'Old title',
        category: 'general',
        language: 'en',
        messageCount: 0,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      final updated = session.copyWith(title: 'New title', messageCount: 3);
      expect(updated.title, 'New title');
      expect(updated.messageCount, 3);
      expect(updated.id, 's1'); // unchanged
    });
  });

  group('ChatMessage', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'msg-1',
        'session_id': 'session-1',
        'role': 'user',
        'content': 'How do I open a bank account?',
        'created_at': '2026-01-01T00:00:00Z',
      };

      final message = ChatMessage.fromJson(json);

      expect(message.id, 'msg-1');
      expect(message.sessionId, 'session-1');
      expect(message.role, 'user');
      expect(message.content, 'How do I open a bank account?');
      expect(message.isUser, isTrue);
      expect(message.isAssistant, isFalse);
      expect(message.sources, isNull);
      expect(message.disclaimer, isNull);
    });

    test('fromJson with sources and disclaimer', () {
      final json = {
        'id': 'msg-2',
        'session_id': 'session-1',
        'role': 'assistant',
        'content': 'Here is how to open a bank account...',
        'sources': [
          {'title': 'Bank Guide', 'url': 'https://example.com/bank', 'snippet': 'Info...'},
        ],
        'disclaimer': 'This is general guidance only.',
        'tokens_used': 150,
        'created_at': '2026-01-01T00:01:00Z',
      };

      final message = ChatMessage.fromJson(json);

      expect(message.isAssistant, isTrue);
      expect(message.sources, isNotNull);
      expect(message.sources!.length, 1);
      expect(message.sources!.first.title, 'Bank Guide');
      expect(message.sources!.first.url, 'https://example.com/bank');
      expect(message.sources!.first.snippet, 'Info...');
      expect(message.disclaimer, 'This is general guidance only.');
      expect(message.tokensUsed, 150);
    });

    test('copyWith creates modified copy', () {
      final msg = ChatMessage(
        id: 'msg-1',
        sessionId: 's1',
        role: 'assistant',
        content: 'Hello',
        createdAt: DateTime(2026),
      );

      final updated = msg.copyWith(content: 'Hello world');
      expect(updated.content, 'Hello world');
      expect(updated.id, 'msg-1'); // unchanged
    });
  });

  group('SourceCitation', () {
    test('fromJson creates valid instance', () {
      final json = {
        'title': 'Immigration Guide',
        'url': 'https://example.com',
        'snippet': 'Relevant info...',
      };

      final source = SourceCitation.fromJson(json);
      expect(source.title, 'Immigration Guide');
      expect(source.url, 'https://example.com');
      expect(source.snippet, 'Relevant info...');
    });
  });

  group('ChatUsage', () {
    test('fromJson creates valid instance', () {
      final json = {
        'chat_count': 3,
        'chat_limit': 5,
        'chat_remaining': 2,
      };

      final usage = ChatUsage.fromJson(json);
      expect(usage.chatCount, 3);
      expect(usage.chatLimit, 5);
      expect(usage.chatRemaining, 2);
    });
  });
}
