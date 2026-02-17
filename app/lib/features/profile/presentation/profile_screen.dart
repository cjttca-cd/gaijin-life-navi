import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';
import 'providers/profile_providers.dart';

/// S13: Profile (View Only) — per handoff-profile.md.
///
/// Shows avatar + name + email + tier badge, your information,
/// usage statistics, and manage subscription link.
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
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => _buildSkeleton(context),
        error:
            (_, __) => Center(
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
                    l10n.profileLoadError,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  TextButton(
                    onPressed: () => ref.invalidate(userProfileProvider),
                    child: Text(l10n.navErrorRetry),
                  ),
                ],
              ),
            ),
        data: (profile) {
          final initials = _getInitials(profile.displayName, profile.email);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userProfileProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.spaceLg,
              ),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      initials,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),

                  // Name
                  Text(
                    profile.displayName.isNotEmpty
                        ? profile.displayName
                        : l10n.profileNoName,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.spaceXs),

                  // Email
                  Text(
                    profile.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),

                  // Tier badge
                  _TierBadge(tier: profile.subscriptionTier),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Edit Profile row
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.edit_outlined,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      title: Text(
                        l10n.profileEdit,
                        style: theme.textTheme.titleSmall,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onTap: () => context.push(AppRoutes.profileEdit),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.space2xl),

                  // Your Information section
                  _SectionHeader(title: l10n.profileSectionInfo),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.spaceSm,
                      ),
                      child: Column(
                        children: [
                          _InfoRow(
                            label: l10n.profileNationality,
                            value: profile.nationality ?? l10n.profileNotSet,
                            isNotSet: profile.nationality == null,
                          ),
                          Divider(
                            color: theme.colorScheme.outlineVariant,
                            indent: AppSpacing.screenPadding,
                            endIndent: AppSpacing.screenPadding,
                          ),
                          _InfoRow(
                            label: l10n.profileResidenceStatus,
                            value:
                                profile.residenceStatus ?? l10n.profileNotSet,
                            isNotSet: profile.residenceStatus == null,
                          ),
                          Divider(
                            color: theme.colorScheme.outlineVariant,
                            indent: AppSpacing.screenPadding,
                            endIndent: AppSpacing.screenPadding,
                          ),
                          _InfoRow(
                            label: l10n.profileRegion,
                            value:
                                profile.residenceRegion ?? l10n.profileNotSet,
                            isNotSet: profile.residenceRegion == null,
                          ),
                          Divider(
                            color: theme.colorScheme.outlineVariant,
                            indent: AppSpacing.screenPadding,
                            endIndent: AppSpacing.screenPadding,
                          ),
                          _InfoRow(
                            label: l10n.profileArrivalDate,
                            value: profile.arrivalDate ?? l10n.profileNotSet,
                            isNotSet: profile.arrivalDate == null,
                          ),
                          Divider(
                            color: theme.colorScheme.outlineVariant,
                            indent: AppSpacing.screenPadding,
                            endIndent: AppSpacing.screenPadding,
                          ),
                          _InfoRow(
                            label: l10n.profileLanguage,
                            value: _languageLabel(profile.preferredLanguage),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.space2xl),

                  // Usage Statistics section
                  _SectionHeader(title: l10n.profileSectionStats),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.spaceSm,
                      ),
                      child: Column(
                        children: [
                          _InfoRow(
                            label: l10n.profileMemberSince,
                            value:
                                '${profile.createdAt.year}-${profile.createdAt.month.toString().padLeft(2, '0')}',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Manage Subscription
                  Card(
                    child: ListTile(
                      leading: const Text('⭐', style: TextStyle(fontSize: 20)),
                      title: Text(
                        l10n.profileManageSubscription,
                        style: theme.textTheme.titleSmall,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onTap: () => context.push(AppRoutes.subscription),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.space3xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.spaceLg),
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Container(
            width: 120,
            height: 20,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Container(
            width: 160,
            height: 12,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name, String email) {
    if (name.isNotEmpty) {
      final words = name.trim().split(RegExp(r'\s+'));
      if (words.length >= 2) {
        return '${words[0][0]}${words[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return '?';
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isNotSet = false,
  });

  final String label;
  final String value;
  final bool isNotSet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.spaceSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style:
                isNotSet
                    ? theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    )
                    : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier});

  final String tier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bgColor;
    Color textColor;
    String icon;
    String label;

    switch (tier) {
      case 'standard':
        bgColor = theme.colorScheme.tertiaryContainer;
        textColor = theme.colorScheme.onTertiaryContainer;
        icon = '⭐';
        label = 'Standard';
        break;
      case 'premium':
        bgColor = theme.colorScheme.tertiaryContainer;
        textColor = theme.colorScheme.onTertiaryContainer;
        icon = '💎';
        label = 'Premium';
        break;
      default:
        bgColor = theme.colorScheme.surfaceContainerHighest;
        textColor = theme.colorScheme.onSurfaceVariant;
        icon = '';
        label = 'Free';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon.isNotEmpty) ...[
            Text(icon, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: AppSpacing.spaceXs),
          ],
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
