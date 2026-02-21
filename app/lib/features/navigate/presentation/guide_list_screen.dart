import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
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
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          return _buildGuideList(context, guides, colors);
        },
      ),
    );
  }

  Widget _buildGuideList(
    BuildContext context,
    List<NavigatorGuide> guides,
    DomainColorSet colors,
  ) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Filter guides by search query
    final filteredGuides =
        _searchQuery.isEmpty
            ? guides
            : guides
                .where(
                  (g) => g.title.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                )
                .toList();

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.guideSearchPlaceholder,
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon:
                  _searchQuery.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                      : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceLg,
                vertical: AppSpacing.spaceMd,
              ),
            ),
            style: theme.textTheme.bodyMedium,
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),

        // Guide list
        Expanded(
          child:
              filteredGuides.isEmpty
                  ? _buildSearchEmpty(context)
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    itemCount: filteredGuides.length,
                    separatorBuilder:
                        (_, __) => const SizedBox(height: AppSpacing.spaceSm),
                    itemBuilder: (context, index) {
                      final guide = filteredGuides[index];
                      return _GuideCard(
                        guide: guide,
                        domain: widget.domain,
                        accentColor: colors.accent,
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildSearchEmpty(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Text(
            l10n.guideSearchEmpty(_searchQuery),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            l10n.guideSearchTry,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
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

/// Guide card with left accent bar.
class _GuideCard extends StatelessWidget {
  const _GuideCard({
    required this.guide,
    required this.domain,
    required this.accentColor,
  });

  final NavigatorGuide guide;
  final String domain;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                          if (guide.isPremium) ...[
                            const SizedBox(width: AppSpacing.spaceXs),
                            Icon(
                              Icons.lock,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ],
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
