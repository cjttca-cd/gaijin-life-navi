import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../chat/presentation/widgets/disclaimer_banner.dart';
import 'providers/visa_providers.dart';

/// Detailed view of a visa procedure: steps, documents, fees, disclaimer.
class VisaDetailScreen extends ConsumerWidget {
  const VisaDetailScreen({super.key, required this.procedureId});

  final String procedureId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final detail = ref.watch(visaProcedureDetailProvider(procedureId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.visaDetailTitle),
      ),
      body: detail.when(
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
                onPressed: () => ref.invalidate(
                    visaProcedureDetailProvider(procedureId)),
                child: Text(l10n.chatRetry),
              ),
            ],
          ),
        ),
        data: (proc) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(proc.title, style: theme.textTheme.headlineSmall),
                if (proc.description != null) ...[
                  const SizedBox(height: 8),
                  Text(proc.description!,
                      style: theme.textTheme.bodyLarge),
                ],
                const SizedBox(height: 16),

                // Disclaimer banner (mandatory)
                DisclaimerBanner(
                  text: proc.disclaimer ?? l10n.visaDisclaimer,
                ),
                const SizedBox(height: 24),

                // Steps
                if (proc.steps.isNotEmpty) ...[
                  Text(l10n.visaSteps,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...proc.steps.map(
                    (step) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              theme.colorScheme.primaryContainer,
                          child: Text(
                            '${step.stepNumber}',
                            style: TextStyle(
                              color: theme
                                  .colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(step.title),
                        subtitle: step.description != null
                            ? Text(step.description!)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Required documents
                if (proc.requiredDocuments.isNotEmpty) ...[
                  Text(l10n.visaRequiredDocuments,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...proc.requiredDocuments.map(
                    (doc) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 20,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(doc)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Fees
                if (proc.fees != null) ...[
                  Text(l10n.visaFees,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.payments_outlined,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(child: Text(proc.fees!)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Processing time
                if (proc.processingTime != null) ...[
                  Text(l10n.visaProcessingTime,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.schedule_outlined,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(child: Text(proc.processingTime!)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Source URL
                if (proc.sourceUrl != null) ...[
                  Row(
                    children: [
                      Icon(Icons.link,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${l10n.bankingSource}: ${proc.sourceUrl}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
