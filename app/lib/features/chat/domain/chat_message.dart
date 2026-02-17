/// Represents a single chat message (user or assistant).
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    this.sources,
    this.disclaimer,
    this.tokensUsed,
    required this.createdAt,
  });

  final String id;
  final String sessionId;

  /// 'user' or 'assistant'
  final String role;
  final String content;
  final List<SourceCitation>? sources;
  final String? disclaimer;
  final int? tokensUsed;
  final DateTime createdAt;

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      sources:
          json['sources'] != null
              ? (json['sources'] as List)
                  .map(
                    (s) => SourceCitation.fromJson(s as Map<String, dynamic>),
                  )
                  .toList()
              : null,
      disclaimer: json['disclaimer'] as String?,
      tokensUsed: json['tokens_used'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  ChatMessage copyWith({
    String? id,
    String? sessionId,
    String? role,
    String? content,
    List<SourceCitation>? sources,
    String? disclaimer,
    int? tokensUsed,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      sources: sources ?? this.sources,
      disclaimer: disclaimer ?? this.disclaimer,
      tokensUsed: tokensUsed ?? this.tokensUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// A source citation from RAG results.
class SourceCitation {
  const SourceCitation({required this.title, required this.url, this.snippet});

  final String title;
  final String url;
  final String? snippet;

  factory SourceCitation.fromJson(Map<String, dynamic> json) {
    return SourceCitation(
      title: json['title'] as String,
      url: json['url'] as String,
      snippet: json['snippet'] as String?,
    );
  }
}

/// Usage info returned in message_end event.
class ChatUsage {
  const ChatUsage({
    required this.chatCount,
    required this.chatLimit,
    required this.chatRemaining,
  });

  final int chatCount;
  final int chatLimit;
  final int chatRemaining;

  factory ChatUsage.fromJson(Map<String, dynamic> json) {
    return ChatUsage(
      chatCount: json['chat_count'] as int,
      chatLimit: json['chat_limit'] as int,
      chatRemaining: json['chat_remaining'] as int,
    );
  }
}
