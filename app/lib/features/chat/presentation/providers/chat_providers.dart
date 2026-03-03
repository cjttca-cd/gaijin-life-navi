import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_message.dart';
import '../../domain/chat_response.dart';
import '../../domain/conversation.dart';

// ─── DI ──────────────────────────────────────────────────────

/// Dio instance for the API Gateway (port 8000).
final apiClientProvider = Provider<Dio>((ref) {
  return createApiClient();
});

/// Chat repository provider.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(apiClient: ref.watch(apiClientProvider));
});

// ─── Active conversation ID ──────────────────────────────────

/// The currently selected conversation ID.
final activeConversationIdProvider = StateProvider<String?>((ref) => null);

// ─── Multi-conversation state ────────────────────────────────

/// Manages all conversations and their messages.
final conversationsProvider =
    NotifierProvider<ConversationsNotifier, Map<String, Conversation>>(
      ConversationsNotifier.new,
    );

class ConversationsNotifier extends Notifier<Map<String, Conversation>> {
  @override
  Map<String, Conversation> build() => {};

  /// Create a new conversation and return its ID.
  String createConversation() {
    final id = 'conv_${DateTime.now().millisecondsSinceEpoch}';
    final conv = Conversation(id: id, createdAt: DateTime.now());
    state = {...state, id: conv};
    return id;
  }

  /// Update conversation metadata after a message is sent/received.
  void updateConversation(
    String id, {
    String? title,
    String? lastMessage,
    int? messageCount,
  }) {
    final conv = state[id];
    if (conv == null) return;
    conv.title = title ?? conv.title;
    conv.lastMessage = lastMessage ?? conv.lastMessage;
    conv.lastMessageAt = DateTime.now();
    conv.messageCount = messageCount ?? conv.messageCount;
    state = {...state, id: conv};
  }

  /// Delete a conversation.
  void deleteConversation(String id) {
    final newState = Map<String, Conversation>.from(state);
    newState.remove(id);
    state = newState;
  }
}

/// Conversations sorted by last activity (newest first).
final sortedConversationsProvider = Provider<List<Conversation>>((ref) {
  final convs = ref.watch(conversationsProvider);
  final sorted =
      convs.values.toList()..sort(
        (a, b) => (b.lastMessageAt ?? b.createdAt).compareTo(
          a.lastMessageAt ?? a.createdAt,
        ),
      );
  return sorted;
});

// ─── Per-conversation messages ───────────────────────────────

/// All messages keyed by conversation ID.
final allMessagesProvider =
    NotifierProvider<AllMessagesNotifier, Map<String, List<ChatMessage>>>(
      AllMessagesNotifier.new,
    );

class AllMessagesNotifier extends Notifier<Map<String, List<ChatMessage>>> {
  @override
  Map<String, List<ChatMessage>> build() => {};

  /// Add a message to a conversation.
  void addMessage(String conversationId, ChatMessage message) {
    final current = state[conversationId] ?? [];
    state = {
      ...state,
      conversationId: [...current, message],
    };
  }

  /// Get messages for a conversation.
  List<ChatMessage> getMessages(String conversationId) {
    return state[conversationId] ?? [];
  }

  /// Clear messages for a conversation.
  void clearConversation(String conversationId) {
    final newState = Map<String, List<ChatMessage>>.from(state);
    newState.remove(conversationId);
    state = newState;
  }
}

/// Messages for the active conversation.
final chatMessagesProvider = Provider<List<ChatMessage>>((ref) {
  final activeId = ref.watch(activeConversationIdProvider);
  if (activeId == null) return [];
  final allMessages = ref.watch(allMessagesProvider);
  return allMessages[activeId] ?? [];
});

// ─── Chat usage (remaining count) ────────────────────────────

/// Holds the current chat usage info.
final chatUsageProvider = StateProvider<ChatUsageInfo?>((ref) => null);

