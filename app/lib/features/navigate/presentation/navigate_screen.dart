import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';

/// Navigate hub screen — entry points to Banking, Visa, Scanner, Medical.
class NavigateScreen extends StatelessWidget {
  const NavigateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final items = [
      _NavigateItem(
        icon: Icons.account_balance,
        title: l10n.navigateBanking,
        subtitle: l10n.navigateBankingDesc,
        route: AppRoutes.banking,
        color: theme.colorScheme.primary,
      ),
      _NavigateItem(
        icon: Icons.assignment,
        title: l10n.navigateVisa,
        subtitle: l10n.navigateVisaDesc,
        route: AppRoutes.visa,
        color: theme.colorScheme.secondary,
      ),
      _NavigateItem(
        icon: Icons.document_scanner,
        title: l10n.navigateScanner,
        subtitle: l10n.navigateScannerDesc,
        route: AppRoutes.scanner,
        color: theme.colorScheme.tertiary,
      ),
      _NavigateItem(
        icon: Icons.medical_services,
        title: l10n.navigateMedical,
        subtitle: l10n.navigateMedicalDesc,
        route: AppRoutes.medical,
        color: theme.colorScheme.error,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabNavigate),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _NavigateCard(item: item);
          },
        ),
      ),
    );
  }
}

class _NavigateItem {
  const _NavigateItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;
}

class _NavigateCard extends StatelessWidget {
  const _NavigateCard({required this.item});

  final _NavigateItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(item.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  item.icon,
                  size: 32,
                  color: item.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
