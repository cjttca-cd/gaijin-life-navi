import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/router_provider.dart';
import '../../chat/presentation/providers/chat_providers.dart';

/// Home / Dashboard screen (S07).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () async {
              await ref.read(firebaseAuthProvider).signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.travel_explore,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.homeWelcome,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.homeSubtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (user?.email != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                user!.email!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick actions.
              Text(
                l10n.homeQuickActions,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _QuickActionCard(
                    icon: Icons.smart_toy,
                    label: l10n.homeActionAskAI,
                    color: theme.colorScheme.primary,
                    onTap: () => _startNewChat(context, ref),
                  ),
                  _QuickActionCard(
                    icon: Icons.checklist,
                    label: l10n.homeActionTracker,
                    color: theme.colorScheme.tertiary,
                    onTap: () => context.go(AppRoutes.tracker),
                  ),
                  _QuickActionCard(
                    icon: Icons.account_balance,
                    label: l10n.homeActionBanking,
                    color: theme.colorScheme.secondary,
                    onTap: () => context.go(AppRoutes.navigate),
                  ),
                  _QuickActionCard(
                    icon: Icons.chat_bubble,
                    label: l10n.homeActionChatHistory,
                    color: theme.colorScheme.error,
                    onTap: () => context.go(AppRoutes.chat),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent chats.
              Text(
                l10n.homeRecentChats,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _RecentChatsList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startNewChat(BuildContext context, WidgetRef ref) async {
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
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentChatsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(chatSessionsProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return sessionsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.homeNoRecentChats,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final recentSessions = sessions.take(3).toList();
        return Column(
          children: recentSessions.map((session) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.chat,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  session.title ?? l10n.chatUntitledSession,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${session.messageCount} ${l10n.homeMessagesLabel}',
                  style: theme.textTheme.bodySmall,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.go('${AppRoutes.chat}/${session.id}');
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
