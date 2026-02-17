import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers/locale_provider.dart';
import 'providers/profile_providers.dart';

/// Profile edit screen — allows editing profile fields.
/// Route: /profile/edit
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _nationalityController;
  late TextEditingController _residenceRegionController;
  late TextEditingController _arrivalDateController;
  String? _residenceStatus;
  String _preferredLanguage = 'en';
  bool _isLoading = false;
  bool _initialized = false;

  static const List<String> _residenceStatusOptions = [
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

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _nationalityController = TextEditingController();
    _residenceRegionController = TextEditingController();
    _arrivalDateController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _nationalityController.dispose();
    _residenceRegionController.dispose();
    _arrivalDateController.dispose();
    super.dispose();
  }

  void _initFromProfile() {
    final profileAsync = ref.read(userProfileProvider);
    final profile = profileAsync.valueOrNull;
    if (profile != null && !_initialized) {
      _displayNameController.text = profile.displayName;
      _nationalityController.text = profile.nationality ?? '';
      _residenceRegionController.text = profile.residenceRegion ?? '';
      _arrivalDateController.text = profile.arrivalDate ?? '';
      _residenceStatus = profile.residenceStatus;
      _preferredLanguage = profile.preferredLanguage;
      _initialized = true;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final fields = <String, dynamic>{};
    final profile = ref.read(userProfileProvider).valueOrNull;

    if (_displayNameController.text != (profile?.displayName ?? '')) {
      fields['display_name'] = _displayNameController.text;
    }
    if (_nationalityController.text != (profile?.nationality ?? '')) {
      fields['nationality'] =
          _nationalityController.text.isEmpty
              ? null
              : _nationalityController.text;
    }
    if (_residenceStatus != profile?.residenceStatus) {
      fields['residence_status'] = _residenceStatus;
    }
    if (_residenceRegionController.text != (profile?.residenceRegion ?? '')) {
      fields['residence_region'] =
          _residenceRegionController.text.isEmpty
              ? null
              : _residenceRegionController.text;
    }
    if (_arrivalDateController.text != (profile?.arrivalDate ?? '')) {
      fields['arrival_date'] =
          _arrivalDateController.text.isEmpty
              ? null
              : _arrivalDateController.text;
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

      // If language changed, update locale
      if (fields.containsKey('preferred_language')) {
        ref.read(localeProvider.notifier).setLocale(_preferredLanguage);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).profileSaved)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).profileSaveError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickArrivalDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(_arrivalDateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _arrivalDateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    // Initialize form fields from profile data
    _initFromProfile();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileEditTitle)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.profileLoadError)),
        data:
            (_) => Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _displayNameController,
                    decoration: InputDecoration(
                      labelText: l10n.profileDisplayName,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    maxLength: 100,
                    validator: (v) {
                      if (v != null && v.length > 100) {
                        return l10n.profileNameTooLong;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nationalityController,
                    decoration: InputDecoration(
                      labelText: l10n.profileNationality,
                      prefixIcon: const Icon(Icons.public),
                      hintText: 'US, CN, VN, KR, BR...',
                    ),
                    maxLength: 2,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _residenceStatus,
                    decoration: InputDecoration(
                      labelText: l10n.profileResidenceStatus,
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                    items:
                        _residenceStatusOptions.map((s) {
                          return DropdownMenuItem(value: s, child: Text(s));
                        }).toList(),
                    onChanged: (v) => setState(() => _residenceStatus = v),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _residenceRegionController,
                    decoration: InputDecoration(
                      labelText: l10n.profileRegion,
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      hintText: '13 (Tokyo), 27 (Osaka)...',
                    ),
                    maxLength: 10,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _arrivalDateController,
                    decoration: InputDecoration(
                      labelText: l10n.profileArrivalDate,
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      hintText: 'YYYY-MM-DD',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: _pickArrivalDate,
                      ),
                    ),
                    readOnly: true,
                    onTap: _pickArrivalDate,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _preferredLanguage,
                    decoration: InputDecoration(
                      labelText: l10n.profileLanguage,
                      prefixIcon: const Icon(Icons.language),
                    ),
                    items:
                        AppConfig.supportedLanguages.map((lang) {
                          return DropdownMenuItem(
                            value: lang,
                            child: Text(_languageLabel(lang)),
                          );
                        }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _preferredLanguage = v);
                    },
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _isLoading ? null : _save,
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(l10n.profileSaveButton),
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
