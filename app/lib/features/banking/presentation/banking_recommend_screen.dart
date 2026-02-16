import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import 'providers/banking_providers.dart';

/// Screen for getting bank recommendations based on priorities.
class BankingRecommendScreen extends ConsumerStatefulWidget {
  const BankingRecommendScreen({super.key});

  @override
  ConsumerState<BankingRecommendScreen> createState() =>
      _BankingRecommendScreenState();
}

class _BankingRecommendScreenState
    extends ConsumerState<BankingRecommendScreen> {
  final Set<String> _selectedPriorities = {};
  bool _hasSearched = false;

  static const _priorityKeys = [
    'multilingual',
    'low_fee',
    'atm',
    'online',
  ];

  String _priorityLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'multilingual':
        return l10n.bankingPriorityMultilingual;
      case 'low_fee':
        return l10n.bankingPriorityLowFee;
      case 'atm':
        return l10n.bankingPriorityAtm;
      case 'online':
        return l10n.bankingPriorityOnline;
      default:
        return key;
    }
  }

  void _search() {
    setState(() {
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bankingRecommendTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Priority selection
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bankingSelectPriorities,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _priorityKeys.map((key) {
                    final isSelected = _selectedPriorities.contains(key);
                    return FilterChip(
                      label: Text(_priorityLabel(l10n, key)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedPriorities.add(key);
                          } else {
                            _selectedPriorities.remove(key);
                          }
                          _hasSearched = false;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _search,
                  child: Text(l10n.bankingGetRecommendations),
                ),
              ],
            ),
          ),
          const Divider(),
          // Results
          if (_hasSearched)
            Expanded(
              child: _RecommendationResults(
                priorities: _selectedPriorities.toList(),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  l10n.bankingRecommendHint,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RecommendationResults extends ConsumerWidget {
  const _RecommendationResults({required this.priorities});

  final List<String> priorities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final results = ref.watch(bankRecommendationsProvider(priorities));

    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(l10n.genericError),
      ),
      data: (recommendations) {
        if (recommendations.isEmpty) {
          return Center(
            child: Text(l10n.bankingNoRecommendations),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            final rec = recommendations[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            rec.bank.bankName,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${rec.matchScore}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Match reasons
                    ...rec.matchReasons.map(
                      (reason) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                size: 16,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(reason)),
                          ],
                        ),
                      ),
                    ),
                    // Warnings
                    ...rec.warnings.map(
                      (warning) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber,
                                size: 16,
                                color: theme.colorScheme.error),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                warning,
                                style: TextStyle(
                                    color: theme.colorScheme.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(
                          AppRoutes.bankingGuide
                              .replaceFirst(':bankId', rec.bank.id),
                        ),
                        child: Text(l10n.bankingViewGuide),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
