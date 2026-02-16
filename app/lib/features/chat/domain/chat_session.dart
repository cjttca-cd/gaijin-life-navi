/// Represents a chat session with the AI.
class ChatSession {
  const ChatSession({
    required this.id,
    required this.userId,
    this.title,
    required this.category,
    required this.language,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String? title;
  final String category;
  final String language;
  final int messageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String?,
      category: (json['category'] as String?) ?? 'general',
      language: (json['language'] as String?) ?? 'en',
      messageCount: (json['message_count'] as int?) ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  ChatSession copyWith({
    String? id,
    String? userId,
    String? title,
    String? category,
    String? language,
    int? messageCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      language: language ?? this.language,
      messageCount: messageCount ?? this.messageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
