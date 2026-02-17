import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'providers/navigator_providers.dart';

/// S11: Navigator Guide Detail — full guide with markdown content.
class GuideDetailScreen extends ConsumerWidget {
  const GuideDetailScreen({
    super.key,
    required this.domain,
    required this.slug,
  });

  final String domain;
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

                // Markdown content
                MarkdownBody(
                  data: detail.content,
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
                    onPressed: () => context.push(AppRoutes.chat),
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
    // Check if 404
    final is404 = error.toString().contains('404');

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

  String _getDomainLabel(String domainId, AppLocalizations l10n) {
    switch (domainId) {
      case 'banking':
        return l10n.domainBanking;
      case 'visa':
        return l10n.domainVisa;
      case 'medical':
        return l10n.domainMedical;
      case 'concierge':
        return l10n.domainConcierge;
      case 'housing':
        return l10n.domainHousing;
      case 'employment':
        return l10n.domainEmployment;
      case 'education':
        return l10n.domainEducation;
      case 'legal':
        return l10n.domainLegal;
      default:
        return domainId;
    }
  }
}
