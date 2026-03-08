import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/router_provider.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:intl/intl.dart';
import '../../../../data/nationalities.dart';
import '../../../../data/regions.dart';
import '../../../../data/residence_statuses.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

/// BottomSheet dialog for TestFlight trial profile setup.
///
/// Collects nationality, residence status, and residence region from
/// anonymous users before they can access AI Chat.
/// Users can dismiss this dialog to browse without chat access.
class TrialSetupDialog extends ConsumerStatefulWidget {
  const TrialSetupDialog({super.key, this.signInFirst = false});

  final bool signInFirst;

  /// Show the trial setup dialog as a non-dismissible bottom sheet.
  static Future<bool> show(BuildContext context, {bool signInFirst = false}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (_) => TrialSetupDialog(signInFirst: signInFirst),
    );
    return result ?? false;
  }

  @override
  ConsumerState<TrialSetupDialog> createState() => _TrialSetupDialogState();
}

class _TrialSetupDialogState extends ConsumerState<TrialSetupDialog> {
  String? _selectedNationality;
  String? _selectedResidenceStatus;
  Prefecture? _selectedPrefecture;
  City? _selectedCity;
  DateTime? _selectedVisaExpiry;
  bool _isSubmitting = false;

  bool get _canSubmit =>
      _selectedNationality != null &&
      _selectedResidenceStatus != null &&
      _selectedPrefecture != null &&
      _selectedCity != null &&
      !_isSubmitting;

