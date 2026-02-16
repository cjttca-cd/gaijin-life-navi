import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import 'providers/chat_providers.dart';
import 'widgets/message_bubble.dart';
import 'widgets/usage_counter.dart';

/// Chat conversation screen (S09) — SSE streaming + message bubbles.
class ChatConversationScreen extends ConsumerStatefulWidget {
  const ChatConversationScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<ChatConversationScreen> createState() =>
      _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends ConsumerState<ChatConversationScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final usage = ref.read(chatUsageProvider);
    if (usage != null && usage.chatRemaining <= 0 && usage.chatLimit > 0) {
      _showLimitReachedDialog();
      return;
    }

    _textController.clear();

    final controller = ref.read(chatStreamControllerProvider);
    await controller.sendMessage(widget.sessionId, text);

    // Refresh session list to get updated title.
    ref.read(chatSessionsProvider.notifier).refresh();
  }

  void _showLimitReachedDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chatLimitReachedTitle),
        content: Text(l10n.chatLimitReachedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.chatDeleteCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: Navigate to subscription screen.
            },
            child: Text(l10n.chatUpgradeToPremium),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.sessionId));
    final isStreaming = ref.watch(isChatStreamingProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Auto-scroll when messages change.
    ref.listen(chatMessagesProvider(widget.sessionId), (_, __) {
      _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatConversationTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: UsageCounter(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list.
          Expanded(
            child: messagesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(l10n.genericError),
              ),
              data: (messages) {
                if (messages.isEmpty && !isStreaming) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.smart_toy,
                            size: 64,
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.chatWelcomePrompt,
                            style: theme.textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.chatWelcomeHint,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: messages.length + (isStreaming ? 0 : 0),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isLastAssistant = message.isAssistant &&
                        index == messages.length - 1 &&
                        isStreaming;
                    return MessageBubble(
                      message: message,
                      isStreaming: isLastAssistant,
                    );
                  },
                );
              },
            ),
          ),

          // Input area.
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: l10n.chatInputHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    enabled: !isStreaming,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: isStreaming ? null : _sendMessage,
                  icon: isStreaming
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
