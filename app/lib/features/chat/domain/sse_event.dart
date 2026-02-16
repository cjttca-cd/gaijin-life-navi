import 'dart:convert';

/// Parsed SSE event from AI Service streaming response.
sealed class SseEvent {
  const SseEvent();
}

/// message_start event: indicates a new assistant message.
class MessageStartEvent extends SseEvent {
  const MessageStartEvent({required this.messageId, required this.role});

  final String messageId;
  final String role;
}

/// content_delta event: a chunk of text to append.
class ContentDeltaEvent extends SseEvent {
  const ContentDeltaEvent({required this.delta});

  final String delta;
}

/// message_end event: final event with sources, disclaimer, usage.
class MessageEndEvent extends SseEvent {
  const MessageEndEvent({
    this.sources,
    this.tokensUsed,
    this.disclaimer,
    this.usage,
  });

  final List<Map<String, dynamic>>? sources;
  final int? tokensUsed;
  final String? disclaimer;
  final Map<String, dynamic>? usage;
}

/// Error event from the SSE stream.
class SseErrorEvent extends SseEvent {
  const SseErrorEvent({required this.message});

  final String message;
}

/// Parses raw SSE text lines into structured [SseEvent]s.
///
/// SSE format:
///   event: {type}
///   data: {json}
class SseParser {
  /// Parses a single SSE event block (event + data lines).
  static SseEvent? parse(String eventType, String dataLine) {
    if (eventType.isEmpty || dataLine.isEmpty) return null;

    try {
      final data = json.decode(dataLine) as Map<String, dynamic>;

      switch (eventType) {
        case 'message_start':
          return MessageStartEvent(
            messageId: data['message_id'] as String,
            role: (data['role'] as String?) ?? 'assistant',
          );
        case 'content_delta':
          return ContentDeltaEvent(
            delta: data['delta'] as String,
          );
        case 'message_end':
          return MessageEndEvent(
            sources: data['sources'] != null
                ? (data['sources'] as List)
                    .cast<Map<String, dynamic>>()
                : null,
            tokensUsed: data['tokens_used'] as int?,
            disclaimer: data['disclaimer'] as String?,
            usage: data['usage'] as Map<String, dynamic>?,
          );
        default:
          return null;
      }
    } catch (_) {
      return SseErrorEvent(message: 'Failed to parse SSE event: $eventType');
    }
  }

  /// Splits raw SSE response text into event blocks and parses them.
  static List<SseEvent> parseStream(String rawText) {
    final events = <SseEvent>[];
    String currentEventType = '';
    String currentData = '';

    for (final line in rawText.split('\n')) {
      if (line.startsWith('event:')) {
        currentEventType = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        currentData = line.substring(5).trim();
      } else if (line.trim().isEmpty && currentEventType.isNotEmpty) {
        final event = parse(currentEventType, currentData);
        if (event != null) {
          events.add(event);
        }
        currentEventType = '';
        currentData = '';
      }
    }

    // Handle trailing event without final newline.
    if (currentEventType.isNotEmpty && currentData.isNotEmpty) {
      final event = parse(currentEventType, currentData);
      if (event != null) {
        events.add(event);
      }
    }

    return events;
  }
}
