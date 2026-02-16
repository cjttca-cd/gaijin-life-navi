import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/network/api_client.dart';
import '../../../core/providers/router_provider.dart';
import '../data/onboarding_repository.dart';

// ─── Providers ───────────────────────────────────────────────

final _appClientProvider = Provider<Dio>((ref) {
  return createApiClient();
});

final _onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(appClient: ref.watch(_appClientProvider));
});

// ─── Screen ──────────────────────────────────────────────────

/// Onboarding screen (S06) — 4 steps: nationality, residence status,
/// region, arrival date.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Form data — all optional (can be skipped).
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
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).genericError),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.onboardingTitle),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : () => _submit(),
            child: Text(l10n.onboardingSkip),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: List.generate(_totalSteps, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          Text(
            l10n.onboardingStepOf(_currentStep + 1, _totalSteps),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),

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

          // Navigation buttons.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _nextStep,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _currentStep < _totalSteps - 1
                              ? l10n.onboardingNext
                              : l10n.onboardingComplete,
                        ),
                ),
              ),
            ),
          ),
        ],
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
    'CN', 'VN', 'KR', 'PH', 'BR', 'NP', 'ID', 'US', 'TH', 'IN',
    'MM', 'TW', 'PE', 'GB', 'PK', 'BD', 'LK', 'FR', 'DE', 'OTHER',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingNationalityTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingNationalitySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _nationalities.map((code) {
              final isSelected = value == code;
              return ChoiceChip(
                label: Text(_nationalityLabel(code, l10n)),
                selected: isSelected,
                onSelected: (selected) {
                  onChanged(selected ? code : null);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _nationalityLabel(String code, AppLocalizations l10n) {
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
    'technical_intern',
    'highly_skilled',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingResidenceStatusTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingResidenceStatusSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ...(_statuses.map((status) {
            final isSelected = value == status;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
                tileColor: isSelected
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : null,
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                title: Text(_statusLabel(status, l10n)),
                onTap: () => onChanged(isSelected ? null : status),
              ),
            );
          })),
        ],
      ),
    );
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    return switch (status) {
      'engineer_specialist' => l10n.visaEngineer,
      'student' => l10n.visaStudent,
      'dependent' => l10n.visaDependent,
      'permanent_resident' => l10n.visaPermanent,
      'spouse_of_japanese' => l10n.visaSpouse,
      'working_holiday' => l10n.visaWorkingHoliday,
      'specified_skilled_worker' => l10n.visaSpecifiedSkilled,
      'technical_intern' => l10n.visaTechnicalIntern,
      'highly_skilled' => l10n.visaHighlySkilled,
      _ => l10n.visaOther,
    };
  }
}

// ─── Step 3: Region ──────────────────────────────────────────

class _RegionStep extends StatelessWidget {
  const _RegionStep({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  static const _regions = [
    'tokyo', 'osaka', 'nagoya', 'yokohama', 'fukuoka',
    'sapporo', 'kobe', 'kyoto', 'sendai', 'hiroshima',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingRegionTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingRegionSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _regions.map((region) {
              final isSelected = value == region;
              return ChoiceChip(
                label: Text(_regionLabel(region, l10n)),
                selected: isSelected,
                onSelected: (selected) {
                  onChanged(selected ? region : null);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _regionLabel(String region, AppLocalizations l10n) {
    return switch (region) {
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
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingArrivalDateTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingArrivalDateSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                if (value != null)
                  Text(
                    '${value!.year}/${value!.month.toString().padLeft(2, '0')}/${value!.day.toString().padLeft(2, '0')}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.edit_calendar),
                  label: Text(
                    value == null
                        ? l10n.onboardingSelectDate
                        : l10n.onboardingChangeDate,
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: value ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      onChanged(picked);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
