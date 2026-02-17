/// An admin procedure template available for tracking.
class ProcedureTemplate {
  const ProcedureTemplate({
    required this.id,
    required this.procedureType,
    required this.title,
    this.description,
    this.category,
    this.isArrivalEssential = false,
  });

  final String id;

  /// Backend returns `procedure_code`, not `procedure_type`.
  final String procedureType;

  /// Backend returns `procedure_name`, not `title`.
  final String title;
  final String? description;
  final String? category;
  final bool isArrivalEssential;

  factory ProcedureTemplate.fromJson(Map<String, dynamic> json) {
    return ProcedureTemplate(
      id: json['id'] as String,
      // Backend uses 'procedure_code', not 'procedure_type'.
      procedureType:
          json['procedure_code'] as String? ??
          json['procedure_type'] as String? ??
          '',
      // Backend uses 'procedure_name', not 'title'.
      title:
          json['procedure_name'] as String? ?? json['title'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String?,
      isArrivalEssential: json['is_arrival_essential'] as bool? ?? false,
    );
  }
}