/// Fetch usage from backend and update chatUsageProvider.
final fetchUsageProvider = FutureProvider<void>((ref) async {
  try {
    final client = ref.read(apiClientProvider);
    final response = await client.get<Map<String, dynamic>>('/usage');
    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data != null) {
      final used = data['used'] as int? ?? 0;
      final limit = data['limit'] as int? ?? 0;
      final tier = data['tier'] as String? ?? 'free';
      final period = data['period'] as String?;
      ref.read(chatUsageProvider.notifier).state = ChatUsageInfo(
        used: used,
        limit: limit,
        tier: tier,
        period: period,
      );
    }
  } catch (_) {
    // Silently fail — usage display will just be hidden
  }
});

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

  /// Estimate token count for a text string.
  static int _estimateTokens(String text) {
    final cjkPattern = RegExp(
      r'[\u4e00-\u9fff\u3040-\u309f\u30a0-\u30ff\uac00-\ud7af]',
    );
    int cjk = cjkPattern.allMatches(text).length;
    int nonCjk = text.length - cjk;
    return (cjk * 2 + nonCjk * 0.75).ceil();
  }

  /// Maximum tokens for conversation context sent to backend.
  static const int _maxContextTokens = 90000;

  /// Build context list from existing messages, respecting token budget.
  List<Map<String, String>> _buildContext(List<ChatMessage> messages) {
    if (messages.isEmpty) return [];

    final result = <Map<String, String>>[];
    int tokenBudget = _maxContextTokens;

    for (int i = messages.length - 1; i >= 0; i--) {
      final msg = messages[i];
      if (msg.content.isEmpty) continue;
      final tokens = _estimateTokens(msg.content);
      if (tokenBudget - tokens < 0) break;
      tokenBudget -= tokens;
      result.add({'role': msg.role, 'text': msg.content});
    }

    return result.reversed.toList();
  }

  /// Send a message in the active conversation.
  Future<void> sendMessage(
    String content, {
    String? domain,
    String? imageBase64,
  }) async {
    final activeId = _ref.read(activeConversationIdProvider);
    if (activeId == null) return;

    final repo = _ref.read(chatRepositoryProvider);
    final allMsgs = _ref.read(allMessagesProvider.notifier);
    final convs = _ref.read(conversationsProvider.notifier);

    // Collect context from existing messages BEFORE adding the new one.
    final currentMessages = _ref.read(allMessagesProvider)[activeId] ?? [];
    final context = _buildContext(currentMessages);

    // Add user message optimistically.
    final userMessage = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      content: content,
      imageBase64: imageBase64,
      createdAt: DateTime.now(),
    );
    allMsgs.addMessage(activeId, userMessage);

    // Update conversation metadata.
    final msgCount = (_ref.read(allMessagesProvider)[activeId] ?? []).length;
    convs.updateConversation(
      activeId,
      lastMessage: content,
      messageCount: msgCount,
      // Set title from first user message.
      title:
          msgCount <= 1
              ? (content.length > 30
                  ? '${content.substring(0, 30)}...'
                  : content)
              : null,
    );

    // Start loading.
    _ref.read(isChatLoadingProvider.notifier).state = true;

    try {
      final response = await repo.sendMessage(
        message: content,
        domain: domain,
        imageBase64: imageBase64,
        context: context.isNotEmpty ? context : null,
      );

      final assistantMessage = ChatMessage(
        id: 'assistant_${DateTime.now().millisecondsSinceEpoch}',
        role: 'assistant',
        content: response.reply,
        sources: response.sources,
        actions: response.actions.isNotEmpty ? response.actions : null,
        trackerItems:
            response.trackerItems.isNotEmpty ? response.trackerItems : null,
        domain: response.domain,
        usage: response.usage,
        createdAt: DateTime.now(),
      );
      allMsgs.addMessage(activeId, assistantMessage);

      // Update conversation with assistant reply preview.
      final newCount = (_ref.read(allMessagesProvider)[activeId] ?? []).length;
      convs.updateConversation(
        activeId,
        lastMessage:
            response.reply.length > 60
                ? '${response.reply.substring(0, 60)}...'
                : response.reply,
        messageCount: newCount,
      );

      // Update usage.
      _ref.read(chatUsageProvider.notifier).state = response.usage;
    } catch (error) {
      final errorMessage = ChatMessage(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        role: 'assistant',
        content: '',
        createdAt: DateTime.now(),
      );
      allMsgs.addMessage(activeId, errorMessage);
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
