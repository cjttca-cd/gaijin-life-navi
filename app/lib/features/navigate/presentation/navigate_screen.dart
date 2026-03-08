import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/domain_colors.dart';
import '../domain/navigator_domain.dart';
import 'providers/navigator_providers.dart';

/// S09: Navigator Top — Domain Grid with AI banner.
///
/// Displays AI guide banner at the top, followed by a 2-column grid
/// of navigator domains. Tapping a domain navigates to Guide List (S10).
class NavigateScreen extends ConsumerWidget {
  const NavigateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final domainsAsync = ref.watch(navigatorDomainsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navTitle)),
      body: domainsAsync.when(
        loading: () => _buildSkeleton(context),
        error: (error, _) => _buildError(context, ref),
        data: (domains) => _buildGrid(context, domains),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<NavigatorDomain> domains) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.spaceLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Guide banner
          _AiBanner(),
          const SizedBox(height: AppSpacing.spaceLg),

          // Subtitle
          Text(
            l10n.navSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),

          // Domain grid (all active)
          _DomainGrid(domains: domains),
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
          childAspectRatio: 0.85,
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

/// AI Guide banner — encourages users to try the AI chat.
class _AiBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.chat),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          child: Row(
            children: [
              const Text('🤖', style: TextStyle(fontSize: 32)),
              const SizedBox(width: AppSpacing.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.navAiSearchTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2xs),
                    Text(
                      l10n.navAiSearchSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spaceSm),
                    FilledButton.tonal(
                      onPressed: () => context.push(AppRoutes.chat),
                      child: Text(l10n.navAiSearchButton),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2-column grid of domain cards.
class _DomainGrid extends StatelessWidget {
  const _DomainGrid({required this.domains});

  final List<NavigatorDomain> domains;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.spaceMd,
        mainAxisSpacing: AppSpacing.spaceMd,
        childAspectRatio: 0.85,
      ),
      itemCount: domains.length,
      itemBuilder:
          (context, index) => _DomainCard(domain: domains[index]),
    );
  }
}

/// Single domain card in the navigator grid.
class _DomainCard extends StatelessWidget {
  const _DomainCard({required this.domain});

  final NavigatorDomain domain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = DomainColors.forDomain(domain.id);
    final icon = DomainColors.iconForDomain(domain.id);
    final domainLabel = _getDomainLabel(domain.id, l10n);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
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

              // Guide count
              Text(
                domain.guideCount == 1
                    ? l10n.navGuideCountOne
                    : l10n.navGuideCount(domain.guideCount),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              // Description
              if (domain.description != null &&
                  domain.description!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.spaceXs),
                Text(
                  domain.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
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
