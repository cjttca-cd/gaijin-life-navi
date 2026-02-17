import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/network/api_client.dart';
import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/onboarding_repository.dart';

// ─── Providers ───────────────────────────────────────────────

final _appClientProvider = Provider<Dio>((ref) => createApiClient());

final _onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(appClient: ref.watch(_appClientProvider));
});

// ─── Screen ──────────────────────────────────────────────────

/// Onboarding screen (S06) — 4 steps per handoff-auth.md.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  String? _nationality;
  String? _residenceStatus;
  String? _residenceRegion;
  DateTime? _arrivalDate;

  static const _totalSteps = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(_onboardingRepositoryProvider);
      await repo.submitOnboarding(
        nationality: _nationality,
        residenceStatus: _residenceStatus,
        residenceRegion: _residenceRegion,
        arrivalDate: _arrivalDate?.toIso8601String().split('T').first,
      );
      if (mounted) context.go(AppRoutes.home);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).onboardingErrorSave),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
        child: Column(
          children: [
            // Top bar — Skip + Back.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceSm,
                vertical: AppSpacing.spaceSm,
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: _previousStep,
                    )
                  else
                    const SizedBox(width: 48),
                  const Spacer(),
                  TextButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: Text(l10n.onboardingSkip),
                  ),
                ],
              ),
            ),

            // Step indicator dots.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space2xl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_totalSteps, (i) {
                  final isActive = i == _currentStep;
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? cs.primary : cs.outline,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              l10n.onboardingStepOf(_currentStep + 1, _totalSteps),
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.spaceLg),

            // Page view.
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _NationalityStep(
                    value: _nationality,
                    onChanged: (v) => setState(() => _nationality = v),
                  ),
                  _ResidenceStatusStep(
                    value: _residenceStatus,
                    onChanged: (v) => setState(() => _residenceStatus = v),
                  ),
                  _RegionStep(
                    value: _residenceRegion,
                    onChanged: (v) => setState(() => _residenceRegion = v),
                  ),
                  _ArrivalDateStep(
                    value: _arrivalDate,
                    onChanged: (v) => setState(() => _arrivalDate = v),
                  ),
                ],
              ),
            ),

            // Bottom button.
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space2xl),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _nextStep,
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            _currentStep < _totalSteps - 1
                                ? l10n.onboardingNext
                                : l10n.onboardingGetStarted,
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 1: Nationality ─────────────────────────────────────

class _NationalityStep extends StatelessWidget {
  const _NationalityStep({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  static const _nationalities = [
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
    'OTHER',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingS1Title, style: tt.headlineLarge),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            l10n.onboardingS1Subtitle,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space2xl),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _nationalities.map((code) {
                  final isSelected = value == code;
                  return ChoiceChip(
                    label: Text(_label(code, l10n)),
                    selected: isSelected,
                    onSelected: (s) => onChanged(s ? code : null),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  String _label(String code, AppLocalizations l10n) {
    return switch (code) {
      'CN' => l10n.countryCN,
      'VN' => l10n.countryVN,
      'KR' => l10n.countryKR,
      'PH' => l10n.countryPH,
      'BR' => l10n.countryBR,
      'NP' => l10n.countryNP,
      'ID' => l10n.countryID,
      'US' => l10n.countryUS,
      'TH' => l10n.countryTH,
      'IN' => l10n.countryIN,
      'MM' => l10n.countryMM,
      'TW' => l10n.countryTW,
      'PE' => l10n.countryPE,
      'GB' => l10n.countryGB,
      'PK' => l10n.countryPK,
      'BD' => l10n.countryBD,
      'LK' => l10n.countryLK,
      'FR' => l10n.countryFR,
      'DE' => l10n.countryDE,
      _ => l10n.countryOther,
    };
  }
}

// ─── Step 2: Residence Status ────────────────────────────────

class _ResidenceStatusStep extends StatelessWidget {
  const _ResidenceStatusStep({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  static const _statuses = [
    'engineer_specialist',
    'student',
    'dependent',
    'permanent_resident',
    'spouse_of_japanese',
    'working_holiday',
    'specified_skilled_worker',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingS2Title, style: tt.headlineLarge),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            l10n.onboardingS2Subtitle,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space2xl),
          ..._statuses.map((status) {
            final isSelected = value == status;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spaceSm),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? cs.primary : cs.outlineVariant,
                  ),
                ),
                tileColor:
                    isSelected ? cs.primaryContainer : Colors.transparent,
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                ),
                title: Text(_label(status, l10n)),
                onTap: () => onChanged(isSelected ? null : status),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _label(String s, AppLocalizations l10n) {
    return switch (s) {
      'engineer_specialist' => l10n.statusEngineer,
      'student' => l10n.statusStudent,
      'dependent' => l10n.statusDependent,
      'permanent_resident' => l10n.statusPermanent,
      'spouse_of_japanese' => l10n.statusSpouse,
      'working_holiday' => l10n.statusWorkingHoliday,
      'specified_skilled_worker' => l10n.statusSpecifiedSkilled,
      _ => l10n.statusOther,
    };
  }
}

// ─── Step 3: Region ──────────────────────────────────────────

class _RegionStep extends StatelessWidget {
  const _RegionStep({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  static const _regions = [
    'tokyo',
    'osaka',
    'nagoya',
    'yokohama',
    'fukuoka',
    'sapporo',
    'kobe',
    'kyoto',
    'sendai',
    'hiroshima',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingS3Title, style: tt.headlineLarge),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            l10n.onboardingS3Subtitle,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space2xl),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _regions.map((r) {
                  final isSelected = value == r;
                  return ChoiceChip(
                    label: Text(_label(r, l10n)),
                    selected: isSelected,
                    onSelected: (s) => onChanged(s ? r : null),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  String _label(String r, AppLocalizations l10n) {
    return switch (r) {
      'tokyo' => l10n.regionTokyo,
      'osaka' => l10n.regionOsaka,
      'nagoya' => l10n.regionNagoya,
      'yokohama' => l10n.regionYokohama,
      'fukuoka' => l10n.regionFukuoka,
      'sapporo' => l10n.regionSapporo,
      'kobe' => l10n.regionKobe,
      'kyoto' => l10n.regionKyoto,
      'sendai' => l10n.regionSendai,
      'hiroshima' => l10n.regionHiroshima,
      _ => l10n.regionOther,
    };
  }
}

// ─── Step 4: Arrival Date ────────────────────────────────────

class _ArrivalDateStep extends StatelessWidget {
  const _ArrivalDateStep({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboardingS4Title, style: tt.headlineLarge),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            l10n.onboardingS4Subtitle,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.space3xl),
          Center(
            child: Column(
              children: [
                Icon(Icons.calendar_today, size: 48, color: cs.primary),
                const SizedBox(height: AppSpacing.spaceLg),
                if (value != null)
                  Text(
                    '${value!.year}/${value!.month.toString().padLeft(2, '0')}/${value!.day.toString().padLeft(2, '0')}',
                    style: tt.headlineMedium,
                  ),
                const SizedBox(height: AppSpacing.spaceLg),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_calendar),
                  label: Text(
                    value == null
                        ? l10n.onboardingS4Placeholder
                        : l10n.onboardingChangeDate,
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: value ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) onChanged(picked);
                  },
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                TextButton(
                  onPressed: () => onChanged(null),
                  child: Text(l10n.onboardingS4NotYet),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
