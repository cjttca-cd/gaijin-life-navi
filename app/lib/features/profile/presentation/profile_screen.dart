import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/nationalities.dart';
import '../../../data/regions.dart';
import '../../../data/residence_statuses.dart';
import '../../tracker/domain/tracker_item.dart';
import '../../tracker/presentation/providers/tracker_providers.dart';
import '../domain/user_profile.dart';
import 'providers/profile_providers.dart';

/// Profile screen — inline BottomSheet editing per field.
///
/// No separate edit screen; each row taps to open a BottomSheet.
/// Changes are tracked locally and saved via AppBar save button.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Pending edits (not yet saved to server).
  final Map<String, dynamic> _pendingEdits = {};
  bool _isSaving = false;
  bool _isDeleting = false;

  bool get _hasChanges => _pendingEdits.isNotEmpty;

  // Get current effective value: pending edit > profile value.
  String? _effectiveValue(UserProfile profile, String field) {
    if (_pendingEdits.containsKey(field)) {
      return _pendingEdits[field] as String?;
    }
    switch (field) {
      case 'display_name':
        return profile.displayName.isNotEmpty ? profile.displayName : null;
      case 'nationality':
        return profile.nationality;
      case 'residence_status':
        return profile.residenceStatus;
      case 'visa_expiry':
        return profile.visaExpiry;
      case 'residence_region':
        return profile.residenceRegion;
      case 'preferred_language':
        return profile.preferredLanguage;
      default:
        return null;
    }
  }

  void _setEdit(String field, dynamic value) {
    setState(() {
      _pendingEdits[field] = value;
    });
  }

  Future<void> _save(UserProfile profile) async {
    if (!_hasChanges) return;

    setState(() => _isSaving = true);

    // Build only truly changed fields.
    final fields = <String, dynamic>{};
    for (final entry in _pendingEdits.entries) {
      fields[entry.key] = entry.value;
    }

    try {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateProfile(fields);
      ref.invalidate(userProfileProvider);

      // Handle language change.
      if (fields.containsKey('preferred_language') &&
          fields['preferred_language'] != null) {
        ref
            .read(localeProvider.notifier)
            .setLocale(fields['preferred_language'] as String);
      }

      // Handle visa_expiry → tracker auto-generation.
      if (fields.containsKey('visa_expiry') &&
          fields['visa_expiry'] != null) {
        await _generateVisaTrackerItems(fields['visa_expiry'] as String);
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileSaved)),
        );
      }

      setState(() {
        _pendingEdits.clear();
      });
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileSaveError)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _generateVisaTrackerItems(String visaExpiryStr) async {
    final expiry = DateTime.tryParse(visaExpiryStr);
    if (expiry == null) return;

    final l10n = AppLocalizations.of(context);
    final trackerNotifier = ref.read(trackerItemsProvider.notifier);

    // Remove existing visa renewal items.
    await trackerNotifier.removeByTag('visa_renewal');

    final threeMonthsBefore = DateTime(
      expiry.year,
      expiry.month - 3,
      expiry.day,
    );
    final oneMonthBefore = DateTime(
      expiry.year,
      expiry.month - 1,
      expiry.day,
    );

    // Add preparation item.
    await trackerNotifier.add(
      TrackerItem(
        id: TrackerItem.generateId(),
        title: l10n.visaRenewalPrepTitle,
        dueDate: threeMonthsBefore,
        tag: 'visa_renewal',
        completed: false,
        createdAt: DateTime.now(),
      ),
    );

    // Add deadline item.
    await trackerNotifier.add(
      TrackerItem(
        id: TrackerItem.generateId(),
        title: l10n.visaRenewalDeadlineTitle,
        dueDate: oneMonthBefore,
        tag: 'visa_renewal',
        completed: false,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsLogoutTitle),
        content: Text(l10n.settingsLogoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.settingsLogoutCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.settingsLogoutConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(firebaseAuthProvider).signOut();
      if (mounted) context.go(AppRoutes.login);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsErrorLogout)),
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsDeleteTitle),
        content: Text(l10n.settingsDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.settingsDeleteCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.settingsDeleteConfirmAction),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);
    try {
      final repo = ref.read(profileRepositoryProvider);
      await repo.deleteAccount();
      await ref.read(firebaseAuthProvider).signOut();
      if (mounted) context.go(AppRoutes.language);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsErrorDelete)),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving
                  ? null
                  : () {
                      final profile = profileAsync.valueOrNull;
                      if (profile != null) _save(profile);
                    },
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.profileSave),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => _buildSkeleton(context),
        error: (_, __) => _buildError(context, ref),
        data: (profile) => _buildBody(context, profile),
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserProfile profile) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(userProfileProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: AppSpacing.spaceLg),

          // ── Section 1: Profile ──
          _SectionLabel(label: l10n.accountSectionProfile),

          // Personalization hint.
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.spaceSm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🌐', style: TextStyle(fontSize: 20)),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Text(
                    l10n.profilePersonalizationHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.spaceSm),

          // Profile fields card.
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Card(
              child: Column(
                children: [
                  // Display name.
                  _ProfileRow(
                    label: l10n.profileDisplayName,
                    value: _effectiveValue(profile, 'display_name'),
                    notSetLabel: l10n.profileNotSet,
                    onTap: () => _showDisplayNameSheet(
                      context,
                      _effectiveValue(profile, 'display_name'),
                    ),
                  ),
                  _divider(theme),

                  // Nationality.
                  _ProfileRow(
                    label: l10n.profileNationality,
                    value: _nationalityDisplayName(
                      _effectiveValue(profile, 'nationality'),
                    ),
                    notSetLabel: l10n.profileNotSet,
                    onTap: () => _showNationalitySheet(
                      context,
                      _effectiveValue(profile, 'nationality'),
                    ),
                  ),
                  _divider(theme),

                  // Residence status.
                  _ProfileRow(
                    label: l10n.profileResidenceStatus,
                    value: _residenceStatusDisplayName(
                      _effectiveValue(profile, 'residence_status'),
                    ),
                    notSetLabel: l10n.profileNotSet,
                    onTap: () => _showResidenceStatusSheet(
                      context,
                      _effectiveValue(profile, 'residence_status'),
                    ),
                  ),
                  _divider(theme),

                  // Visa expiry.
                  _ProfileRow(
                    label: l10n.profileVisaExpiry,
                    value: _effectiveValue(profile, 'visa_expiry'),
                    notSetLabel: l10n.profileNotSet,
                    onTap: () => _showVisaExpirySheet(
                      context,
                      _effectiveValue(profile, 'visa_expiry'),
                    ),
                  ),
                  _divider(theme),

                  // Residence region.
                  _ProfileRow(
                    label: l10n.profileResidenceRegion,
                    value: _effectiveValue(profile, 'residence_region'),
                    notSetLabel: l10n.profileNotSet,
                    onTap: () => _showRegionSheet(
                      context,
                      _effectiveValue(profile, 'residence_region'),
                    ),
                  ),
                  _divider(theme),

                  // Preferred language.
                  _ProfileRow(
                    label: l10n.profilePreferredLanguage,
                    value: _languageLabel(
                      _effectiveValue(profile, 'preferred_language'),
                    ),
                    notSetLabel: l10n.profileNotSet,
                    onTap: () => _showLanguageSheet(
                      context,
                      _effectiveValue(profile, 'preferred_language'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.space2xl),

          // ── Section 2: Account Management ──
          _SectionLabel(label: l10n.accountSectionManagement),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Text('⭐', style: TextStyle(fontSize: 20)),
                    title: Text(
                      l10n.settingsSubscription,
                      style: theme.textTheme.titleSmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Free',
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
                    onTap: () => context.push(AppRoutes.subscription),
                  ),
                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant,
                    indent: 56,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      l10n.settingsLogout,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.space2xl),

          // ── Section 3: Danger Zone ──
          _SectionLabel(label: l10n.accountSectionDanger),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Card(
              child: ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  l10n.settingsDeleteAccount,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                enabled: !_isDeleting,
                onTap: _deleteAccount,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.space3xl),
        ],
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Divider(
      height: 1,
      color: theme.colorScheme.outlineVariant,
      indent: AppSpacing.screenPadding,
      endIndent: AppSpacing.screenPadding,
    );
  }

  // ── Bottom Sheets ──────────────────────────────────────

  void _showDisplayNameSheet(BuildContext context, String? current) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: current ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dragHandle(ctx),
                  const SizedBox(height: AppSpacing.spaceLg),
                  Text(
                    l10n.profileDisplayName,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    maxLength: 100,
                    decoration: InputDecoration(
                      hintText: l10n.editNameHint,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isNotEmpty) {
                          _setEdit('display_name', text);
                        }
                        Navigator.pop(ctx);
                      },
                      child: Text(l10n.settingsConfirm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showNationalitySheet(BuildContext context, String? currentCode) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (ctx, scrollController) {
            return _NationalitySearchSheet(
              currentCode: currentCode,
              scrollController: scrollController,
              title: l10n.profileSelectNationality,
              searchHint: l10n.profileSearchNationality,
              onSelected: (code) {
                _setEdit('nationality', code);
                Navigator.pop(ctx);
              },
            );
          },
        );
      },
    );
  }

  void _showResidenceStatusSheet(BuildContext context, String? currentId) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final common = residenceStatuses.where((s) => s.common).toList();
    final other = residenceStatuses.where((s) => !s.common).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (ctx, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  _dragHandle(ctx),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.spaceLg),
                    child: Text(
                      l10n.profileSelectResidenceStatus,
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // Common section.
                        _SectionLabel(label: l10n.profileCommonStatuses),
                        ...common.map((s) => ListTile(
                              title: Text(s.nameJa),
                              subtitle: Text(
                                s.nameEn,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: s.id == currentId
                                  ? Icon(
                                      Icons.check,
                                      color: theme.colorScheme.primary,
                                    )
                                  : null,
                              onTap: () {
                                _setEdit('residence_status', s.id);
                                Navigator.pop(ctx);
                              },
                            )),
                        // Other section.
                        _SectionLabel(label: l10n.profileOtherStatuses),
                        ...other.map((s) => ListTile(
                              title: Text(s.nameJa),
                              subtitle: Text(
                                s.nameEn,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: s.id == currentId
                                  ? Icon(
                                      Icons.check,
                                      color: theme.colorScheme.primary,
                                    )
                                  : null,
                              onTap: () {
                                _setEdit('residence_status', s.id);
                                Navigator.pop(ctx);
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showVisaExpirySheet(BuildContext context, String? currentStr) {
    DateTime initial = DateTime.now().add(const Duration(days: 365));
    if (currentStr != null) {
      final parsed = DateTime.tryParse(currentStr);
      if (parsed != null) initial = parsed;
    }

    showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    ).then((picked) {
      if (picked != null) {
        final formatted =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _setEdit('visa_expiry', formatted);
      }
    });
  }

  void _showRegionSheet(BuildContext context, String? currentRegion) {
    final l10n = AppLocalizations.of(context);

    // Step 1: Select prefecture.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (ctx, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  _dragHandle(ctx),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.spaceLg),
                    child: Text(
                      l10n.profileSelectPrefecture,
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: prefectures.length,
                      itemBuilder: (ctx, index) {
                        final pref = prefectures[index];
                        return ListTile(
                          title: Text(pref.nameJa),
                          subtitle: Text(pref.nameEn),
                          onTap: () {
                            Navigator.pop(ctx);
                            // Step 2: Select city within prefecture.
                            _showCitySheet(context, pref);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCitySheet(BuildContext context, Prefecture prefecture) {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (ctx, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  _dragHandle(ctx),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.spaceLg),
                    child: Text(
                      l10n.profileSelectCity,
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: prefecture.cities.length,
                      itemBuilder: (ctx, index) {
                        final city = prefecture.cities[index];
                        return ListTile(
                          title: Text(city.nameJa),
                          subtitle: Text(city.nameEn),
                          onTap: () {
                            final region =
                                '${prefecture.nameJa} ${city.nameJa}';
                            _setEdit('residence_region', region);
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageSheet(BuildContext context, String? currentLang) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dragHandle(ctx),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.spaceLg),
                child: Text(
                  l10n.profileSelectLanguage,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
              ),
              ...AppConfig.supportedLanguages.map((lang) {
                return ListTile(
                  title: Text(_languageLabel(lang) ?? lang),
                  trailing: lang == currentLang
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () {
                    _setEdit('preferred_language', lang);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.spaceLg),
            ],
          ),
        );
      },
    );
  }

  // ── Helpers ────────────────────────────────────────────

  Widget _dragHandle(BuildContext context) {
    return Container(
      width: 32,
      height: 4,
      margin: const EdgeInsets.only(top: AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  String? _nationalityDisplayName(String? code) {
    if (code == null) return null;
    try {
      final item = nationalities.firstWhere((n) => n.code == code);
      return item.name;
    } catch (_) {
      return code;
    }
  }

  String? _residenceStatusDisplayName(String? id) {
    if (id == null) return null;
    try {
      final item = residenceStatuses.firstWhere((s) => s.id == id);
      return item.nameJa;
    } catch (_) {
      return id;
    }
  }

  String? _languageLabel(String? code) {
    if (code == null) return null;
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

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.space2xl),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          ...List.generate(
            6,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
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
    );
  }
}

// ── Reusable Widgets ─────────────────────────────────────────

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.label,
    required this.value,
    required this.notSetLabel,
    required this.onTap,
  });

  final String label;
  final String? value;
  final String notSetLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSet = value != null && value!.isNotEmpty;

    return ListTile(
      title: Text(label, style: theme.textTheme.bodyMedium),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                isSet ? value! : notSetLabel,
                style: isSet
                    ? theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )
                    : theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.spaceXs),
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.spaceLg,
        AppSpacing.screenPadding,
        AppSpacing.spaceSm,
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Searchable nationality list for BottomSheet.
class _NationalitySearchSheet extends StatefulWidget {
  const _NationalitySearchSheet({
    required this.currentCode,
    required this.scrollController,
    required this.title,
    required this.searchHint,
    required this.onSelected,
  });

  final String? currentCode;
  final ScrollController scrollController;
  final String title;
  final String searchHint;
  final ValueChanged<String> onSelected;

  @override
  State<_NationalitySearchSheet> createState() =>
      _NationalitySearchSheetState();
}

class _NationalitySearchSheetState extends State<_NationalitySearchSheet> {
  String _query = '';

  List<NationalityItem> get _filtered {
    if (_query.isEmpty) return nationalities;
    final q = _query.toLowerCase();
    return nationalities
        .where((n) =>
            n.name.toLowerCase().contains(q) ||
            n.code.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        children: [
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
              widget.title,
              style: theme.textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: _filtered.length,
              itemBuilder: (ctx, index) {
                final item = _filtered[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.code),
                  trailing: item.code == widget.currentCode
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () => widget.onSelected(item.code),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
