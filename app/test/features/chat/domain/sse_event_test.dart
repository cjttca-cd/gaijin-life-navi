import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/chat/domain/sse_event.dart';

void main() {
  group('SseParser', () {
    group('parse', () {
      test('parses message_start event', () {
        const eventType = 'message_start';
        const data = '{"message_id": "abc-123", "role": "assistant"}';

        final event = SseParser.parse(eventType, data);

        expect(event, isA<MessageStartEvent>());
        final start = event as MessageStartEvent;
        expect(start.messageId, 'abc-123');
        expect(start.role, 'assistant');
      });

      test('parses content_delta event', () {
        const eventType = 'content_delta';
        const data = '{"delta": "Hello, how "}';

        final event = SseParser.parse(eventType, data);

        expect(event, isA<ContentDeltaEvent>());
        final delta = event as ContentDeltaEvent;
        expect(delta.delta, 'Hello, how ');
      });

      test('parses message_end event with full data', () {
        const eventType = 'message_end';
        const data =
            '{"sources": [{"title": "Test", "url": "http://example.com"}], '
            '"tokens_used": 42, '
            '"disclaimer": "For general guidance only.", '
            '"usage": {"chat_count": 3, "chat_limit": 5, "chat_remaining": 2}}';

        final event = SseParser.parse(eventType, data);

        expect(event, isA<MessageEndEvent>());
        final end = event as MessageEndEvent;
        expect(end.sources, isNotNull);
        expect(end.sources!.length, 1);
        expect(end.sources!.first['title'], 'Test');
        expect(end.tokensUsed, 42);
        expect(end.disclaimer, 'For general guidance only.');
        expect(end.usage, isNotNull);
        expect(end.usage!['chat_remaining'], 2);
      });

      test('parses message_end event with null fields', () {
        const eventType = 'message_end';
        const data = '{}';

        final event = SseParser.parse(eventType, data);

        expect(event, isA<MessageEndEvent>());
        final end = event as MessageEndEvent;
        expect(end.sources, isNull);
        expect(end.tokensUsed, isNull);
        expect(end.disclaimer, isNull);
        expect(end.usage, isNull);
      });

      test('returns null for unknown event type', () {
        final event = SseParser.parse('unknown', '{"data": "test"}');
        expect(event, isNull);
      });

      test('returns null for empty event type', () {
        final event = SseParser.parse('', '{"data": "test"}');
        expect(event, isNull);
      });

      test('returns null for empty data', () {
        final event = SseParser.parse('message_start', '');
        expect(event, isNull);
      });

      test('returns SseErrorEvent for invalid JSON', () {
        final event = SseParser.parse('message_start', 'not json');
        expect(event, isA<SseErrorEvent>());
      });
    });

    group('parseStream', () {
      test('parses a full SSE stream', () {
        const rawText = '''event: message_start
data: {"message_id": "msg-1", "role": "assistant"}

event: content_delta
data: {"delta": "Hello"}

event: content_delta
data: {"delta": " world"}

event: message_end
data: {"sources": [], "tokens_used": 10, "disclaimer": "Disclaimer text.", "usage": {"chat_count": 1, "chat_limit": 5, "chat_remaining": 4}}

''';

        final events = SseParser.parseStream(rawText);

        expect(events.length, 4);
        expect(events[0], isA<MessageStartEvent>());
        expect(events[1], isA<ContentDeltaEvent>());
        expect(events[2], isA<ContentDeltaEvent>());
        expect(events[3], isA<MessageEndEvent>());

        final start = events[0] as MessageStartEvent;
        expect(start.messageId, 'msg-1');

        final delta1 = events[1] as ContentDeltaEvent;
        expect(delta1.delta, 'Hello');

        final delta2 = events[2] as ContentDeltaEvent;
        expect(delta2.delta, ' world');

        final end = events[3] as MessageEndEvent;
        expect(end.disclaimer, 'Disclaimer text.');
        expect(end.usage!['chat_remaining'], 4);
      });

      test('handles stream without trailing newline', () {
        const rawText = '''event: message_start
data: {"message_id": "msg-2", "role": "assistant"}''';

        final events = SseParser.parseStream(rawText);
        expect(events.length, 1);
        expect(events[0], isA<MessageStartEvent>());
      });

      test('returns empty list for empty input', () {
        final events = SseParser.parseStream('');
        expect(events, isEmpty);
      });
    });
  });
}
