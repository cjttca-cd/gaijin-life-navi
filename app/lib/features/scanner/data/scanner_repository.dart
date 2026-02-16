import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../domain/document_scan.dart';

/// Repository for Document Scanner API operations (AI Service).
class ScannerRepository {
  ScannerRepository({required Dio aiClient}) : _client = aiClient;

  final Dio _client;

  /// Upload and scan a document.
  /// Returns the initial scan record (status: processing).
  Future<DocumentScan> scanDocument({
    required Uint8List fileBytes,
    required String fileName,
    String? targetLanguage,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      if (targetLanguage != null) 'target_language': targetLanguage,
    });

    final response = await _client.post<Map<String, dynamic>>(
      '/ai/documents/scan',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return DocumentScan.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }

  /// Fetch scan history list.
  Future<List<DocumentScan>> getScans({
    int limit = 20,
    String? cursor,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/ai/documents',
      queryParameters: {
        'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
    );
    final items = response.data!['data'] as List<dynamic>;
    return items
        .map((e) => DocumentScan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a specific scan result.
  Future<DocumentScan> getScan(String scanId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/ai/documents/$scanId',
    );
    return DocumentScan.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }

  /// Delete a scan (soft-delete).
  Future<void> deleteScan(String scanId) async {
    await _client.delete<void>('/ai/documents/$scanId');
  }
}
