import 'package:flutter_test/flutter_test.dart';
import 'package:gaijin_life_navi/features/scanner/domain/document_scan.dart';

void main() {
  group('ScanStatus', () {
    test('fromString parses all statuses', () {
      expect(ScanStatus.fromString('uploading'), ScanStatus.uploading);
      expect(ScanStatus.fromString('processing'), ScanStatus.processing);
      expect(ScanStatus.fromString('completed'), ScanStatus.completed);
      expect(ScanStatus.fromString('failed'), ScanStatus.failed);
    });

    test('fromString defaults to processing for unknown', () {
      expect(ScanStatus.fromString('unknown'), ScanStatus.processing);
    });
  });

  group('DocumentScan', () {
    test('fromJson creates valid completed scan', () {
      final json = {
        'id': 'scan-1',
        'status': 'completed',
        'file_url': 'https://example.com/file.jpg',
        'ocr_text': '年金のお知らせ',
        'translation': 'Pension Notice',
        'explanation': 'This is a pension notification letter.',
        'document_type': 'pension_notice',
        'created_at': '2026-02-16T12:00:00Z',
      };

      final scan = DocumentScan.fromJson(json);

      expect(scan.id, 'scan-1');
      expect(scan.status, ScanStatus.completed);
      expect(scan.ocrText, '年金のお知らせ');
      expect(scan.translation, 'Pension Notice');
      expect(scan.explanation, isNotNull);
      expect(scan.documentType, 'pension_notice');
      expect(scan.createdAt, isNotNull);
    });

    test('fromJson creates processing scan', () {
      final json = {
        'id': 'scan-2',
        'status': 'processing',
      };

      final scan = DocumentScan.fromJson(json);

      expect(scan.status, ScanStatus.processing);
      expect(scan.ocrText, isNull);
      expect(scan.translation, isNull);
    });

    test('fromJson creates failed scan', () {
      final json = {
        'id': 'scan-3',
        'status': 'failed',
      };

      final scan = DocumentScan.fromJson(json);

      expect(scan.status, ScanStatus.failed);
    });
  });
}
