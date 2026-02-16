/// Status of a document scan.
enum ScanStatus {
  uploading,
  processing,
  completed,
  failed;

  static ScanStatus fromString(String value) {
    switch (value) {
      case 'uploading':
        return ScanStatus.uploading;
      case 'processing':
        return ScanStatus.processing;
      case 'completed':
        return ScanStatus.completed;
      case 'failed':
        return ScanStatus.failed;
      default:
        return ScanStatus.processing;
    }
  }
}

/// Represents a document scan result.
class DocumentScan {
  const DocumentScan({
    required this.id,
    required this.status,
    this.fileUrl,
    this.ocrText,
    this.translation,
    this.explanation,
    this.documentType,
    this.createdAt,
  });

  final String id;
  final ScanStatus status;
  final String? fileUrl;
  final String? ocrText;
  final String? translation;
  final String? explanation;
  final String? documentType;
  final DateTime? createdAt;

  factory DocumentScan.fromJson(Map<String, dynamic> json) {
    return DocumentScan(
      id: json['id'] as String,
      status:
          ScanStatus.fromString(json['status'] as String? ?? 'processing'),
      fileUrl: json['file_url'] as String?,
      ocrText: json['ocr_text'] as String?,
      translation: json['translation'] as String?,
      explanation: json['explanation'] as String?,
      documentType: json['document_type'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