  Future<void> _submit() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);

    final locale = Localizations.localeOf(context).languageCode;

    try {
      // Sign in anonymously first if needed (guest flow)
      if (widget.signInFirst) {
        final auth = ref.read(firebaseAuthProvider);
        final user = await signInAnonymously(auth);
        if (user == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).signInFailed)),
            );
          }
          return;
        }
      }

      final repo = ref.read(profileRepositoryProvider);
      await repo.trialSetup(
        nationality: _selectedNationality!,
        residenceStatus: _selectedResidenceStatus!,
        residenceRegion: '${_selectedPrefecture!.nameEn} ${_selectedCity!.nameEn}',
        visaExpiry: _selectedVisaExpiry?.toIso8601String().split('T').first,
        preferredLanguage: locale,
      );
      // Invalidate profile cache so it picks up the new data.
      ref.invalidate(userProfileProvider);
      // Mark trial setup done in SharedPreferences (for returning-user auto-login)
      await markTrialSetupComplete();
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Setup failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: AppSpacing.screenPadding,
          right: AppSpacing.screenPadding,
          top: AppSpacing.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle (visual only — not draggable).
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),

            // Title.
            Text(
              l10n.trialSetupTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            // Subtitle.
            Text(
              l10n.trialSetupSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space2xl),

            // Nationality selector.
            _SelectorTile(
              label: l10n.trialSetupNationality,
              value: _nationalityLabel(_selectedNationality),
              onTap: () => _showNationalityPicker(context),
            ),
            const SizedBox(height: AppSpacing.spaceMd),

            // Residence status selector.
            _SelectorTile(
              label: l10n.trialSetupResidenceStatus,
              value: _residenceStatusLabel(_selectedResidenceStatus),
              onTap: () => _showResidenceStatusPicker(context),
            ),
            const SizedBox(height: AppSpacing.spaceMd),

            // Region selector.
            _SelectorTile(
              label: l10n.trialSetupRegion,
              value: _regionLabel(),
              onTap: () => _showRegionPicker(context),
            ),
            const SizedBox(height: AppSpacing.spaceMd),

            // Visa expiry selector (optional).
            _SelectorTile(
              label: l10n.profileVisaExpiry,
              value: _selectedVisaExpiry != null
                  ? DateFormat.yMd().format(_selectedVisaExpiry!)
                  : null,
              onTap: () => _showVisaExpiryPicker(context),
            ),
            const SizedBox(height: AppSpacing.space2xl),

            // Submit button.
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: _canSubmit ? _submit : null,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.trialSetupSubmit),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
          ],
        ),
      ),
    );
  }

  // ── Pickers ──────────────────────────────────────────────

  void _showVisaExpiryPicker(BuildContext context) {
    final now = DateTime.now();
    final initial = _selectedVisaExpiry ?? now.add(const Duration(days: 365));

    showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 10)),
    ).then((picked) {
      if (picked != null) {
        setState(() => _selectedVisaExpiry = picked);
      }
    });
  }

  void _showNationalityPicker(BuildContext context) {
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
            return _NationalitySearchPicker(
              currentCode: _selectedNationality,
              scrollController: scrollController,
              title: l10n.trialSetupNationality,
              onSelected: (code) {
                setState(() => _selectedNationality = code);
                Navigator.pop(ctx);
              },
            );
          },
        );
      },
    );
  }

  void _showResidenceStatusPicker(BuildContext context) {
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
                      l10n.trialSetupResidenceStatus,
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        ...common.map((s) => ListTile(
                              title: Text(s.nameJa),
                              subtitle: Text(s.nameEn),
                              trailing: s.id == _selectedResidenceStatus
                                  ? Icon(Icons.check,
                                      color: theme.colorScheme.primary)
                                  : null,
                              onTap: () {
                                setState(
                                    () => _selectedResidenceStatus = s.id);
                                Navigator.pop(ctx);
                              },
                            )),
                        const Divider(),
                        ...other.map((s) => ListTile(
                              title: Text(s.nameJa),
                              subtitle: Text(s.nameEn),
                              trailing: s.id == _selectedResidenceStatus
                                  ? Icon(Icons.check,
                                      color: theme.colorScheme.primary)
                                  : null,
                              onTap: () {
                                setState(
                                    () => _selectedResidenceStatus = s.id);
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

  void _showRegionPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Step 1: Select prefecture
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
                      l10n.trialSetupRegion,
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
                            _showCityPicker(context, pref);
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

  // Step 2: Select city within prefecture
  void _showCityPicker(BuildContext context, Prefecture prefecture) {
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
                      '${prefecture.nameJa} (${prefecture.nameEn})',
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
                            setState(() {
                              _selectedPrefecture = prefecture;
                              _selectedCity = city;
                            });
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

  // ── Helpers ──────────────────────────────────────────────

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

  String? _nationalityLabel(String? code) {
    if (code == null) return null;
    try {
      return nationalities.firstWhere((n) => n.code == code).name;
    } catch (_) {
      return code;
    }
  }

  String? _residenceStatusLabel(String? id) {
    if (id == null) return null;
    try {
      final item = residenceStatuses.firstWhere((s) => s.id == id);
      return '${item.nameJa} (${item.nameEn})';
    } catch (_) {
      return id;
    }
  }

  String? _regionLabel() {
    if (_selectedPrefecture == null || _selectedCity == null) return null;
    return '${_selectedCity!.nameJa}, ${_selectedPrefecture!.nameJa}';
  }
}

/// A single selector row with label and current value.
class _SelectorTile extends StatelessWidget {
  const _SelectorTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceLg,
          vertical: AppSpacing.spaceMd,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(height: 2),
                    Text(value!, style: theme.textTheme.bodyLarge),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

/// Searchable nationality picker.
class _NationalitySearchPicker extends StatefulWidget {
  const _NationalitySearchPicker({
    required this.currentCode,
    required this.scrollController,
    required this.title,
    required this.onSelected,
  });

  final String? currentCode;
  final ScrollController scrollController;
  final String title;
  final ValueChanged<String> onSelected;

  @override
  State<_NationalitySearchPicker> createState() =>
      _NationalitySearchPickerState();
}

class _NationalitySearchPickerState extends State<_NationalitySearchPicker> {
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
            child: Text(widget.title, style: theme.textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
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
