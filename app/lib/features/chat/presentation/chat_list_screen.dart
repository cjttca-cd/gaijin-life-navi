import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';
import 'providers/chat_providers.dart';

/// Chat tab — conversation list with new chat FAB.
///
/// Each conversation is a separate stateless /reset session.
/// Conversation history is stored locally.
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final conversations = ref.watch(sortedConversationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewChat(context, ref),
        child: const Icon(Icons.add),
      ),
      body: conversations.isEmpty
          ? _buildEmptyState(context, l10n, ref)
          : _buildConversationList(context, ref, l10n, conversations),
    );
  }

  Widget _buildConversationList(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<dynamic> conversations,
  ) {
    final theme = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.spaceSm,
      ),
      itemCount: conversations.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.spaceXs),
      itemBuilder: (context, index) {
        final conv = conversations[index];
        final title = conv.title ?? l10n.chatNewSession;
        final preview = conv.lastMessage ?? '';
        final time = conv.lastMessageAt ?? conv.createdAt;
        final timeStr = _formatTime(time);

        return Dismissible(
          key: Key(conv.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.spaceLg),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.delete, color: theme.colorScheme.onErrorContainer),
          ),
          onDismissed: (_) {
            ref.read(conversationsProvider.notifier).deleteConversation(conv.id);
            ref.read(allMessagesProvider.notifier).clearConversation(conv.id);
          },
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              title: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: preview.isNotEmpty
                  ? Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : null,
              trailing: Text(
                timeStr,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                ref.read(activeConversationIdProvider.notifier).state = conv.id;
                context.push(
                  AppRoutes.chatConversation.replaceFirst(':id', conv.id),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
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
    final convId = ref.read(conversationsProvider.notifier).createConversation();
    ref.read(activeConversationIdProvider.notifier).state = convId;
    context.push(AppRoutes.chatConversation.replaceFirst(':id', convId));
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return DateFormat.Hm().format(time);
    if (diff.inDays < 7) return DateFormat.E().format(time);
    return DateFormat.MMMd().format(time);
  }
}
