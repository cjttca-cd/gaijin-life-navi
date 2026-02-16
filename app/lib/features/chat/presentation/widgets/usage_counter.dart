import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../providers/chat_providers.dart';

/// Displays the remaining daily chat count for free-tier users.
class UsageCounter extends ConsumerWidget {
  const UsageCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(chatUsageProvider);
    if (usage == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final remaining = usage.chatRemaining;
    final limit = usage.chatLimit;

    // Don't show for unlimited (premium) users.
    if (limit <= 0) return const SizedBox.shrink();

    final isExhausted = remaining <= 0;
    final isLow = remaining <= 2 && !isExhausted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isExhausted
            ? theme.colorScheme.errorContainer
            : isLow
                ? theme.colorScheme.tertiaryContainer
                : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExhausted ? Icons.block : Icons.chat_bubble_outline,
            size: 14,
            color: isExhausted
                ? theme.colorScheme.onErrorContainer
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            isExhausted
                ? l10n.chatLimitReached
                : l10n.chatRemainingCount(remaining, limit),
            style: theme.textTheme.labelSmall?.copyWith(
              color: isExhausted
                  ? theme.colorScheme.onErrorContainer
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
