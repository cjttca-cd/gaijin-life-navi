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
  final String procedureType;
  final String title;
  final String? description;
  final String? category;
  final bool isArrivalEssential;

  factory ProcedureTemplate.fromJson(Map<String, dynamic> json) {
    return ProcedureTemplate(
      id: json['id'] as String,
      procedureType: json['procedure_type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String?,
      isArrivalEssential:
          json['is_arrival_essential'] as bool? ?? false,
    );
  }
}
