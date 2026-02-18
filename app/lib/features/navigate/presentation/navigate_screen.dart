import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/domain_colors.dart';
import '../domain/navigator_domain.dart';
import 'providers/navigator_providers.dart';

/// S09: Navigator Top — Domain Grid with cross-domain search.
///
/// Displays 2-column grid of navigator domains.
/// Active domains navigate to Guide List (S10).
/// Coming Soon domains show a snackbar.
/// Search bar at top searches across ALL domain guides.
class NavigateScreen extends ConsumerStatefulWidget {
  const NavigateScreen({super.key});

  @override
  ConsumerState<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends ConsumerState<NavigateScreen> {
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
    final domainsAsync = ref.watch(navigatorDomainsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navTitle)),
      body: Column(
        children: [
          // Cross-domain search bar
          _buildSearchBar(context),

          // Show search results or domain grid
          Expanded(
            child: _searchQuery.isNotEmpty
                ? _buildSearchResults(context, ref)
                : domainsAsync.when(
                    loading: () => _buildSkeleton(context),
                    error: (error, _) => _buildError(context, ref),
                    data: (domains) => _buildGrid(context, domains),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.spaceSm,
        AppSpacing.screenPadding,
        0,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.guideSearchPlaceholder,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
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
    );
  }

  Widget _buildSearchResults(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final allGuidesAsync = ref.watch(allGuidesProvider);

    return allGuidesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Text(
          l10n.guideErrorLoad,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      data: (allGuides) {
        final query = _searchQuery.toLowerCase();
        final filtered = allGuides
            .where((g) =>
                g.title.toLowerCase().contains(query) ||
                (g.summary?.toLowerCase().contains(query) ?? false))
            .toList();

        if (filtered.isEmpty) {
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
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: filtered.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppSpacing.spaceSm),
          itemBuilder: (context, index) {
            final guide = filtered[index];
            final colors = DomainColors.forDomain(guide.domain ?? 'concierge');
            return _SearchGuideCard(
              guide: guide,
              accentColor: colors.accent,
            );
          },
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<NavigatorDomain> domains) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Separate active and coming_soon domains
    final activeDomains = domains.where((d) => d.isActive).toList();
    final comingSoonDomains = domains.where((d) => d.isComingSoon).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.spaceLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtitle
          Text(
            l10n.navSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),

          // Active domains grid
          _DomainGrid(domains: activeDomains, isComingSoon: false),

          if (comingSoonDomains.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space2xl),
            // Coming Soon domains grid
            _DomainGrid(domains: comingSoonDomains, isComingSoon: true),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.spaceMd,
          mainAxisSpacing: AppSpacing.spaceMd,
          childAspectRatio: 0.95,
        ),
        itemCount: 4,
        itemBuilder:
            (context, index) => Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spaceLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceMd),
                    Container(
                      width: 80,
                      height: 14,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceXs),
                    Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
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
            l10n.navErrorLoad,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          TextButton(
            onPressed: () => ref.invalidate(navigatorDomainsProvider),
            child: Text(l10n.navErrorRetry),
          ),
        ],
      ),
    );
  }
}

/// 2-column grid of domain cards.
class _DomainGrid extends StatelessWidget {
  const _DomainGrid({required this.domains, required this.isComingSoon});

  final List<NavigatorDomain> domains;
  final bool isComingSoon;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.spaceMd,
        mainAxisSpacing: AppSpacing.spaceMd,
        childAspectRatio: 0.95,
      ),
      itemCount: domains.length,
      itemBuilder:
          (context, index) =>
              _DomainCard(domain: domains[index], isComingSoon: isComingSoon),
    );
  }
}

/// Single domain card in the navigator grid.
class _DomainCard extends StatelessWidget {
  const _DomainCard({required this.domain, required this.isComingSoon});

  final NavigatorDomain domain;
  final bool isComingSoon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = DomainColors.forDomain(domain.id);
    final icon = DomainColors.iconForDomain(domain.id);
    final domainLabel = _getDomainLabel(domain.id, l10n);

    Widget card = Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            isComingSoon
                ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.navComingSoonSnackbar)),
                  );
                }
                : () {
                  context.push('${AppRoutes.navigate}/${domain.id}');
                },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.container,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: colors.icon),
              ),
              const SizedBox(height: AppSpacing.spaceMd),

              // Domain name
              Text(
                domainLabel,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.spaceXs),

              // Guide count or Coming Soon badge
              if (isComingSoon)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceSm,
                    vertical: AppSpacing.space2xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.navComingSoon,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                Text(
                  domain.guideCount == 1
                      ? l10n.navGuideCountOne
                      : l10n.navGuideCount(domain.guideCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (isComingSoon) {
      card = Opacity(opacity: 0.5, child: card);
    }

    return card;
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

/// Guide card used in cross-domain search results.
class _SearchGuideCard extends StatelessWidget {
  const _SearchGuideCard({
    required this.guide,
    required this.accentColor,
  });

  final NavigatorGuide guide;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final domain = guide.domain ?? 'concierge';
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
                      Text(
                        guide.title,
                        style: theme.textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
