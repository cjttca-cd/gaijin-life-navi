import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import 'providers/chat_providers.dart';
import 'widgets/usage_counter.dart';

/// Chat tab screen (S08) — Phase 0: single conversation, no session list.
///
/// Navigates directly to the conversation screen.
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final messages = ref.watch(chatMessagesProvider);

    // If we have messages, show conversation inline.
    if (messages.isNotEmpty) {
      // Navigate to conversation screen.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(AppRoutes.chatConversation.replaceFirst(':id', 'current'));
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        actions: const [
          Padding(padding: EdgeInsets.only(right: 8), child: UsageCounter()),
        ],
      ),
      body: _buildEmptyState(context, l10n, theme, ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewChat(context, ref),
        child: const Icon(Icons.add),
      ),
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
    // Clear any previous messages and go to conversation.
    ref.read(chatMessagesProvider.notifier).clear();
    context.go(AppRoutes.chatConversation.replaceFirst(':id', 'current'));
  }
}
