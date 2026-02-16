import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import 'providers/chat_providers.dart';
import 'widgets/usage_counter.dart';

/// Chat session list screen (S08).
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(chatSessionsProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: UsageCounter(),
          ),
        ],
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(l10n.genericError),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(chatSessionsProvider.notifier).refresh(),
                child: Text(l10n.chatRetry),
              ),
            ],
          ),
        ),
        data: (sessions) => sessions.isEmpty
            ? _buildEmptyState(context, l10n, theme, ref)
            : _buildSessionList(context, sessions, l10n, theme, ref),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewChat(context, ref),
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
              onPressed: () => _createNewChat(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.chatNewSession),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionList(
    BuildContext context,
    List sessions,
    AppLocalizations l10n,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return RefreshIndicator(
      onRefresh: () => ref.read(chatSessionsProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Dismissible(
            key: ValueKey(session.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              color: theme.colorScheme.error,
              child: Icon(Icons.delete, color: theme.colorScheme.onError),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.chatDeleteTitle),
                  content: Text(l10n.chatDeleteConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(l10n.chatDeleteCancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text(l10n.chatDeleteAction),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) {
              ref
                  .read(chatSessionsProvider.notifier)
                  .deleteSession(session.id);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  _categoryIcon(session.category),
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                session.title ?? l10n.chatUntitledSession,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                _formatDate(session.updatedAt),
                style: theme.textTheme.bodySmall,
              ),
              trailing: Text(
                '${session.messageCount}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () {
                context.go('${AppRoutes.chat}/${session.id}');
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _createNewChat(BuildContext context, WidgetRef ref) async {
    try {
      final session =
          await ref.read(chatSessionsProvider.notifier).createSession();
      if (context.mounted) {
        context.go('${AppRoutes.chat}/${session.id}');
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).genericError),
          ),
        );
      }
    }
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'banking' => Icons.account_balance,
      'visa' => Icons.card_travel,
      'medical' => Icons.medical_services,
      'admin' => Icons.assignment,
      'housing' => Icons.home,
      'work' => Icons.work,
      'daily_life' => Icons.sunny,
      _ => Icons.chat,
    };
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}
