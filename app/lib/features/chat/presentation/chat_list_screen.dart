import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import 'providers/chat_providers.dart';

/// Chat tab screen — shows conversation list + new chat FAB.
///
/// Each conversation is a separate stateless /reset session.
/// Conversation history is stored locally via chatMessagesProvider.
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final messages = ref.watch(chatMessagesProvider);

    // If there are existing messages, show a single "current" conversation.
    // Future: support multiple conversations.
    final hasConversation = messages.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewChat(context, ref),
        child: const Icon(Icons.add),
      ),
      body: hasConversation
          ? _buildConversationList(context, ref, l10n, theme, messages)
          : _buildEmptyState(context, l10n, theme, ref),
    );
  }

  Widget _buildConversationList(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
    List<dynamic> messages,
  ) {
    // Get the last user message as preview.
    final lastUserMsgIndex = messages.lastIndexWhere((m) => m.role == 'user');
    final lastUserMsg = lastUserMsgIndex >= 0 ? messages[lastUserMsgIndex] : null;
    final preview = lastUserMsg?.text ?? l10n.chatEmptySubtitle;
    final truncated =
        preview.length > 60 ? '${preview.substring(0, 60)}...' : preview;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.chat_bubble_outline,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(l10n.chatTitle),
            subtitle: Text(
              truncated,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              '${messages.length}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: () => context.push(
              AppRoutes.chatConversation.replaceFirst(':id', 'current'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.chatEmptyTitle,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.chatEmptySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _startNewChat(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.chatNewSession),
            ),
          ],
        ),
      ),
    );
  }

  void _startNewChat(BuildContext context, WidgetRef ref) {
    // Clear previous messages to start a fresh conversation.
    ref.read(chatMessagesProvider.notifier).clear();
    context.push(AppRoutes.chatConversation.replaceFirst(':id', 'current'));
  }
}
