import 'chat_response.dart';

/// SSE stream events from POST /chat/stream.
///
/// Events arrive in order: routing → (searching) → token(s) → done | error.
sealed class ChatStreamEvent {
  const ChatStreamEvent();
}

/// The backend has classified the user's message into a domain.
class RoutingEvent extends ChatStreamEvent {
  const RoutingEvent({required this.domain, this.searchQuery});

  /// Domain short name (e.g. "finance", "life").
  final String domain;

  /// Search query if the router decided to search (null otherwise).
  final String? searchQuery;
}

/// The backend is executing a web search before calling the agent.
class SearchingEvent extends ChatStreamEvent {
  const SearchingEvent();
}

/// An incremental text token from the agent's response.
class TokenEvent extends ChatStreamEvent {
  const TokenEvent({required this.text});

  /// Incremental text chunk (may be a single character or a word).
  final String text;
}

/// Stream completed successfully. Contains the final parsed response.
class DoneEvent extends ChatStreamEvent {
  const DoneEvent({required this.response});

  /// The fully parsed response (same structure as synchronous /chat).
  final ChatResponse response;
}

/// An error occurred during streaming.
class ErrorEvent extends ChatStreamEvent {
  const ErrorEvent({required this.message});

  /// Human-readable error description.
  final String message;
}
