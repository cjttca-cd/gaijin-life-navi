import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../chat/presentation/widgets/disclaimer_banner.dart';
import 'providers/medical_providers.dart';

/// Medical Guide screen with emergency guide and phrase collection.
class MedicalGuideScreen extends ConsumerStatefulWidget {
  const MedicalGuideScreen({super.key});

  @override
  ConsumerState<MedicalGuideScreen> createState() =>
      _MedicalGuideScreenState();
}

class _MedicalGuideScreenState extends ConsumerState<MedicalGuideScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicalTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.medicalTabEmergency),
            Tab(text: l10n.medicalTabPhrases),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _EmergencyGuideTab(),
          _PhrasesTab(),
        ],
      ),
    );
  }
}

class _EmergencyGuideTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final guideAsync = ref.watch(emergencyGuideProvider);

    return guideAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.genericError),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => ref.invalidate(emergencyGuideProvider),
              child: Text(l10n.chatRetry),
            ),
          ],
        ),
      ),
      data: (guide) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer banner (mandatory for Medical Guide)
              DisclaimerBanner(
                text: guide.disclaimer ?? l10n.medicalDisclaimer,
              ),
              const SizedBox(height: 16),

              // Emergency number
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emergency,
                        size: 48,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.medicalEmergencyNumber,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                            Text(
                              guide.emergencyNumber,
                              style:
                                  theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // How to call
              Text(l10n.medicalHowToCall,
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: guide.howToCall
                        .map((step) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 4),
                              child: Text('• $step'),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // What to prepare
              Text(l10n.medicalWhatToPrepare,
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: guide.whatToPrepare
                        .map((item) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 4),
                              child: Text('• $item'),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Useful phrases
              if (guide.usefulPhrases.isNotEmpty) ...[
                Text(l10n.medicalUsefulPhrases,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                ...guide.usefulPhrases.map(
                  (phrase) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(phrase.ja,
                              style: theme.textTheme.titleSmall),
                          if (phrase.reading.isNotEmpty)
                            Text(phrase.reading,
                                style: theme.textTheme.bodySmall),
                          Text(phrase.translation),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PhrasesTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_PhrasesTab> createState() => _PhrasesTabState();
}

class _PhrasesTabState extends ConsumerState<_PhrasesTab> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final phrasesAsync =
        ref.watch(medicalPhrasesProvider(_selectedCategory));

    return Column(
      children: [
        // Disclaimer banner (mandatory)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: DisclaimerBanner(text: l10n.medicalDisclaimer),
        ),

        // Category filter
        Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: Text(l10n.medicalCategoryAll),
                  selected: _selectedCategory == null,
                  onSelected: (_) {
                    setState(() => _selectedCategory = null);
                  },
                ),
                const SizedBox(width: 8),
                ..._categoryOptions(l10n).map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(entry.value),
                      selected: _selectedCategory == entry.key,
                      onSelected: (_) {
                        setState(() => _selectedCategory = entry.key);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Phrases list
        Expanded(
          child: phrasesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(child: Text(l10n.genericError)),
            data: (phrases) {
              if (phrases.isEmpty) {
                return Center(
                  child: Text(l10n.medicalNoPhrases),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: phrases.length,
                itemBuilder: (context, index) {
                  final phrase = phrases[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Japanese
                          Text(
                            phrase.phraseJa,
                            style: theme.textTheme.titleSmall,
                          ),
                          // Reading
                          if (phrase.phraseReading != null)
                            Text(
                              phrase.phraseReading!,
                              style:
                                  theme.textTheme.bodySmall?.copyWith(
                                color: theme
                                    .colorScheme.onSurfaceVariant,
                              ),
                            ),
                          const Divider(height: 12),
                          // Translation
                          Text(
                            phrase.translation,
                            style: theme.textTheme.bodyMedium,
                          ),
                          // Context
                          if (phrase.context != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                phrase.context!,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: theme
                                      .colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  List<MapEntry<String, String>> _categoryOptions(AppLocalizations l10n) {
    return [
      MapEntry('emergency', l10n.medicalCategoryEmergency),
      MapEntry('symptom', l10n.medicalCategorySymptom),
      MapEntry('insurance', l10n.medicalCategoryInsurance),
      MapEntry('general', l10n.medicalCategoryGeneral),
    ];
  }
}
