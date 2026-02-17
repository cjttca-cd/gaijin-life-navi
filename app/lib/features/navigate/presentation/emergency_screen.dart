import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';
import 'providers/navigator_providers.dart';

/// S12: Emergency Guide — accessible without authentication.
///
/// Shows emergency numbers (always hardcoded 110/119 for offline),
/// how to call, useful Japanese phrases, and helplines.
class EmergencyScreen extends ConsumerWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final emergencyAsync = ref.watch(emergencyDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emergencyTitle),
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
        iconTheme: IconThemeData(color: theme.colorScheme.onError),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppSpacing.screenPadding),
              padding: const EdgeInsets.all(AppSpacing.spaceLg),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: 20,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Expanded(
                    child: Text(
                      l10n.emergencyWarning,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Emergency Contacts section
            _SectionHeader(title: l10n.emergencySectionContacts),

            // Hardcoded 110 and 119 (always available, even offline)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                children: [
                  _EmergencyContactCard(
                    icon: Icons.local_police,
                    name: l10n.emergencyPoliceName,
                    number: l10n.emergencyPoliceNumber,
                    telUri: 'tel:110',
                    isLargeNumber: true,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  _EmergencyContactCard(
                    icon: Icons.local_hospital,
                    name: l10n.emergencyFireName,
                    number: l10n.emergencyFireNumber,
                    telUri: 'tel:119',
                    isLargeNumber: true,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  _EmergencyContactCard(
                    icon: Icons.medical_services,
                    name: l10n.emergencyMedicalName,
                    number: l10n.emergencyMedicalNumber,
                    note: l10n.emergencyMedicalNote,
                    telUri: 'tel:%237119',
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  _EmergencyContactCard(
                    icon: Icons.favorite,
                    name: l10n.emergencyTellName,
                    number: l10n.emergencyTellNumber,
                    note: l10n.emergencyTellNote,
                    telUri: 'tel:0357740992',
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  _EmergencyContactCard(
                    icon: Icons.language,
                    name: l10n.emergencyHelplineName,
                    number: l10n.emergencyHelplineNumber,
                    note: l10n.emergencyHelplineNote,
                    telUri: 'tel:0570064211',
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space2xl),

            // How to Call an Ambulance section
            _SectionHeader(title: l10n.emergencySectionAmbulance),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spaceLg),
                  child: Column(
                    children: [
                      _AmbulanceStep(number: 1, text: l10n.emergencyStep1),
                      const SizedBox(height: AppSpacing.spaceMd),
                      _AmbulanceStep(number: 2, text: l10n.emergencyStep2),
                      const SizedBox(height: AppSpacing.spaceMd),
                      _AmbulanceStep(number: 3, text: l10n.emergencyStep3),
                      const SizedBox(height: AppSpacing.spaceMd),
                      _AmbulanceStep(number: 4, text: l10n.emergencyStep4),
                      const SizedBox(height: AppSpacing.spaceMd),
                      _AmbulanceStep(number: 5, text: l10n.emergencyStep5),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.space2xl),

            // Useful Japanese phrases (always shown regardless of language)
            _SectionHeader(title: l10n.medicalUsefulPhrases),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                children: [
                  _PhraseCard(
                    japanese: '救急です',
                    reading: 'Kyuukyuu desu',
                    translation: l10n.emergencyPhraseEmergencyHelp,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  _PhraseCard(
                    japanese: '助けてください',
                    reading: 'Tasukete kudasai',
                    translation: l10n.emergencyPhraseHelpHelp,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  _PhraseCard(
                    japanese: '救急車をお願いします',
                    reading: 'Kyuukyuusha wo onegai shimasu',
                    translation: l10n.emergencyPhraseAmbulanceHelp,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  _PhraseCard(
                    japanese: '住所は〇〇です',
                    reading: 'Juusho wa ○○ desu',
                    translation: l10n.emergencyPhraseAddressHelp,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.space2xl),

            // Need more help?
            _SectionHeader(title: l10n.emergencySectionMoreHelp),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => context.push(AppRoutes.chat),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 20),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Text(l10n.emergencyAskAi),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.space2xl),

            // Disclaimer
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                children: [
                  Divider(color: theme.colorScheme.outlineVariant),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.spaceXs),
                      Expanded(
                        child: Text(
                          l10n.emergencyDisclaimer,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // API-loaded additional content (if available)
            emergencyAsync.when(
              loading: () => const SizedBox.shrink(),
              error:
                  (_, __) => Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Text(
                      l10n.emergencyOffline,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              data: (_) => const SizedBox.shrink(),
            ),

            const SizedBox(height: AppSpacing.space3xl),
          ],
        ),
      ),
    );
  }
}

/// Section header with uppercase label.
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
        AppSpacing.spaceMd,
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

/// Emergency contact card with call button.
class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({
    required this.icon,
    required this.name,
    required this.number,
    required this.telUri,
    this.note,
    this.isLargeNumber = false,
  });

  final IconData icon;
  final String name;
  final String number;
  final String telUri;
  final String? note;
  final bool isLargeNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _makeCall(context),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.space2xs),
                    Text(
                      number,
                      style:
                          isLargeNumber
                              ? theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              )
                              : theme.textTheme.headlineMedium,
                    ),
                    if (note != null) ...[
                      const SizedBox(height: AppSpacing.space2xs),
                      Text(
                        note!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Call button
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: theme.colorScheme.onError,
                    size: 24,
                  ),
                  onPressed: () => _makeCall(context),
                  tooltip: '${l10n.emergencyCallButton} $number',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makeCall(BuildContext context) async {
    final uri = Uri.parse(telUri);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// Ambulance step row with numbered circle.
class _AmbulanceStep extends StatelessWidget {
  const _AmbulanceStep({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.spaceMd),
        Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
      ],
    );
  }
}

/// Japanese phrase card with reading and translation.
class _PhraseCard extends StatelessWidget {
  const _PhraseCard({
    required this.japanese,
    required this.reading,
    required this.translation,
  });

  final String japanese;
  final String reading;
  final String translation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(japanese, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.space2xs),
            Text(
              reading,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            Text(
              translation,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
