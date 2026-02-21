import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../chat/presentation/providers/chat_providers.dart';
import '../domain/navigator_domain.dart';
import 'providers/navigator_providers.dart';

/// S11: Navigator Guide Detail — full guide with markdown content.
class GuideDetailScreen extends ConsumerStatefulWidget {
  const GuideDetailScreen({
    super.key,
    required this.domain,
    required this.slug,
  });

  final String domain;
  final String slug;

  @override
  ConsumerState<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends ConsumerState<GuideDetailScreen> {
  bool _guideViewedLogged = false;

  String get domain => widget.domain;
  String get slug => widget.slug;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final detailAsync = ref.watch(
      guideDetailProvider((domain: domain, slug: slug)),
    );
    final domainLabel = _getDomainLabel(domain, l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(domainLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: l10n.guideShare,
            onPressed: () {
              // Share functionality placeholder
            },
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => _buildSkeleton(context),
        error: (error, _) => _buildError(context, ref, error),
        data: (detail) {
          // Log guide_viewed analytics event (once per screen visit).
          if (!_guideViewedLogged) {
            _guideViewedLogged = true;
            ref
                .read(analyticsServiceProvider)
                .logGuideViewed(domain: domain, slug: slug);
          }

          // Per BUSINESS_RULES.md §2 Access Boundary Matrix:
          //   - Banking guides: full content for all (including guests)
          //   - Other domains: guests see first 200 chars + registration CTA
          final isGuest = ref.watch(authStateProvider).valueOrNull == null;
          final isFinance = domain == 'finance';
          final showFullContent = !isGuest || isFinance;

          // Check if the guide is locked by the API (premium access control).
          final isLocked = detail.locked;

          // Truncate content for guests on non-banking domains.
          final displayContent =
              showFullContent
                  ? detail.content
                  : _truncateContent(detail.content, 200);

          // If the guide is locked, show the locked view.
          if (isLocked) {
            return _buildLockedView(context, detail, l10n, theme);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.spaceLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Guide title
                Text(detail.title, style: theme.textTheme.headlineLarge),
                const SizedBox(height: AppSpacing.spaceLg),

                // Divider
                Divider(color: theme.colorScheme.outlineVariant, height: 1),
                const SizedBox(height: AppSpacing.spaceLg),

                // Markdown content (full or truncated)
                MarkdownBody(
                  data: displayContent,
                  selectable: true,
                  styleSheet: _markdownStyleSheet(theme),
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      launchUrl(
                        Uri.parse(href),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),

                // Guest content gate CTA (non-banking only)
                if (!showFullContent) ...[
                  const SizedBox(height: AppSpacing.spaceLg),
                  _GuestContentGate(l10n: l10n, theme: theme),
                ],

                const SizedBox(height: AppSpacing.space2xl),

                // Disclaimer
                Divider(color: theme.colorScheme.outlineVariant, height: 1),
                const SizedBox(height: AppSpacing.spaceLg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.spaceXs),
                    Expanded(
                      child: Text(
                        l10n.guideDisclaimer,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space2xl),

                // Ask AI button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => context.go(AppRoutes.chat),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 20),
                        const SizedBox(width: AppSpacing.spaceSm),
                        Text(l10n.guideAskAi),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.space2xl),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the locked guide view: excerpt with gradient fade + upgrade CTA.
  Widget _buildLockedView(
    BuildContext context,
    NavigatorGuideDetail detail,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final excerptText = detail.excerpt ?? detail.summary ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.spaceLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Guide title
          Text(detail.title, style: theme.textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.spaceLg),

          // Divider
          Divider(color: theme.colorScheme.outlineVariant, height: 1),
          const SizedBox(height: AppSpacing.spaceLg),

          // Excerpt text
          if (excerptText.isNotEmpty)
            MarkdownBody(
              data: excerptText,
              selectable: true,
              styleSheet: _markdownStyleSheet(theme),
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(
                    Uri.parse(href),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),

          // Gradient fade-out effect over placeholder lines
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withValues(alpha: 0),
                ],
                stops: const [0.0, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
                  child: Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.spaceLg),

          // Lock icon + locked message
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                Text(
                  l10n.guideLocked,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.spaceLg),

          // Upgrade banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.spaceLg),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.star,
                  size: 32,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                Text(
                  l10n.guideUpgradePrompt,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {
                      final tier = ref.read(userTierProvider);
                      ref
                          .read(analyticsServiceProvider)
                          .logUpgradeCTATapped(
                            tier: tier,
                            source: 'navigator_locked',
                          );
                      context.push(AppRoutes.subscription);
                    },
                    child: Text(l10n.guideUpgradeButton),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.space2xl),
        ],
      ),
    );
  }

  MarkdownStyleSheet _markdownStyleSheet(ThemeData theme) {
    return MarkdownStyleSheet(
      h1: theme.textTheme.headlineLarge?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      h2: theme.textTheme.headlineMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      h3: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      p: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      strong: const TextStyle(fontWeight: FontWeight.w600),
      a: TextStyle(
        color: theme.colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
      listBullet: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
      code: theme.textTheme.bodySmall?.copyWith(
        fontFamily: 'monospace',
        backgroundColor: AppColors.surfaceDim,
      ),
      codeblockDecoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(4),
      ),
      codeblockPadding: const EdgeInsets.all(AppSpacing.spaceSm),
      blockquoteDecoration: BoxDecoration(
        color: AppColors.primaryFixed,
        border: const Border(
          left: BorderSide(color: AppColors.primary, width: 3),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(
        AppSpacing.spaceMd,
        AppSpacing.spaceSm,
        AppSpacing.spaceSm,
        AppSpacing.spaceSm,
      ),
      h1Padding: const EdgeInsets.only(top: AppSpacing.space2xl),
      h2Padding: const EdgeInsets.only(top: AppSpacing.spaceXl),
      h3Padding: const EdgeInsets.only(top: AppSpacing.spaceLg),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.space2xl),
          ...List.generate(
            6,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
              child: Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final errorStr = error.toString();

    // Check if 403 TIER_LIMIT_EXCEEDED — show upgrade CTA.
    final isTierLimit =
        errorStr.contains('403') || errorStr.contains('TIER_LIMIT_EXCEEDED');
    if (isTierLimit) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.space4xl),
            _PremiumContentGate(l10n: l10n, theme: theme),
          ],
        ),
      );
    }

    // Check if 404
    final is404 = errorStr.contains('404');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Text(
            is404 ? l10n.guideErrorNotFound : l10n.guideErrorLoadDetail,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          if (!is404)
            TextButton(
              onPressed:
                  () => ref.invalidate(
                    guideDetailProvider((domain: domain, slug: slug)),
                  ),
              child: Text(l10n.navErrorRetry),
            )
          else
            TextButton(
              onPressed: () => context.pop(),
              child: Text(l10n.guideErrorRetryBack),
            ),
        ],
      ),
    );
  }

  /// Truncate markdown content to approximately [maxChars] characters,
  /// breaking at the nearest word boundary.
  String _truncateContent(String content, int maxChars) {
    if (content.length <= maxChars) return content;
    final truncated = content.substring(0, maxChars);
    final lastSpace = truncated.lastIndexOf(' ');
    return '${lastSpace > 0 ? truncated.substring(0, lastSpace) : truncated}…';
  }

  String _getDomainLabel(String domainId, AppLocalizations l10n) {
    switch (domainId) {
      case 'finance':
        return l10n.domainFinance;
      case 'tax':
        return l10n.domainTax;
      case 'visa':
        return l10n.domainVisa;
      case 'medical':
        return l10n.domainMedical;
      case 'life':
        return l10n.domainLife;
      case 'legal':
        return l10n.domainLegal;
      default:
        return domainId;
    }
  }
}

