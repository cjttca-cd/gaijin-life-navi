import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_spacing.dart';
import 'providers/profile_providers.dart';

/// S14: Profile Edit — per handoff-profile.md.
///
/// Editable fields: Display Name, Nationality, Residence Status,
/// Region, Preferred Language. Save button in AppBar.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  String? _nationality;
  String? _residenceStatus;
  String? _region;
  String _preferredLanguage = 'en';
  bool _isLoading = false;
  bool _initialized = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _displayNameController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  void _initFromProfile() {
    final profileAsync = ref.read(userProfileProvider);
    final profile = profileAsync.valueOrNull;
    if (profile != null && !_initialized) {
      _displayNameController.text = profile.displayName;
      _nationality = profile.nationality;
      _residenceStatus = profile.residenceStatus;
      _region = profile.residenceRegion;
      _preferredLanguage = profile.preferredLanguage;
      _initialized = true;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final profile = ref.read(userProfileProvider).valueOrNull;
    final fields = <String, dynamic>{};

    if (_displayNameController.text != (profile?.displayName ?? '')) {
      fields['display_name'] = _displayNameController.text;
    }
    if (_nationality != profile?.nationality) {
      fields['nationality'] = _nationality;
    }
    if (_residenceStatus != profile?.residenceStatus) {
      fields['residence_status'] = _residenceStatus;
    }
    if (_region != profile?.residenceRegion) {
      fields['residence_region'] = _region;
    }
    if (_preferredLanguage != (profile?.preferredLanguage ?? 'en')) {
      fields['preferred_language'] = _preferredLanguage;
    }

    if (fields.isEmpty) {
      setState(() => _isLoading = false);
      if (mounted) context.pop();
      return;
    }

    try {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateProfile(fields);
      ref.invalidate(userProfileProvider);

      if (fields.containsKey('preferred_language')) {
        ref.read(localeProvider.notifier).setLocale(_preferredLanguage);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).editSuccess)),
        );
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).editError)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(l10n.editUnsavedTitle),
            content: Text(l10n.editUnsavedMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.editUnsavedKeep),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.editUnsavedDiscard),
              ),
            ],
          ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    _initFromProfile();

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.editTitle),
          actions: [
            TextButton(
              onPressed: _hasChanges && !_isLoading ? _save : null,
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(l10n.editSave),
            ),
          ],
        ),
        body: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(child: Text(l10n.profileLoadError)),
          data:
              (_) => Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    children: [
                      // Avatar (view only for now)
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          _displayNameController.text.isNotEmpty
                              ? _displayNameController.text[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceXs),
                      Text(
                        l10n.editChangePhoto,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2xl),

                      // Display Name
                      TextFormField(
                        controller: _displayNameController,
                        decoration: InputDecoration(
                          labelText: l10n.editNameLabel,
                          hintText: l10n.editNameHint,
                        ),
                        maxLength: 100,
                      ),
                      const SizedBox(height: AppSpacing.spaceMd),

                      // Nationality
                      DropdownButtonFormField<String>(
                        initialValue: _nationality,
                        decoration: InputDecoration(
                          labelText: l10n.editNationalityLabel,
                          hintText: l10n.editNationalityHint,
                        ),
                        items:
                            _nationalityOptions
                                .map(
                                  (n) => DropdownMenuItem(
                                    value: n,
                                    child: Text(n),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) {
                          setState(() {
                            _nationality = v;
                            _hasChanges = true;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.spaceMd),

                      // Residence Status
                      DropdownButtonFormField<String>(
                        initialValue: _residenceStatus,
                        decoration: InputDecoration(
                          labelText: l10n.editStatusLabel,
                          hintText: l10n.editStatusHint,
                        ),
                        items:
                            _residenceStatusOptions
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) {
                          setState(() {
                            _residenceStatus = v;
                            _hasChanges = true;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.spaceMd),

                      // Region
                      DropdownButtonFormField<String>(
                        initialValue: _region,
                        decoration: InputDecoration(
                          labelText: l10n.editRegionLabel,
                          hintText: l10n.editRegionHint,
                        ),
                        items:
                            _regionOptions
                                .map(
                                  (r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) {
                          setState(() {
                            _region = v;
                            _hasChanges = true;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.spaceMd),

                      // Preferred Language
                      DropdownButtonFormField<String>(
                        initialValue: _preferredLanguage,
                        decoration: InputDecoration(
                          labelText: l10n.editLanguageLabel,
                        ),
                        items:
                            AppConfig.supportedLanguages
                                .map(
                                  (lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(_languageLabel(lang)),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _preferredLanguage = v;
                              _hasChanges = true;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.space3xl),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  static const _nationalityOptions = [
    'CN',
    'VN',
    'KR',
    'PH',
    'BR',
    'NP',
    'ID',
    'US',
    'TH',
    'IN',
    'MM',
    'TW',
    'PE',
    'GB',
    'PK',
    'BD',
    'LK',
    'FR',
    'DE',
  ];

  static const _residenceStatusOptions = [
    'engineer_specialist',
    'humanities_international',
    'student',
    'dependent',
    'permanent_resident',
    'spouse_of_japanese',
    'long_term_resident',
    'working_holiday',
    'specified_skilled',
    'other',
  ];

  static const _regionOptions = [
    'Tokyo',
    'Osaka',
    'Nagoya',
    'Yokohama',
    'Fukuoka',
    'Sapporo',
    'Kobe',
    'Kyoto',
    'Sendai',
    'Hiroshima',
  ];

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
