/// Status of a tracked procedure.
enum ProcedureStatus {
  notStarted,
  inProgress,
  completed;

  String get apiValue {
    switch (this) {
      case ProcedureStatus.notStarted:
        return 'not_started';
      case ProcedureStatus.inProgress:
        return 'in_progress';
      case ProcedureStatus.completed:
        return 'completed';
    }
  }

  static ProcedureStatus fromString(String value) {
    switch (value) {
      case 'not_started':
        return ProcedureStatus.notStarted;
      case 'in_progress':
        return ProcedureStatus.inProgress;
      case 'completed':
        return ProcedureStatus.completed;
      default:
        return ProcedureStatus.notStarted;
    }
  }
}

/// A user's tracked procedure.
class UserProcedure {
  const UserProcedure({
    required this.id,
    required this.procedureRefType,
    required this.procedureRefId,
    required this.title,
    required this.status,
    this.dueDate,
    this.notes,
    this.completedAt,
    this.createdAt,
  });

  final String id;
  final String procedureRefType;
  final String procedureRefId;
  final String title;
  final ProcedureStatus status;
  final DateTime? dueDate;
  final String? notes;
  final DateTime? completedAt;
  final DateTime? createdAt;

  factory UserProcedure.fromJson(Map<String, dynamic> json) {
    return UserProcedure(
      id: json['id'] as String,
      procedureRefType: json['procedure_ref_type'] as String? ?? '',
      procedureRefId: json['procedure_ref_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: ProcedureStatus.fromString(
          json['status'] as String? ?? 'not_started'),
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'] as String)
          : null,
      notes: json['notes'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
