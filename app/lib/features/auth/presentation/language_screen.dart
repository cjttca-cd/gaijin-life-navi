import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/router_provider.dart';

/// Language data for each supported language.
class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.nativeName,
    required this.flag,
  });

  final String code;
  final String nativeName;
  final String flag;
}

const _languages = [
  _LanguageOption(code: 'en', nativeName: 'English', flag: '🇺🇸'),
  _LanguageOption(code: 'zh', nativeName: '中文', flag: '🇨🇳'),
  _LanguageOption(code: 'vi', nativeName: 'Tiếng Việt', flag: '🇻🇳'),
  _LanguageOption(code: 'ko', nativeName: '한국어', flag: '🇰🇷'),
  _LanguageOption(code: 'pt', nativeName: 'Português', flag: '🇧🇷'),
];

/// Screen for selecting the app language (S02).
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String? _selectedCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                l10n.languageSelectionTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.languageSelectionSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ..._languages.map((lang) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _LanguageTile(
                      option: lang,
                      isSelected: _selectedCode == lang.code,
                      onTap: () {
                        setState(() => _selectedCode = lang.code);
                      },
                    ),
                  )),
              const Spacer(),
              ElevatedButton(
                onPressed: _selectedCode != null
                    ? () {
                        ref
                            .read(localeProvider.notifier)
                            .setLocale(_selectedCode!);
                        context.go(AppRoutes.login);
                      }
                    : null,
                child: Text(l10n.continueButton),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(
                option.flag,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 16),
              Text(
                option.nativeName,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
