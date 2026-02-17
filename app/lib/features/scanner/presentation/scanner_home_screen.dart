import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/providers/router_provider.dart';
import 'providers/scanner_providers.dart';

/// Scanner home screen with scan button and options.
class ScannerHomeScreen extends ConsumerStatefulWidget {
  const ScannerHomeScreen({super.key});

  @override
  ConsumerState<ScannerHomeScreen> createState() => _ScannerHomeScreenState();
}

class _ScannerHomeScreenState extends ConsumerState<ScannerHomeScreen> {
  bool _isScanning = false;

  /// Mock scan — in production this would use image_picker for camera/gallery.
  Future<void> _startScan() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isScanning = true);

    try {
      final repo = ref.read(scannerRepositoryProvider);

      // Mock file bytes for demo — in production, use image_picker
      final mockBytes = Uint8List.fromList(List.generate(100, (i) => i % 256));

      final scan = await repo.scanDocument(
        fileBytes: mockBytes,
        fileName: 'document.jpg',
      );

      ref.invalidate(scanHistoryProvider);

      if (mounted) {
        context.push(AppRoutes.scannerResult.replaceFirst(':id', scan.id));
      }
    } on DioException catch (e) {
      if (mounted) {
        String message = l10n.genericError;
        if (e.response?.statusCode == 403) {
          message = l10n.scannerLimitReached;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.genericError)));
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scannerTitle),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.scannerHistory),
            icon: const Icon(Icons.history),
            label: Text(l10n.scannerHistory),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Scan illustration
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.document_scanner_outlined,
                  size: 80,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                l10n.scannerDescription,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Free tier limit info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.scannerFreeLimitInfo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Scan buttons
              if (_isScanning)
                const CircularProgressIndicator()
              else ...[
                FilledButton.icon(
                  onPressed: _startScan,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(l10n.scannerFromCamera),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _startScan,
                  icon: const Icon(Icons.photo_library),
                  label: Text(l10n.scannerFromGallery),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
