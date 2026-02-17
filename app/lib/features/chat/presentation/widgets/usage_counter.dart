import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/chat_providers.dart';

/// Usage limit banner — handoff-chat.md §3 Usage Limit Banner.
///
/// colorWarningContainer bg, shown for Free/Standard tiers.
class UsageCounter extends ConsumerWidget {
  const UsageCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(chatUsageProvider);
    if (usage == null) return const SizedBox.shrink();

    final tt = Theme.of(context).textTheme;
    final remaining = usage.chatRemaining;
    final limit = usage.chatLimit;

    // Don't show for unlimited (premium) users.
    if (limit <= 0) return const SizedBox.shrink();

    final isExhausted = remaining <= 0;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isExhausted ? AppColors.errorContainer : AppColors.warningContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExhausted ? Icons.lock_outlined : Icons.info_outline,
            size: 16,
            color: isExhausted ? AppColors.onErrorContainer : AppColors.warning,
          ),
          const SizedBox(width: 4),
          Text(
            isExhausted
                ? l10n.chatLimitExhausted
                : l10n.chatLimitRemaining(remaining, limit),
            style: tt.bodySmall?.copyWith(
              color:
                  isExhausted
                      ? AppColors.onErrorContainer
                      : AppColors.onWarningContainer,
            ),
          ),
        ],
      ),
    );
  }
}
