import 'chat_response.dart';

/// A local chat message for UI display (user or assistant).
///
/// Phase 0: no server-side session management. Messages are kept in
/// local state only for the current conversation.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    this.sources,
    this.actions,
    this.trackerItems,
    this.disclaimer,
    this.domain,
    this.usage,
    required this.createdAt,
  });

  final String id;

  /// 'user' or 'assistant'
  final String role;
  final String content;
  final List<ChatSource>? sources;

  /// Suggested actions from AI response [{type, items/text}].
  final List<ChatAction>? actions;

  /// AI-suggested tracker items [{type, title, date}].
  final List<ChatTrackerItem>? trackerItems;

  final String? disclaimer;
  final String? domain;
  final ChatUsageInfo? usage;
  final DateTime createdAt;

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  ChatMessage copyWith({
    String? id,
    String? role,
    String? content,
    List<ChatSource>? sources,
    List<ChatAction>? actions,
    List<ChatTrackerItem>? trackerItems,
    String? disclaimer,
    String? domain,
    ChatUsageInfo? usage,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      sources: sources ?? this.sources,
      actions: actions ?? this.actions,
      trackerItems: trackerItems ?? this.trackerItems,
      disclaimer: disclaimer ?? this.disclaimer,
      domain: domain ?? this.domain,
      usage: usage ?? this.usage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
