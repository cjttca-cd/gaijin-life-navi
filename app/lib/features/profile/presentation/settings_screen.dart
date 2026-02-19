import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_spacing.dart';
import 'notification_settings_screen.dart';
import 'providers/profile_providers.dart';

/// S15: Settings — per handoff-profile.md.
///
/// General (Language, Notifications), Account (Subscription, Log Out),
/// Danger Zone (Delete Account), About (Version, Terms, Privacy, Contact).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currentLocale = ref.watch(localeProvider);
    final currentLang = currentLocale?.languageCode ?? 'en';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          const SizedBox(height: AppSpacing.spaceLg),

          // ── GENERAL ──
          _SectionHeader(title: l10n.settingsSectionGeneral),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      l10n.settingsLanguage,
                      style: theme.textTheme.titleSmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _languageLabel(currentLang),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spaceXs),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    onTap: () => _showLanguageSheet(context, currentLang),
                  ),
                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant,
                    indent: 56,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      l10n.settingsNotifications,
                      style: theme.textTheme.titleSmall,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              const NotificationSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.space2xl),

          // ── ABOUT ──
          _SectionHeader(title: l10n.settingsSectionAbout),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      l10n.settingsVersion,
                      style: theme.textTheme.titleSmall,
                    ),
                    trailing: Text(
                      '1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant,
                    indent: 56,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.description_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      l10n.settingsTerms,
                      style: theme.textTheme.titleSmall,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => _openUrl('https://gaijinlifenavi.com/terms'),
                  ),
                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant,
                    indent: 56,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      l10n.settingsPrivacy,
                      style: theme.textTheme.titleSmall,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => _openUrl('https://gaijinlifenavi.com/privacy'),
                  ),
                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant,
                    indent: 56,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      l10n.settingsContact,
                      style: theme.textTheme.titleSmall,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => _openUrl('mailto:support@gaijinlifenavi.com'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.space2xl),

          // Footer
          Center(
            child: Text(
              l10n.settingsFooter,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.space3xl),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, String currentLang) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 32,
                  height: 4,
                  margin: const EdgeInsets.only(top: AppSpacing.spaceSm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.spaceLg),
                  child: Text(
                    l10n.settingsLanguageTitle,
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                ...AppConfig.supportedLanguages.map((lang) {
                  return ListTile(
                    title: Text(_languageLabel(lang)),
                    trailing:
                        lang == currentLang
                            ? Icon(
                              Icons.check,
                              color: theme.colorScheme.primary,
                            )
                            : null,
                    onTap: () {
                      _changeLanguage(lang);
                      Navigator.pop(ctx);
                    },
                  );
                }),
                const SizedBox(height: AppSpacing.spaceLg),
              ],
            ),
          ),
    );
  }

  Future<void> _changeLanguage(String langCode) async {
    ref.read(localeProvider.notifier).setLocale(langCode);
    try {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateProfile({'preferred_language': langCode});
      ref.invalidate(userProfileProvider);
    } catch (_) {
      // Language changed locally; server save is best-effort
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        AppSpacing.spaceSm,
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
