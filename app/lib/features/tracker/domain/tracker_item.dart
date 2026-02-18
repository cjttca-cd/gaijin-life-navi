import 'dart:convert';
import 'dart:math';

/// A locally-saved to-do item.
///
/// Stored in SharedPreferences as JSON.
class TrackerItem {
  const TrackerItem({
    required this.id,
    required this.title,
    this.memo,
    this.dueDate,
    required this.completed,
    required this.createdAt,
  });

  /// Unique local ID (generated at creation time).
  final String id;

  /// Human-readable title.
  final String title;

  /// Optional memo / notes.
  final String? memo;

  /// Optional due date.
  final DateTime? dueDate;

  /// Whether the item is completed.
  final bool completed;

  /// When the item was created.
  final DateTime createdAt;

  /// Generate a unique local ID.
  static String generateId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = Random.secure().nextInt(0xFFFFFF);
    return '${now}_$random';
  }

  TrackerItem copyWith({
    String? id,
    String? title,
    String? memo,
    DateTime? dueDate,
    bool? completed,
    DateTime? createdAt,
    bool clearMemo = false,
    bool clearDueDate = false,
  }) {
    return TrackerItem(
      id: id ?? this.id,
      title: title ?? this.title,
      memo: clearMemo ? null : (memo ?? this.memo),
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'memo': memo,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TrackerItem.fromJson(Map<String, dynamic> json) {
    return TrackerItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      memo: json['memo'] as String?,
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'] as String)
          : null,
      completed: json['completed'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
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