/// CTA card shown to guests on non-finance guide detail pages.
/// Encourages registration to view the full guide content.
///
/// Per task-041 spec:
///   - colorTertiaryContainer (#FEF3C7) background
///   - Icon + "Sign up to read the full guide" text
///   - "Create Free Account" button → /register
class _GuestContentGate extends StatelessWidget {
  const _GuestContentGate({required this.l10n, required this.theme});

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lock_outline,
            size: 32,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Text(
            l10n.guideReadMore,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () => context.push(AppRoutes.register),
              child: Text(l10n.guideGuestCtaButton),
            ),
          ),
        ],
      ),
    );
  }
}

/// CTA card shown when backend returns 403 TIER_LIMIT_EXCEEDED.
/// Encourages free users to upgrade to Premium.
/// Logs upgrade_cta_shown on display and upgrade_cta_tapped on button press.
class _PremiumContentGate extends ConsumerStatefulWidget {
  const _PremiumContentGate({required this.l10n, required this.theme});

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  ConsumerState<_PremiumContentGate> createState() =>
      _PremiumContentGateState();
}

class _PremiumContentGateState extends ConsumerState<_PremiumContentGate> {
  bool _ctaShownLogged = false;

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final theme = widget.theme;

    // Log upgrade_cta_shown once.
    if (!_ctaShownLogged) {
      _ctaShownLogged = true;
      final tier = ref.read(userTierProvider);
      ref
          .read(analyticsServiceProvider)
          .logUpgradeCTAShown(tier: tier, source: 'navigator');
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.star,
            size: 32,
            color: theme.colorScheme.onTertiaryContainer,
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Text(
            l10n.guidePremiumCta,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () {
                final tier = ref.read(userTierProvider);
                ref
                    .read(analyticsServiceProvider)
                    .logUpgradeCTATapped(tier: tier, source: 'navigator');
                context.push(AppRoutes.subscription);
              },
              child: Text(l10n.guidePremiumCtaButton),
            ),
          ),
        ],
      ),
    );
  }
}
