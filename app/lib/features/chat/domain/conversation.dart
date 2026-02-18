/// A chat conversation with metadata.
class Conversation {
  Conversation({
    required this.id,
    required this.createdAt,
    this.title,
    this.lastMessage,
    this.lastMessageAt,
    this.messageCount = 0,
  });

  final String id;
  final DateTime createdAt;

  /// Display title — derived from first user message or default.
  String? title;

  /// Preview of the last message.
  String? lastMessage;

  /// Timestamp of last message.
  DateTime? lastMessageAt;

  /// Total messages in this conversation.
  int messageCount;
}
