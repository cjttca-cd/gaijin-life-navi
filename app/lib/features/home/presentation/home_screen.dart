import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../chat/presentation/providers/chat_providers.dart';

/// Home / Dashboard screen (S07) — handoff-home.md spec.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final user = ref.watch(authStateProvider).valueOrNull;
    final isGuest = user == null;

    // Fetch usage data for logged-in users.
    if (!isGuest) {
      ref.watch(fetchUsageProvider);
    }

    // Determine greeting based on time.
    final hour = DateTime.now().hour;
    final name = user?.displayName ?? user?.email?.split('@').first ?? '';
    final greeting = _greeting(l10n, hour, name);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh usage data if available.
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.space2xl),

                // ── Greeting ─────────────────────────────────
                Text(greeting, style: tt.displayMedium),
                const SizedBox(height: AppSpacing.spaceXs),
                // Usage line (hidden for guests) — reads from shared chatUsageProvider.
                if (!isGuest)
                  Consumer(
                    builder: (context, ref, _) {
                      final usage = ref.watch(chatUsageProvider);
                      if (usage == null || usage.isUnlimited) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        l10n.homeUsageFree(usage.remaining, usage.limit),
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      );
                    },
                  ),

                // ── Guest Registration CTA Banner ─────────────
                if (isGuest) ...[
                  const SizedBox(height: AppSpacing.spaceLg),
                  _GuestCtaBanner(
                    text: l10n.homeGuestCtaText,
                    cta: l10n.homeGuestCtaButton,
                    onTap: () => context.push(AppRoutes.register),
                  ),
                ],

                const SizedBox(height: AppSpacing.space2xl),

                // ── Quick Actions ─────────────────────────────
                Text(
                  l10n.homeSectionQuickActions.toUpperCase(),
                  style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.spaceMd,
                  crossAxisSpacing: AppSpacing.spaceMd,
                  childAspectRatio: 1.3,
                  children: [
                    // Guests: Navigator + Emergency only.
                    // Logged-in: AI Chat + Banking + Visa + Medical.
                    if (!isGuest)
                      _QuickActionCard(
                        icon: Icons.chat_bubble_outline,
                        iconBgColor: AppColors.primaryContainer,
                        iconColor: AppColors.primaryDark,
                        title: l10n.homeQaChatTitle,
                        subtitle: l10n.homeQaChatSubtitle,
                        onTap: () => _openChat(context),
                      ),
                    _QuickActionCard(
                      icon: Icons.account_balance,
                      iconBgColor: AppColors.bankingContainer,
                      iconColor: AppColors.bankingIcon,
                      title: l10n.homeQaBankingTitle,
                      subtitle: l10n.homeQaBankingSubtitle,
                      onTap:
                          () => context.push('${AppRoutes.navigate}/banking'),
                    ),
                    if (!isGuest)
                      _QuickActionCard(
                        icon: Icons.badge,
                        iconBgColor: AppColors.visaContainer,
                        iconColor: AppColors.visaIcon,
                        title: l10n.homeQaVisaTitle,
                        subtitle: l10n.homeQaVisaSubtitle,
                        onTap: () => context.push('${AppRoutes.navigate}/visa'),
                      ),
                    if (!isGuest)
                      _QuickActionCard(
                        icon: Icons.assignment_outlined,
                        iconBgColor: AppColors.adminContainer,
                        iconColor: AppColors.adminIcon,
                        title: l10n.homeQaTrackerTitle,
                        subtitle: l10n.homeQaTrackerSubtitle,
                        onTap: () => context.push(AppRoutes.tracker),
                      ),
                    _QuickActionCard(
                      icon: Icons.local_hospital,
                      iconBgColor: AppColors.medicalContainer,
                      iconColor: AppColors.medicalIcon,
                      title: l10n.homeQaMedicalTitle,
                      subtitle: l10n.homeQaMedicalSubtitle,
                      onTap: () => context.push(AppRoutes.emergency),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.space2xl),

                // ── Explore Guides ─────────────────────────────
                Text(
                  l10n.homeSectionExplore.toUpperCase(),
                  style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                _ExploreItem(
                  icon: Icons.explore_outlined,
                  label: l10n.homeExploreGuides,
                  onTap: () => context.go(AppRoutes.navigate),
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                _ExploreItem(
                  icon: Icons.emergency_outlined,
                  label: l10n.homeExploreEmergency,
                  iconColor: AppColors.error,
                  onTap: () => context.push(AppRoutes.emergency),
                ),

                const SizedBox(height: AppSpacing.space2xl),

                // ── Upgrade Banner (Free/Guest) ───────────────
                _UpgradeBannerWithAnalytics(
                  title: l10n.homeUpgradeTitle,
                  cta: isGuest ? l10n.chatGuestSignUp : l10n.homeUpgradeCta,
                  isGuest: isGuest,
                ),

                const SizedBox(height: AppSpacing.space3xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _greeting(AppLocalizations l10n, int hour, String name) {
    if (name.isEmpty) return l10n.homeGreetingNoName;
    if (hour >= 5 && hour < 12) return l10n.homeGreetingMorning(name);
    if (hour >= 12 && hour < 17) return l10n.homeGreetingAfternoon(name);
    if (hour >= 17 || hour < 5) return l10n.homeGreetingEvening(name);
    return l10n.homeGreetingDefault(name);
  }

  void _openChat(BuildContext context) {
    // Phase 0: single conversation — continue existing chat, don't clear.
    context.push(AppRoutes.chatConversation.replaceFirst(':id', 'current'));
  }
}

/// Quick action card — handoff-home.md §3 component mapping.
class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const Spacer(),
              Text(title, style: tt.titleMedium),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExploreItem extends StatelessWidget {
  const _ExploreItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceLg,
            vertical: AppSpacing.spaceMd,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? cs.onSurfaceVariant),
              const SizedBox(width: AppSpacing.spaceMd),
              Expanded(child: Text(label, style: tt.titleSmall)),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

/// Guest registration CTA card — shown at the top of the guest Home screen.
///
/// Per task-041 spec:
///   - Card format with colorPrimaryContainer background
///   - "Create your free account to unlock AI chat and personalized guides"
///   - "Get Started" button → /register
class _GuestCtaBanner extends StatelessWidget {
  const _GuestCtaBanner({
    required this.text,
    required this.cta,
    required this.onTap,
  });

  final String text;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      color: cs.primaryContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: cs.onPrimaryContainer,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Text(
                    text,
                    style: tt.titleSmall?.copyWith(
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(onPressed: onTap, child: Text(cta)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Upgrade banner with analytics tracking for upgrade_cta_shown / upgrade_cta_tapped.
class _UpgradeBannerWithAnalytics extends ConsumerStatefulWidget {
  const _UpgradeBannerWithAnalytics({
    required this.title,
    required this.cta,
    required this.isGuest,
  });

  final String title;
  final String cta;
  final bool isGuest;

  @override
  ConsumerState<_UpgradeBannerWithAnalytics> createState() =>
      _UpgradeBannerWithAnalyticsState();
}

class _UpgradeBannerWithAnalyticsState
    extends ConsumerState<_UpgradeBannerWithAnalytics> {
  bool _ctaShownLogged = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final tier = ref.watch(userTierProvider);

    // Log upgrade_cta_shown once.
    if (!_ctaShownLogged) {
      _ctaShownLogged = true;
      ref
          .read(analyticsServiceProvider)
          .logUpgradeCTAShown(
            tier: widget.isGuest ? 'guest' : tier,
            source: 'home',
          );
    }

    return Material(
      color: AppColors.tertiaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ref
              .read(analyticsServiceProvider)
              .logUpgradeCTATapped(
                tier: widget.isGuest ? 'guest' : tier,
                source: 'home',
              );
          context.push(
            widget.isGuest ? AppRoutes.register : AppRoutes.subscription,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          child: Row(
            children: [
              const Icon(Icons.star, color: AppColors.tertiary, size: 24),
              const SizedBox(width: AppSpacing.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: tt.titleSmall?.copyWith(
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(analyticsServiceProvider)
                      .logUpgradeCTATapped(
                        tier: widget.isGuest ? 'guest' : tier,
                        source: 'home',
                      );
                  context.push(
                    widget.isGuest
                        ? AppRoutes.register
                        : AppRoutes.subscription,
                  );
                },
                child: Text(widget.cta),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
