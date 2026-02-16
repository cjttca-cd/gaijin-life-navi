import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../core/providers/router_provider.dart';

/// A reusable banner shown to free-tier users when they hit a limit.
///
/// Displays a message explaining the restriction and a button to navigate
/// to the subscription screen.
class UpgradeBanner extends StatelessWidget {
  const UpgradeBanner({
    super.key,
    required this.message,
    this.icon = Icons.lock_outline,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.tertiaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 40,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.subscription),
            icon: const Icon(Icons.star),
            label: Text(l10n.upgradeToPremium),
          ),
        ],
      ),
    );
  }
}

/// A compact inline upgrade button for lists and cards.
class UpgradeChip extends StatelessWidget {
  const UpgradeChip({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ActionChip(
      avatar: Icon(
        Icons.star,
        size: 16,
        color: theme.colorScheme.primary,
      ),
      label: Text(l10n.upgradeToPremium),
      onPressed: () => context.push(AppRoutes.subscription),
    );
  }
}
