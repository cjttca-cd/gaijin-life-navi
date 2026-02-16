/// Represents a visa procedure from the Visa Navigator API.
class VisaProcedure {
  const VisaProcedure({
    required this.id,
    required this.procedureType,
    required this.title,
    this.description,
    this.applicableStatuses = const [],
    this.steps = const [],
    this.requiredDocuments = const [],
    this.fees,
    this.processingTime,
    this.disclaimer,
    this.sourceUrl,
  });

  final String id;
  final String procedureType;
  final String title;
  final String? description;
  final List<String> applicableStatuses;
  final List<VisaStep> steps;

  /// Backend returns documents as `{name, how_to_get}` (localized strings).
  final List<VisaDocument> requiredDocuments;

  /// Backend returns dict e.g. {application_fee: 4000, currency: "JPY", notes: "..."}.
  final Map<String, dynamic>? fees;

  /// Backend returns this as `estimated_duration`, not `processing_time`.
  final String? processingTime;
  final String? disclaimer;
  final String? sourceUrl;

  factory VisaProcedure.fromJson(Map<String, dynamic> json) {
    return VisaProcedure(
      id: json['id'] as String,
      procedureType: json['procedure_type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      applicableStatuses: (json['applicable_statuses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => VisaStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      requiredDocuments: (json['required_documents'] as List<dynamic>?)
              ?.map((e) =>
                  VisaDocument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      // Backend returns dict, not String.
      fees: json['fees'] is Map<String, dynamic>
          ? json['fees'] as Map<String, dynamic>
          : null,
      // Backend uses 'estimated_duration', not 'processing_time'.
      processingTime: json['estimated_duration'] as String? ??
          json['processing_time'] as String?,
      disclaimer: json['disclaimer'] as String?,
      sourceUrl: json['source_url'] as String?,
    );
  }
}

/// A step in a visa procedure.
class VisaStep {
  const VisaStep({
    required this.stepNumber,
    required this.title,
    this.description,
  });

  final int stepNumber;
  final String title;
  final String? description;

  factory VisaStep.fromJson(Map<String, dynamic> json) {
    return VisaStep(
      // Backend uses 'order', not 'step_number'.
      stepNumber: json['order'] as int? ?? json['step_number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}

/// A required document for a visa procedure.
class VisaDocument {
  const VisaDocument({
    required this.name,
    this.howToGet,
  });

  final String name;
  final String? howToGet;

  factory VisaDocument.fromJson(Map<String, dynamic> json) {
    return VisaDocument(
      name: json['name'] as String? ?? '',
      howToGet: json['how_to_get'] as String?,
    );
  }
}
