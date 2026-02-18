import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/chat/domain/chat_message.dart';
import 'package:gaijin_life_navi/features/chat/domain/chat_response.dart';

void main() {
  group('ChatResponse', () {
    test('fromJson creates valid instance with all fields', () {
      final json = {
        'reply': 'Here is how to open a bank account...',
        'domain': 'banking',
        'sources': [
          {'title': 'Bank Guide', 'url': 'https://example.com/bank'},
        ],
        'actions': [
          {'type': 'checklist', 'items': 'passport, residence card'},
        ],
        'tracker_items': [
          {
            'type': 'deadline',
            'title': 'Bank appointment',
            'date': '2026-03-01',
          },
        ],
        'usage': {'used': 3, 'limit': 5, 'tier': 'free'},
      };

      final response = ChatResponse.fromJson(json);

      expect(response.reply, contains('bank account'));
      expect(response.domain, 'banking');
      expect(response.sources.length, 1);
      expect(response.sources.first.title, 'Bank Guide');
      expect(response.actions.length, 1);
      expect(response.actions.first.type, 'checklist');
      expect(response.trackerItems.length, 1);
      expect(response.trackerItems.first.title, 'Bank appointment');
      expect(response.usage.used, 3);
      expect(response.usage.limit, 5);
      expect(response.usage.tier, 'free');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'reply': 'Hello',
        'domain': 'concierge',
        'usage': {'used': 1, 'limit': 5, 'tier': 'free'},
      };

      final response = ChatResponse.fromJson(json);

      expect(response.reply, 'Hello');
      expect(response.domain, 'concierge');
      expect(response.sources, isEmpty);
      expect(response.actions, isEmpty);
      expect(response.trackerItems, isEmpty);
    });

    test('fromJson handles completely empty json', () {
      final json = <String, dynamic>{};

      final response = ChatResponse.fromJson(json);

      expect(response.reply, '');
      expect(response.domain, 'concierge');
      expect(response.sources, isEmpty);
      expect(response.usage.used, 0);
    });
  });

  group('ChatSource', () {
    test('fromJson creates valid instance', () {
      final json = {'title': 'Immigration Guide', 'url': 'https://example.com'};

      final source = ChatSource.fromJson(json);
      expect(source.title, 'Immigration Guide');
      expect(source.url, 'https://example.com');
    });
  });

  group('ChatUsageInfo', () {
    test('fromJson creates valid instance', () {
      final json = {'used': 3, 'limit': 5, 'tier': 'free'};

      final usage = ChatUsageInfo.fromJson(json);
      expect(usage.used, 3);
      expect(usage.limit, 5);
      expect(usage.tier, 'free');
      expect(usage.remaining, 2);
      expect(usage.isUnlimited, isFalse);
    });

    test('isUnlimited when limit is 0', () {
      final json = {'used': 100, 'limit': 0, 'tier': 'premium'};

      final usage = ChatUsageInfo.fromJson(json);
      expect(usage.isUnlimited, isTrue);
      expect(usage.remaining, -1);
    });
  });

  group('ChatMessage', () {
    test('creates user message', () {
      final msg = ChatMessage(
        id: 'user_1',
        role: 'user',
        content: 'How do I open a bank account?',
        createdAt: DateTime(2026),
      );

      expect(msg.isUser, isTrue);
      expect(msg.isAssistant, isFalse);
      expect(msg.content, 'How do I open a bank account?');
    });

    test('creates assistant message with sources', () {
      final msg = ChatMessage(
        id: 'assistant_1',
        role: 'assistant',
        content: 'Here is how...',
        sources: [const ChatSource(title: 'Guide', url: 'https://example.com')],
        domain: 'banking',
        createdAt: DateTime(2026),
      );

      expect(msg.isAssistant, isTrue);
      expect(msg.sources, isNotNull);
      expect(msg.sources!.length, 1);
      expect(msg.domain, 'banking');
    });

    test('creates assistant message with trackerItems and actions', () {
      final msg = ChatMessage(
        id: 'assistant_2',
        role: 'assistant',
        content: 'Here is the info...',
        trackerItems: [
          const ChatTrackerItem(
            type: 'deadline',
            title: 'Bank appointment',
            date: '2026-03-01',
          ),
        ],
        actions: [
          const ChatAction(
            type: 'checklist',
            items: 'passport, residence card',
          ),
        ],
        domain: 'banking',
        createdAt: DateTime(2026),
      );

      expect(msg.trackerItems, isNotNull);
      expect(msg.trackerItems!.length, 1);
      expect(msg.trackerItems!.first.title, 'Bank appointment');
      expect(msg.actions, isNotNull);
      expect(msg.actions!.length, 1);
      expect(msg.actions!.first.type, 'checklist');
    });

    test('copyWith creates modified copy', () {
      final msg = ChatMessage(
        id: 'msg-1',
        role: 'assistant',
        content: 'Hello',
        createdAt: DateTime(2026),
      );

      final updated = msg.copyWith(content: 'Hello world');
      expect(updated.content, 'Hello world');
      expect(updated.id, 'msg-1'); // unchanged
    });

    test('copyWith preserves trackerItems and actions', () {
      final msg = ChatMessage(
        id: 'msg-2',
        role: 'assistant',
        content: 'Info',
        trackerItems: [const ChatTrackerItem(type: 'task', title: 'Test')],
        actions: [const ChatAction(type: 'next_step', text: 'Continue')],
        createdAt: DateTime(2026),
      );

      final updated = msg.copyWith(content: 'Updated');
      expect(updated.trackerItems!.length, 1);
      expect(updated.actions!.length, 1);
    });
  });
}
