import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import 'providers/profile_providers.dart';

/// Profile screen — displays user information.
/// Route: /profile
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            l10n.profileLoadError,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar + name header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: profile.avatarUrl != null
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child: profile.avatarUrl == null
                          ? Text(
                              profile.displayName.isNotEmpty
                                  ? profile.displayName[0].toUpperCase()
                                  : '?',
                              style: theme.textTheme.headlineMedium,
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.displayName.isNotEmpty
                          ? profile.displayName
                          : l10n.profileNoName,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: profile.subscriptionTier == 'free'
                            ? theme.colorScheme.surfaceContainerHighest
                            : theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        profile.tierLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: profile.subscriptionTier == 'free'
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Info cards
              _InfoTile(
                icon: Icons.email_outlined,
                label: l10n.profileEmail,
                value: profile.email,
              ),
              _InfoTile(
                icon: Icons.public,
                label: l10n.profileNationality,
                value: profile.nationality ?? '-',
              ),
              _InfoTile(
                icon: Icons.badge_outlined,
                label: l10n.profileResidenceStatus,
                value: profile.residenceStatus ?? '-',
              ),
              _InfoTile(
                icon: Icons.location_on_outlined,
                label: l10n.profileRegion,
                value: profile.residenceRegion ?? '-',
              ),
              _InfoTile(
                icon: Icons.language,
                label: l10n.profileLanguage,
                value: _languageLabel(profile.preferredLanguage),
              ),
              _InfoTile(
                icon: Icons.calendar_today_outlined,
                label: l10n.profileArrivalDate,
                value: profile.arrivalDate ?? '-',
              ),
              const SizedBox(height: 24),
              // Edit button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.profileEdit),
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.profileEdit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _languageLabel(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      case 'vi':
        return 'Tiếng Việt';
      case 'ko':
        return '한국어';
      case 'pt':
        return 'Português';
      default:
        return code;
    }
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
