import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/ai_api_client.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_message.dart';
import '../../domain/chat_session.dart';
import '../../domain/sse_event.dart';

// ─── DI ──────────────────────────────────────────────────────

/// Dio instance for the AI Service.
final aiClientProvider = Provider<Dio>((ref) {
  return createAiApiClient();
});

/// Chat repository provider.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(aiClient: ref.watch(aiClientProvider));
});

// ─── Session list ────────────────────────────────────────────

/// Provider for chat session list.
final chatSessionsProvider =
    AsyncNotifierProvider<ChatSessionsNotifier, List<ChatSession>>(
  ChatSessionsNotifier.new,
);

class ChatSessionsNotifier extends AsyncNotifier<List<ChatSession>> {
  @override
  Future<List<ChatSession>> build() async {
    final repo = ref.read(chatRepositoryProvider);
    return repo.listSessions();
  }

  Future<ChatSession> createSession() async {
    final repo = ref.read(chatRepositoryProvider);
    final session = await repo.createSession();
    // Prepend new session to the list.
    final current = state.valueOrNull ?? [];
    state = AsyncData([session, ...current]);
    return session;
  }

  Future<void> deleteSession(String sessionId) async {
    final repo = ref.read(chatRepositoryProvider);
    await repo.deleteSession(sessionId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((s) => s.id != sessionId).toList());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(chatRepositoryProvider);
      return repo.listSessions();
    });
  }

  /// Update a session in the list (e.g., when title changes).
  void updateSession(ChatSession updated) {
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.map((s) => s.id == updated.id ? updated : s).toList(),
    );
  }
}

// ─── Messages for a session ──────────────────────────────────

/// Provider for messages within a specific session.
final chatMessagesProvider = AsyncNotifierProvider.family<
    ChatMessagesNotifier, List<ChatMessage>, String>(
  ChatMessagesNotifier.new,
);

class ChatMessagesNotifier
    extends FamilyAsyncNotifier<List<ChatMessage>, String> {
  @override
  Future<List<ChatMessage>> build(String arg) async {
    final repo = ref.read(chatRepositoryProvider);
    return repo.getMessages(arg);
  }

  /// Add a user message locally (optimistic).
  void addUserMessage(ChatMessage message) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, message]);
  }

  /// Add or update an assistant message.
  void upsertAssistantMessage(ChatMessage message) {
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((m) => m.id == message.id);
    if (index >= 0) {
      final updated = List<ChatMessage>.from(current);
      updated[index] = message;
      state = AsyncData(updated);
    } else {
      state = AsyncData([...current, message]);
    }
  }
}

// ─── Chat usage (remaining daily count) ──────────────────────

/// Holds the current chat usage info.
final chatUsageProvider =
    StateProvider<ChatUsage?>((ref) => null);

// ─── Streaming state ─────────────────────────────────────────

/// Whether the chat is currently streaming a response.
final isChatStreamingProvider = StateProvider<bool>((ref) => false);

/// Controller that handles sending a message and processing SSE events.
class ChatStreamController {
  ChatStreamController(this._ref);

  final Ref _ref;
  StreamSubscription<SseEvent>? _subscription;

  /// Send a message and process the SSE stream.
  Future<void> sendMessage(String sessionId, String content) async {
    final repo = _ref.read(chatRepositoryProvider);
    final messagesNotifier =
        _ref.read(chatMessagesProvider(sessionId).notifier);

    // Add user message optimistically.
    final userMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      role: 'user',
      content: content,
      createdAt: DateTime.now(),
    );
    messagesNotifier.addUserMessage(userMessage);

    // Start streaming.
    _ref.read(isChatStreamingProvider.notifier).state = true;

    String assistantId = '';
    String assistantContent = '';

    final stream = repo.sendMessage(sessionId, content);

    _subscription = stream.listen(
      (event) {
        switch (event) {
          case MessageStartEvent(:final messageId):
            assistantId = messageId;
            assistantContent = '';
            final msg = ChatMessage(
              id: assistantId,
              sessionId: sessionId,
              role: 'assistant',
              content: '',
              createdAt: DateTime.now(),
            );
            messagesNotifier.upsertAssistantMessage(msg);

          case ContentDeltaEvent(:final delta):
            assistantContent += delta;
            final msg = ChatMessage(
              id: assistantId,
              sessionId: sessionId,
              role: 'assistant',
              content: assistantContent,
              createdAt: DateTime.now(),
            );
            messagesNotifier.upsertAssistantMessage(msg);

          case MessageEndEvent(
              :final sources,
              :final disclaimer,
              :final tokensUsed,
              :final usage,
            ):
            // Finalize the message.
            final sourceCitations = sources
                ?.map((s) => SourceCitation.fromJson(s))
                .toList();
            final msg = ChatMessage(
              id: assistantId,
              sessionId: sessionId,
              role: 'assistant',
              content: assistantContent,
              sources: sourceCitations,
              disclaimer: disclaimer,
              tokensUsed: tokensUsed,
              createdAt: DateTime.now(),
            );
            messagesNotifier.upsertAssistantMessage(msg);

            // Update usage.
            if (usage != null) {
              _ref.read(chatUsageProvider.notifier).state =
                  ChatUsage.fromJson(usage);
            }

            _ref.read(isChatStreamingProvider.notifier).state = false;

          case SseErrorEvent():
            _ref.read(isChatStreamingProvider.notifier).state = false;
        }
      },
      onError: (_) {
        _ref.read(isChatStreamingProvider.notifier).state = false;
      },
      onDone: () {
        _ref.read(isChatStreamingProvider.notifier).state = false;
      },
    );
  }

  void cancel() {
    _subscription?.cancel();
    _ref.read(isChatStreamingProvider.notifier).state = false;
  }
}

/// Provider for the stream controller.
final chatStreamControllerProvider = Provider<ChatStreamController>((ref) {
  final controller = ChatStreamController(ref);
  ref.onDispose(() => controller.cancel());
  return controller;
});
