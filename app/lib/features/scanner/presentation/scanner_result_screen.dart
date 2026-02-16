import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../domain/document_scan.dart';
import 'providers/scanner_providers.dart';

/// Displays scan result: original text, translation, and explanation.
class ScannerResultScreen extends ConsumerWidget {
  const ScannerResultScreen({super.key, required this.scanId});

  final String scanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scanAsync = ref.watch(scanResultProvider(scanId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scannerResultTitle),
      ),
      body: scanAsync.when(
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
                    ref.invalidate(scanResultProvider(scanId)),
                child: Text(l10n.chatRetry),
              ),
            ],
          ),
        ),
        data: (scan) {
          if (scan.status == ScanStatus.processing ||
              scan.status == ScanStatus.uploading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.scannerProcessing,
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () =>
                        ref.invalidate(scanResultProvider(scanId)),
                    child: Text(l10n.scannerRefresh),
                  ),
                ],
              ),
            );
          }

          if (scan.status == ScanStatus.failed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48,
                      color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(l10n.scannerFailed,
                      style: theme.textTheme.bodyLarge),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document type badge
                if (scan.documentType != null) ...[
                  Chip(
                    label: Text(scan.documentType!),
                    avatar: const Icon(Icons.description, size: 18),
                  ),
                  const SizedBox(height: 16),
                ],

                // Original OCR text
                if (scan.ocrText != null && scan.ocrText!.isNotEmpty) ...[
                  Text(l10n.scannerOriginalText,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(
                        scan.ocrText!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Translation
                if (scan.translation != null &&
                    scan.translation!.isNotEmpty) ...[
                  Text(l10n.scannerTranslation,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(
                        scan.translation!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Explanation
                if (scan.explanation != null &&
                    scan.explanation!.isNotEmpty) ...[
                  Text(l10n.scannerExplanation,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Card(
                    color: theme.colorScheme.tertiaryContainer
                        .withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(
                        scan.explanation!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
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
