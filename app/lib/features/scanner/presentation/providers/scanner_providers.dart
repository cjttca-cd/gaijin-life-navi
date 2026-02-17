import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/ai_api_client.dart';
import '../../data/scanner_repository.dart';
import '../../domain/document_scan.dart';

/// Dio client for AI Service.
final _scannerDioProvider = Provider<Dio>((ref) {
  return createAiApiClient();
});

/// Scanner repository provider.
final scannerRepositoryProvider = Provider<ScannerRepository>((ref) {
  return ScannerRepository(aiClient: ref.watch(_scannerDioProvider));
});

/// Provider for scan history.
final scanHistoryProvider = FutureProvider<List<DocumentScan>>((ref) async {
  final repo = ref.watch(scannerRepositoryProvider);
  return repo.getScans();
});

/// Provider for a specific scan result.
final scanResultProvider = FutureProvider.family<DocumentScan, String>((
  ref,
  scanId,
) async {
  final repo = ref.watch(scannerRepositoryProvider);
  return repo.getScan(scanId);
});
