import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/domain_colors.dart';
import '../domain/navigator_domain.dart';
import 'providers/navigator_providers.dart';

/// S10: Navigator Guide List — guides within a domain.
class GuideListScreen extends ConsumerStatefulWidget {
  const GuideListScreen({super.key, required this.domain});

  final String domain;

  @override
  ConsumerState<GuideListScreen> createState() => _GuideListScreenState();
}

class _GuideListScreenState extends ConsumerState<GuideListScreen> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final guidesAsync = ref.watch(domainGuidesProvider(widget.domain));
    final domainLabel = _getDomainLabel(widget.domain, l10n);
    final colors = DomainColors.forDomain(widget.domain);

    return Scaffold(
      appBar: AppBar(title: Text(domainLabel)),
      body: guidesAsync.when(
        loading: () => _buildSkeleton(context),
        error: (error, _) => _buildError(context, ref),
        data: (guides) {
          if (guides.isEmpty) {
            return _buildComingSoon(context, widget.domain, colors);
          }
          return _buildGuideList(context, guides, colors, l10n);
        },
      ),
    );
  }

  Widget _buildGuideList(
    BuildContext context,
    List<NavigatorGuide> guides,
    DomainColorSet colors,
    AppLocalizations l10n,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(domainGuidesProvider(widget.domain));
        ref.invalidate(navigatorDomainsProvider);
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: guides.length + 1, // +1 for domain header
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.spaceSm),
      itemBuilder: (context, index) {
        if (index == 0) {
          // Get domain description from domains provider
          final domainsAsync = ref.watch(navigatorDomainsProvider);
          final domainDesc = domainsAsync.whenOrNull(
            data: (domains) => domains
                .where((d) => d.id == widget.domain)
                .firstOrNull
                ?.description,
          );
          return _DomainHeader(
            domain: widget.domain,
            colors: colors,
            guideCount: guides.length,
            l10n: l10n,
            description: domainDesc,
          );
        }
        final guide = guides[index - 1];
        return _GuideCard(
          guide: guide,
          domain: widget.domain,
          accentColor: colors.accent,
          domainColors: colors,
        );
      },
      ),
    );
  }

  Widget _buildComingSoon(
    BuildContext context,
    String domain,
    DomainColorSet colors,
  ) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final domainLabel = _getDomainLabel(domain, l10n);
    final icon = DomainColors.iconForDomain(domain);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space2xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.container,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: colors.icon),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            Text(
              l10n.guideComingSoonTitle,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              l10n.guideComingSoonSubtitle(domainLabel),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space2xl),
            FilledButton.tonal(
              onPressed: () {
                context.push(AppRoutes.chat);
              },
              child: Text(l10n.guideComingSoonAskAi(domainLabel)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
            child: Card(
              child: Container(
                height: 72,
                padding: const EdgeInsets.all(AppSpacing.spaceLg),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 12,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spaceXs),
                          Container(
                            width: 140,
                            height: 10,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
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
            l10n.guideErrorLoad,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          TextButton(
            onPressed:
                () => ref.invalidate(domainGuidesProvider(widget.domain)),
            child: Text(l10n.navErrorRetry),
          ),
        ],
      ),
    );
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

/// Domain header with icon, label, and guide count.
class _DomainHeader extends StatelessWidget {
  const _DomainHeader({
    required this.domain,
    required this.colors,
    required this.guideCount,
    required this.l10n,
    this.description,
  });

  final String domain;
  final DomainColorSet colors;
  final int guideCount;
  final AppLocalizations l10n;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = DomainColors.iconForDomain(domain);
    final domainLabel = _getDomainLabel(domain);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      decoration: BoxDecoration(
        color: colors.container,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: colors.icon),
          const SizedBox(width: AppSpacing.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  domainLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.icon,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2xs),
                Text(
                  l10n.guideCount(guideCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.icon,
                  ),
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.spaceXs),
                  Text(
                    description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.icon.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDomainLabel(String domainId) {
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

/// Guide card with left accent bar, access badge, and tags.
class _GuideCard extends StatelessWidget {
  const _GuideCard({
    required this.guide,
    required this.domain,
    required this.accentColor,
    required this.domainColors,
  });

  final NavigatorGuide guide;
  final String domain;
  final Color accentColor;
  final DomainColorSet domainColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push('${AppRoutes.navigate}/$domain/${guide.slug}');
        },
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left accent bar
              Container(width: 4, color: accentColor),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              guide.title,
                              style: theme.textTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.spaceXs),
                          _AccessBadge(guide: guide, l10n: l10n),
                        ],
                      ),
                      if (guide.summary != null) ...[
                        const SizedBox(height: AppSpacing.spaceXs),
                        Text(
                          guide.summary!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (guide.tags.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.spaceSm),
                        _TagChips(
                          tags: guide.tags,
                          domainColors: domainColors,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Access badge: FREE (green) or 🔒 (outline).
class _AccessBadge extends StatelessWidget {
  const _AccessBadge({required this.guide, required this.l10n});

  final NavigatorGuide guide;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (guide.isFree) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceSm,
          vertical: AppSpacing.space2xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.successContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          l10n.guideFreeLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Premium / registered — lock badge
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: AppSpacing.space2xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock,
            size: 12,
            color: theme.colorScheme.outlineVariant,
          ),
        ],
      ),
    );
  }
}

/// Tag chips row — max 3 tags displayed.
class _TagChips extends StatelessWidget {
  const _TagChips({
    required this.tags,
    required this.domainColors,
  });

  final List<String> tags;
  final DomainColorSet domainColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTags = tags.length > 3 ? tags.sublist(0, 3) : tags;

    return Wrap(
      spacing: AppSpacing.spaceXs,
      runSpacing: AppSpacing.spaceXs,
      children: displayTags.map((tag) {
        return Container(
          height: 24,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceMd,
            vertical: AppSpacing.spaceXs,
          ),
          decoration: BoxDecoration(
            color: domainColors.container,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            tag,
            style: theme.textTheme.labelSmall?.copyWith(
              color: domainColors.icon,
            ),
          ),
        );
      }).toList(),
    );
  }
}
