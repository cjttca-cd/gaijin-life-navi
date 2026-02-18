import 'package:dio/dio.dart';

import '../domain/chat_response.dart';

/// Repository for AI Chat — Phase 0 synchronous endpoint.
///
/// POST /api/v1/chat → structured [ChatResponse].
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
}
