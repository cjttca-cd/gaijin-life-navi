import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_message.dart';
import '../../domain/chat_response.dart';

// ─── DI ──────────────────────────────────────────────────────

/// Dio instance for the API Gateway (port 8000).
final apiClientProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Chat repository provider.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(apiClient: ref.watch(apiClientProvider));
});

// ─── Messages (local state) ──────────────────────────────────

/// Provider for the conversation messages (local UI state).
final chatMessagesProvider =
    NotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(
      ChatMessagesNotifier.new,
    );

class ChatMessagesNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => [];

  /// Add a user message.
  void addUserMessage(ChatMessage message) {
    state = [...state, message];
  }

  /// Add an assistant message.
  void addAssistantMessage(ChatMessage message) {
    state = [...state, message];
  }

  /// Clear all messages (new conversation).
  void clear() {
    state = [];
  }
}

// ─── Chat usage (remaining count) ────────────────────────────

/// Holds the current chat usage info.
final chatUsageProvider = StateProvider<ChatUsageInfo?>((ref) => null);

/// Current user tier derived from chat usage (defaults to 'free').
final userTierProvider = Provider<String>((ref) {
  return ref.watch(chatUsageProvider)?.tier ?? 'free';
});

// ─── Loading state ───────────────────────────────────────────

/// Whether the chat is currently waiting for a response.
final isChatLoadingProvider = StateProvider<bool>((ref) => false);

// ─── Send message controller ─────────────────────────────────

/// Controller that handles sending a message and processing the response.
class ChatSendController {
  ChatSendController(this._ref);

  final Ref _ref;

  /// Send a message and process the synchronous response.
  Future<void> sendMessage(String content, {String? domain}) async {
    final repo = _ref.read(chatRepositoryProvider);
    final messagesNotifier = _ref.read(chatMessagesProvider.notifier);

    // Add user message optimistically.
    final userMessage = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      content: content,
      createdAt: DateTime.now(),
    );
    messagesNotifier.addUserMessage(userMessage);

    // Start loading.
    _ref.read(isChatLoadingProvider.notifier).state = true;

    try {
      final response = await repo.sendMessage(message: content, domain: domain);

      // Add assistant message.
      final assistantMessage = ChatMessage(
        id: 'assistant_${DateTime.now().millisecondsSinceEpoch}',
        role: 'assistant',
        content: response.reply,
        sources: response.sources,
        domain: response.domain,
        usage: response.usage,
        createdAt: DateTime.now(),
      );
      messagesNotifier.addAssistantMessage(assistantMessage);

      // Update usage.
      _ref.read(chatUsageProvider.notifier).state = response.usage;
    } catch (error) {
      // On error, add a failure message so user sees something.
      final errorMessage = ChatMessage(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        role: 'assistant',
        content: '', // Empty content signals error in UI.
        createdAt: DateTime.now(),
      );
      messagesNotifier.addAssistantMessage(errorMessage);
      rethrow;
    } finally {
      _ref.read(isChatLoadingProvider.notifier).state = false;
    }
  }
}

/// Provider for the send controller.
final chatSendControllerProvider = Provider<ChatSendController>((ref) {
  return ChatSendController(ref);
});
