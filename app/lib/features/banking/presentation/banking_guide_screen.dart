import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import 'providers/banking_providers.dart';

/// Detailed bank account opening guide screen.
class BankingGuideScreen extends ConsumerWidget {
  const BankingGuideScreen({super.key, required this.bankId});

  final String bankId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final guideAsync = ref.watch(bankGuideProvider(bankId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bankingGuideTitle),
      ),
      body: guideAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48,
                  color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(l10n.genericError),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(bankGuideProvider(bankId)),
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
                // Bank header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              theme.colorScheme.primaryContainer,
                          child: Text(
                            '${guide.bank.foreignerFriendlyScore}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color:
                                  theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide.bank.bankName,
                                style: theme.textTheme.titleLarge,
                              ),
                              Text(
                                '${l10n.bankingFriendlyScore}: ${guide.bank.foreignerFriendlyScore}/5',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: theme
                                      .colorScheme.onSurfaceVariant,
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

                // Required documents
                Text(
                  l10n.bankingRequiredDocs,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ..._buildRequirementsList(guide.requirements, theme),
                const SizedBox(height: 24),

                // Conversation templates
                if (guide.conversationTemplates.isNotEmpty) ...[
                  Text(
                    l10n.bankingConversationTemplates,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...guide.conversationTemplates.map(
                    (template) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              template.situation,
                              style: theme.textTheme.labelLarge
                                  ?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const Divider(),
                            Text(
                              template.japanese,
                              style:
                                  theme.textTheme.titleSmall,
                            ),
                            if (template.reading.isNotEmpty)
                              Text(
                                template.reading,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: theme.colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              template.translation,
                              style:
                                  theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Troubleshooting
                if (guide.troubleshooting != null &&
                    guide.troubleshooting!.isNotEmpty) ...[
                  Text(
                    l10n.bankingTroubleshooting,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...guide.troubleshooting!.map(
                    (item) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.help_outline,
                                    size: 20,
                                    color: theme
                                        .colorScheme.tertiary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(item.problem,
                                      style: theme
                                          .textTheme.titleSmall),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.lightbulb_outline,
                                    size: 20,
                                    color: theme
                                        .colorScheme.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(item.solution)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Source URL
                if (guide.sourceUrl != null) ...[
                  Row(
                    children: [
                      Icon(Icons.link,
                          size: 16,
                          color:
                              theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${l10n.bankingSource}: ${guide.sourceUrl}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Disclaimer not required for banking per spec,
                // but source citation is shown above.
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build requirements display from the requirements map structure.
  /// Extracts the 'documents' list if present, otherwise shows key-value pairs.
  List<Widget> _buildRequirementsList(
      Map<String, dynamic> requirements, ThemeData theme) {
    final widgets = <Widget>[];
    final documents = requirements['documents'];
    if (documents is List) {
      for (final doc in documents) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description_outlined,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(doc.toString())),
              ],
            ),
          ),
        );
      }
    }
    // Show other notable requirements
    for (final entry in requirements.entries) {
      if (entry.key == 'documents') continue;
      final label = entry.key.replaceAll('_', ' ');
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$label: ${entry.value}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}
