/// Emergency data from GET /api/v1/emergency.
class EmergencyData {
  const EmergencyData({
    required this.title,
    this.contacts = const [],
    this.content = '',
  });

  /// Page title.
  final String title;

  /// Emergency contacts [{name, number, note}].
  final List<EmergencyContact> contacts;

  /// Markdown content for additional guide information.
  final String content;

  factory EmergencyData.fromJson(Map<String, dynamic> json) {
    return EmergencyData(
      title: json['title'] as String? ?? '',
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      content: json['content'] as String? ?? '',
    );
  }
}

/// A single emergency contact entry.
class EmergencyContact {
  const EmergencyContact({
    required this.name,
    required this.number,
    this.note = '',
  });

  final String name;
  final String number;
  final String note;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] as String? ?? '',
      number: json['number'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }
}
