import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import '../domain/document_scan.dart';
import 'providers/scanner_providers.dart';

/// Displays scan history list.
class ScannerHistoryScreen extends ConsumerWidget {
  const ScannerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final historyAsync = ref.watch(scanHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scannerHistoryTitle),
      ),
      body: historyAsync.when(
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
                onPressed: () => ref.invalidate(scanHistoryProvider),
                child: Text(l10n.chatRetry),
              ),
            ],
          ),
        ),
        data: (scans) {
          if (scans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.document_scanner_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.scannerHistoryEmpty,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scans.length,
            itemBuilder: (context, index) {
              final scan = scans[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: _scanStatusIcon(scan.status, theme),
                  title: Text(
                    scan.documentType ?? l10n.scannerUnknownType,
                  ),
                  subtitle: scan.createdAt != null
                      ? Text(_formatDate(scan.createdAt!))
                      : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(
                    AppRoutes.scannerResult
                        .replaceFirst(':id', scan.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _scanStatusIcon(ScanStatus status, ThemeData theme) {
    switch (status) {
      case ScanStatus.completed:
        return CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.check,
              color: theme.colorScheme.onPrimaryContainer),
        );
      case ScanStatus.processing:
      case ScanStatus.uploading:
        return CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      case ScanStatus.failed:
        return CircleAvatar(
          backgroundColor: theme.colorScheme.errorContainer,
          child: Icon(Icons.error_outline,
              color: theme.colorScheme.onErrorContainer),
        );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
