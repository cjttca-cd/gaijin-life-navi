import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Registration promotion screen shown when a guest taps the Chat tab.
///
/// Per USER_STORIES.md & BUSINESS_RULES.md §2:
///   AI Chat requires authentication (guests have 0 access).
///   This screen encourages registration with feature highlights.
///
/// Design follows DESIGN_SYSTEM.md component specs:
///   - Primary Button: §6.1.1 (Get started free)
///   - Text Button: §6.1.4 (Log in)
///   - Spacing: §3 tokens
class ChatGuestScreen extends StatelessWidget {
  const ChatGuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space2xl,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.space3xl),

                // ── Chat icon ────────────────────────────────
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    size: 40,
                    color: AppColors.primaryDark,
                  ),
                ),

                const SizedBox(height: AppSpacing.space2xl),

                // ── Title ────────────────────────────────────
                Text(
                  l10n.chatGuestTitle,
                  style: tt.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.space2xl),

                // ── Feature list ─────────────────────────────
                _FeatureRow(text: l10n.chatGuestFeature1, color: cs.primary),
                const SizedBox(height: AppSpacing.spaceMd),
                _FeatureRow(text: l10n.chatGuestFeature2, color: cs.primary),
                const SizedBox(height: AppSpacing.spaceMd),
                _FeatureRow(text: l10n.chatGuestFeature3, color: cs.primary),
                const SizedBox(height: AppSpacing.spaceMd),
                _FeatureRow(text: l10n.chatGuestFeature4, color: cs.primary),

                const SizedBox(height: AppSpacing.space2xl),

                // ── Free offer badge ─────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceLg,
                    vertical: AppSpacing.spaceMd,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        size: 20,
                        color: AppColors.onSecondaryContainer,
                      ),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Flexible(
                        child: Text(
                          l10n.chatGuestFreeOffer,
                          style: tt.bodyMedium?.copyWith(
                            color: AppColors.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.space3xl),

                // ── Primary CTA: Register ────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () => context.push(AppRoutes.register),
                    child: Text(l10n.chatGuestSignUp),
                  ),
                ),

                const SizedBox(height: AppSpacing.spaceMd),

                // ── Secondary CTA: Login ─────────────────────
                TextButton(
                  onPressed: () => context.push(AppRoutes.login),
                  child: Text(l10n.chatGuestLogin),
                ),

                const SizedBox(height: AppSpacing.space3xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.check_circle, size: 20, color: AppColors.success),
        const SizedBox(width: AppSpacing.spaceMd),
        Expanded(child: Text(text, style: tt.bodyLarge)),
      ],
    );
  }
}
