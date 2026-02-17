import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../domain/chat_message.dart';
import '../domain/chat_session.dart';
import '../domain/sse_event.dart';

/// Repository for chat API operations against the AI Service.
class ChatRepository {
  ChatRepository({required Dio aiClient}) : _client = aiClient;

  final Dio _client;

  // ─── Sessions ──────────────────────────────────────────────

  /// Create a new chat session.
  Future<ChatSession> createSession() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/ai/chat/sessions',
    );
    return ChatSession.fromJson(response.data!);
  }

  /// List chat sessions with pagination.
  Future<List<ChatSession>> listSessions({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/ai/chat/sessions',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final items = response.data!['items'] as List;
    return items
        .map((e) => ChatSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get session detail.
  Future<ChatSession> getSession(String sessionId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/ai/chat/sessions/$sessionId',
    );
    return ChatSession.fromJson(response.data!);
  }

  /// Soft-delete a session.
  Future<void> deleteSession(String sessionId) async {
    await _client.delete<void>('/ai/chat/sessions/$sessionId');
  }

  // ─── Messages ──────────────────────────────────────────────

  /// Get message history for a session.
  Future<List<ChatMessage>> getMessages(
    String sessionId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/ai/chat/sessions/$sessionId/messages',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final items = response.data!['items'] as List;
    return items
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Send a message and receive SSE streaming response.
  ///
  /// Returns a [Stream] of [SseEvent]s parsed from the server response.
  Stream<SseEvent> sendMessage(String sessionId, String content) {
    final controller = StreamController<SseEvent>();

    _streamMessage(sessionId, content, controller)
        .then((_) {
          if (!controller.isClosed) {
            controller.close();
          }
        })
        .catchError((Object error) {
          if (!controller.isClosed) {
            controller.addError(error);
            controller.close();
          }
        });

    return controller.stream;
  }

  Future<void> _streamMessage(
    String sessionId,
    String content,
    StreamController<SseEvent> controller,
  ) async {
    final response = await _client.post<ResponseBody>(
      '/ai/chat/sessions/$sessionId/messages',
      data: {'content': content},
      options: Options(
        responseType: ResponseType.stream,
        headers: {'Accept': 'text/event-stream'},
      ),
    );

    String buffer = '';
    String currentEventType = '';

    await for (final chunk in response.data!.stream) {
      buffer += utf8.decode(chunk);

      // Process complete lines.
      while (buffer.contains('\n')) {
        final newlineIndex = buffer.indexOf('\n');
        final line = buffer.substring(0, newlineIndex).trim();
        buffer = buffer.substring(newlineIndex + 1);

        if (line.startsWith('event:')) {
          currentEventType = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          final dataStr = line.substring(5).trim();
          final event = SseParser.parse(currentEventType, dataStr);
          if (event != null && !controller.isClosed) {
            controller.add(event);
          }
          currentEventType = '';
        }
        // Empty lines are just event separators.
      }
    }

    // Process any remaining data in buffer.
    if (buffer.trim().isNotEmpty && currentEventType.isNotEmpty) {
      final dataLine = buffer.trim();
      if (dataLine.startsWith('data:')) {
        final dataStr = dataLine.substring(5).trim();
        final event = SseParser.parse(currentEventType, dataStr);
        if (event != null && !controller.isClosed) {
          controller.add(event);
        }
      }
    }
  }
}
