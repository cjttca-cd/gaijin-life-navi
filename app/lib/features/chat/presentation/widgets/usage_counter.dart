import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/router_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/chat_providers.dart';
import '../../../../core/config/app_config.dart';

/// Usage limit banner — shows remaining credits for non-unlimited tiers.
///
/// Credit Ledger behavior:
///   - free/standard: shows total remaining credits
///   - premium: hidden (unlimited)
///   - exhausted + guest → registration CTA
///   - exhausted + free → upgrade CTA
class UsageCounter extends ConsumerWidget {
  const UsageCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(chatUsageProvider);
    if (usage == null) return const SizedBox.shrink();

    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    // Hide in TestFlight mode — no payment prompts during testing.
    if (AppConfig.testFlightMode) return const SizedBox.shrink();

    // Don't show for unlimited (premium) users.
    if (usage.isUnlimited) return const SizedBox.shrink();

    final remaining = usage.remaining;
    final isExhausted = remaining <= 0;
    final isAnonymous = ref.watch(isAnonymousProvider);
    final isGuest = usage.tier == 'guest' || isAnonymous;

    // Exhausted state — show CTA
    if (isExhausted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outlined,
                  size: 16,
                  color: AppColors.onErrorContainer,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    l10n.chatLimitExhausted,
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 32,
              child: TextButton(
                onPressed: () {
                  if (isGuest) {
                    context.push(AppRoutes.register);
                  } else {
                    context.push(AppRoutes.subscription);
                  }
                },
                child: Text(
                  isGuest ? l10n.chatGuestExhausted : l10n.chatFreeExhausted,
                  style: tt.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Show remaining credits
    final String displayText = l10n.chatCreditsRemaining(remaining);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warningContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.warning,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              displayText,
              style: tt.bodySmall?.copyWith(
                color: AppColors.onWarningContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
