import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import 'providers/profile_providers.dart';

/// Settings screen — language change, logout, account deletion.
/// Route: /settings
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDeleting = false;

  Future<void> _changeLanguage(String langCode) async {
    // Update locale immediately
    ref.read(localeProvider.notifier).setLocale(langCode);

    // Save to server
    try {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateProfile({'preferred_language': langCode});
      ref.invalidate(userProfileProvider);
    } catch (_) {
      // Language was already changed locally; server save is best-effort
    }
  }

  Future<void> _logout() async {
    final confirmed = await _showConfirmDialog(
      title: AppLocalizations.of(context).settingsLogoutConfirmTitle,
      message: AppLocalizations.of(context).settingsLogoutConfirmMessage,
    );
    if (confirmed != true) return;

    await ref.read(firebaseAuthProvider).signOut();
    if (mounted) context.go('/login');
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await _showConfirmDialog(
      title: l10n.settingsDeleteConfirmTitle,
      message: l10n.settingsDeleteConfirmMessage,
      isDestructive: true,
    );
    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    try {
      final repo = ref.read(profileRepositoryProvider);
      await repo.deleteAccount();
      await ref.read(firebaseAuthProvider).signOut();
      if (mounted) context.go('/login');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.settingsDeleteError)));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(AppLocalizations.of(context).settingsCancel),
              ),
              TextButton(
                style:
                    isDestructive
                        ? TextButton.styleFrom(
                          foregroundColor: Theme.of(ctx).colorScheme.error,
                        )
                        : null,
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  isDestructive
                      ? AppLocalizations.of(context).settingsDelete
                      : AppLocalizations.of(context).settingsConfirm,
                ),
              ),
            ],
          ),
    );
  }

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
          // Language section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.settingsLanguageSection,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ...AppConfig.supportedLanguages.map((lang) {
            final isSelected = lang == currentLang;
            return ListTile(
              leading: const Icon(Icons.language),
              title: Text(_languageLabel(lang)),
              trailing:
                  isSelected
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
              selected: isSelected,
              onTap: () => _changeLanguage(lang),
            );
          }),
          const Divider(),

          // Account section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.settingsAccountSection,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.settingsLogout),
            onTap: _logout,
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
            title: Text(
              l10n.settingsDeleteAccount,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            subtitle: Text(l10n.settingsDeleteAccountSubtitle),
            enabled: !_isDeleting,
            onTap: _deleteAccount,
          ),
          if (_isDeleting)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),

          const Divider(),

          // About section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.settingsAboutSection,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsVersion),
            subtitle: const Text('0.1.0'),
          ),
        ],
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
