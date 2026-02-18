import 'dart:convert';
import 'dart:math';

/// Status of a tracked item.
enum TrackerStatus {
  notStarted,
  inProgress,
  completed;

  /// Convert to JSON-safe string.
  String toJson() {
    switch (this) {
      case TrackerStatus.notStarted:
        return 'not_started';
      case TrackerStatus.inProgress:
        return 'in_progress';
      case TrackerStatus.completed:
        return 'completed';
    }
  }

  /// Parse from JSON string.
  static TrackerStatus fromJson(String value) {
    switch (value) {
      case 'in_progress':
        return TrackerStatus.inProgress;
      case 'completed':
        return TrackerStatus.completed;
      case 'not_started':
      default:
        return TrackerStatus.notStarted;
    }
  }

  /// Cycle to the next status: notStarted → inProgress → completed → notStarted.
  TrackerStatus get next {
    switch (this) {
      case TrackerStatus.notStarted:
        return TrackerStatus.inProgress;
      case TrackerStatus.inProgress:
        return TrackerStatus.completed;
      case TrackerStatus.completed:
        return TrackerStatus.notStarted;
    }
  }
}

/// A locally-saved tracker item.
///
/// Created from AI-suggested [ChatTrackerItem] when the user taps "Save".
/// Stored in SharedPreferences (Phase 0 — server-side `user_procedures` TBD).
class TrackerItem {
  const TrackerItem({
    required this.id,
    required this.type,
    required this.title,
    this.date,
    required this.status,
    required this.savedAt,
  });

  /// Unique local ID (generated at save time).
  final String id;

  /// Item type from AI (e.g. "deadline", "task").
  final String type;

  /// Human-readable title.
  final String title;

  /// Optional date string (ISO 8601 or free-form from AI).
  final String? date;

  /// Current tracking status.
  final TrackerStatus status;

  /// When the user saved this item.
  final DateTime savedAt;

  /// Generate a unique local ID.
  static String generateId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = Random.secure().nextInt(0xFFFFFF);
    return '${now}_$random';
  }

  TrackerItem copyWith({
    String? id,
    String? type,
    String? title,
    String? date,
    TrackerStatus? status,
    DateTime? savedAt,
  }) {
    return TrackerItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      date: date ?? this.date,
      status: status ?? this.status,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'date': date,
      'status': status.toJson(),
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory TrackerItem.fromJson(Map<String, dynamic> json) {
    return TrackerItem(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String?,
      status: TrackerStatus.fromJson(
        json['status'] as String? ?? 'not_started',
      ),
      savedAt:
          DateTime.tryParse(json['savedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  /// Serialize a list of TrackerItems to JSON string for SharedPreferences.
  static String encodeList(List<TrackerItem> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }

  /// Deserialize a list of TrackerItems from JSON string.
  static List<TrackerItem> decodeList(String jsonString) {
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map((e) => TrackerItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackerItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
