import 'package:dio/dio.dart';

import '../domain/chat_response.dart';

/// Repository for AI Chat — Phase 0 synchronous endpoint.
///
/// POST /api/v1/chat → structured [ChatResponse].
class ChatRepository {
  ChatRepository({required Dio apiClient}) : _client = apiClient;

  final Dio _client;

  /// Send a chat message and get AI response (synchronous).
  Future<ChatResponse> sendMessage({
    required String message,
    String? domain,
    String? locale,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/chat',
      data: {
        'message': message,
        if (domain != null) 'domain': domain,
        'locale': locale ?? 'en',
      },
    );
    return ChatResponse.fromJson(
      response.data!['data'] as Map<String, dynamic>,
    );
  }
}
