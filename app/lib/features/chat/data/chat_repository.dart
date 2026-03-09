import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../domain/chat_response.dart';
import '../domain/chat_stream_event.dart';

/// Repository for AI Chat — synchronous + SSE streaming endpoints.
///
/// POST /api/v1/chat → structured [ChatResponse].
/// POST /api/v1/chat/stream → SSE events via [ChatStreamEvent] stream.
class ChatRepository {
  ChatRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// Send a chat message and get AI response (synchronous).
  ///
  /// [context] is a list of prior conversation turns (user/assistant)
  /// that the backend injects into the agent prompt for continuity.
  /// Each entry must have `role` ("user"|"assistant") and `text`.
  ///
  /// When [imageBase64] is provided, it is included in the request body
  /// as a raw base64 string for server-side image analysis.
  Future<ChatResponse> sendMessage({
    required String message,
    String? domain,
    String? locale,
    String? imageBase64,
    List<Map<String, String>>? context,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/chat',
      data: {
        'message': message,
        if (domain != null) 'domain': domain,
        'locale': locale ?? 'en',
        if (imageBase64 != null) 'image': imageBase64,
        if (context != null && context.isNotEmpty) 'context': context,
      },
    );
    return ChatResponse.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }

  /// Send a chat message and receive SSE streaming response.
  ///
  /// Returns a [Stream] of [ChatStreamEvent] that emits events as they
  /// arrive from the server. The stream ends with either [DoneEvent]
  /// or [ErrorEvent].
  Stream<ChatStreamEvent> sendMessageStream({
    required String message,
    String? domain,
    String? locale,
    String? imageBase64,
    List<Map<String, String>>? context,
  }) async* {
    final response = await _client.post<ResponseBody>(
      '/chat/stream',
      data: {
        'message': message,
        if (domain != null) 'domain': domain,
        'locale': locale ?? 'en',
        if (imageBase64 != null) 'image': imageBase64,
        if (context != null && context.isNotEmpty) 'context': context,
      },
      options: Options(responseType: ResponseType.stream),
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();

    await for (final chunk in stream) {
      final text = utf8.decode(chunk, allowMalformed: true);
      buffer.write(text);

      // Process complete SSE events from buffer.
      var content = buffer.toString();
      while (content.contains('\n\n')) {
        final eventEnd = content.indexOf('\n\n');
        final eventBlock = content.substring(0, eventEnd);
        content = content.substring(eventEnd + 2);

        final event = _parseSSEBlock(eventBlock);
        if (event != null) {
          yield event;
        }
      }
      buffer
        ..clear()
        ..write(content);
    }

    // Process any remaining content in buffer.
    final remaining = buffer.toString().trim();
    if (remaining.isNotEmpty) {
      final event = _parseSSEBlock(remaining);
      if (event != null) {
        yield event;
      }
    }
  }

  /// Parse a single SSE event block into a [ChatStreamEvent].
  ///
  /// An SSE block looks like:
  /// ```
  /// event: token
  /// data: {"text": "hello"}
  /// ```
  ChatStreamEvent? _parseSSEBlock(String block) {
    String? eventType;
    String? dataStr;

    for (final line in block.split('\n')) {
      if (line.startsWith('event: ')) {
        eventType = line.substring(7).trim();
      } else if (line.startsWith('data: ')) {
        dataStr = line.substring(6);
      }
    }

    if (eventType == null) return null;

    Map<String, dynamic> data = {};
    if (dataStr != null && dataStr.isNotEmpty) {
      try {
        data = jsonDecode(dataStr) as Map<String, dynamic>;
      } catch (_) {
        // Malformed JSON — skip or treat as error.
        return null;
      }
    }

    switch (eventType) {
      case 'routing':
        return RoutingEvent(
          domain: data['domain'] as String? ?? '',
          searchQuery: data['search_query'] as String?,
        );
      case 'searching':
        return const SearchingEvent();
      case 'token':
        return TokenEvent(text: data['text'] as String? ?? '');
      case 'done':
        return DoneEvent(
          response: ChatResponse(
            reply: data['text'] as String? ?? '',
            domain: data['domain'] as String? ?? 'life',
            sources: (data['sources'] as List<dynamic>?)
                    ?.map(
                      (e) =>
                          ChatSource.fromJson(e as Map<String, dynamic>),
                    )
                    .toList() ??
                const [],
            trackerItems: (data['tracker_items'] as List<dynamic>?)
                    ?.map(
                      (e) => ChatTrackerItem.fromJson(
                        e as Map<String, dynamic>,
                      ),
                    )
                    .toList() ??
                const [],
            usage: data['usage'] != null
                ? ChatUsageInfo.fromJson(
                    data['usage'] as Map<String, dynamic>,
                  )
                : const ChatUsageInfo(used: 0, limit: 0, tier: 'free'),
          ),
        );
      case 'error':
        return ErrorEvent(message: data['message'] as String? ?? 'Unknown error');
      default:
        return null; // Unknown event type — skip.
    }
  }
}
