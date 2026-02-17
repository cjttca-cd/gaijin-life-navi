import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';

/// Language option data.
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

/// Language selection screen (S02) — handoff-auth.md spec.
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    // Pre-select based on device locale if it matches.
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final match =
        _languages
            .where((l) => l.code == deviceLocale.languageCode)
            .firstOrNull;
    if (match != null) {
      _selectedCode = match.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.space4xl),
              // Logo — 48dp.
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.explore, size: 28, color: cs.onPrimary),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              // Title.
              Text(
                l10n.langTitle,
                style: tt.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space3xl),
              // Language list.
              ..._languages.map((lang) {
                final isSelected = _selectedCode == lang.code;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
                  child: _LanguageRow(
                    option: lang,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedCode = lang.code),
                  ),
                );
              }),
              const Spacer(),
              // Continue button.
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      _selectedCode != null
                          ? () {
                            ref
                                .read(localeProvider.notifier)
                                .setLocale(_selectedCode!);
                            context.go(AppRoutes.login);
                          }
                          : null,
                  child: Text(l10n.langContinue),
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _LanguageOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: isSelected ? cs.primaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceLg),
          child: Row(
            children: [
              Text(option.flag, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: AppSpacing.spaceLg),
              Text(
                option.nativeName,
                style: tt.titleMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Radio indicator.
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.outline,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child:
                    isSelected
                        ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.primary,
                            ),
                          ),
                        )
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
