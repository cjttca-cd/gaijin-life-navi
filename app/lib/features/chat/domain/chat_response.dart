/// Response from POST /api/v1/chat — Phase 0 synchronous AI chat.
class ChatResponse {
  const ChatResponse({
    required this.reply,
    required this.domain,
    this.sources = const [],
    this.actions = const [],
    this.trackerItems = const [],
    required this.usage,
  });

  /// AI response text (markdown format).
  final String reply;

  /// Routing domain (banking/visa/medical/concierge).
  final String domain;

  /// Reference sources [{title, url}].
  final List<ChatSource> sources;

  /// Suggested actions [{type, items/text}].
  final List<ChatAction> actions;

  /// Auto-generated tracker items [{type, title, date}].
  final List<ChatTrackerItem> trackerItems;

  /// Usage info {used, limit, tier}.
  final ChatUsageInfo usage;

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      reply: json['reply'] as String? ?? '',
      domain: json['domain'] as String? ?? 'concierge',
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => ChatSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map((e) => ChatAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      trackerItems:
          (json['tracker_items'] as List<dynamic>?)
              ?.map((e) => ChatTrackerItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      usage:
          json['usage'] != null
              ? ChatUsageInfo.fromJson(json['usage'] as Map<String, dynamic>)
              : const ChatUsageInfo(used: 0, limit: 0, tier: 'free'),
    );
  }
}

/// A source citation from AI response.
class ChatSource {
  const ChatSource({required this.title, required this.url});

  final String title;
  final String url;

  factory ChatSource.fromJson(Map<String, dynamic> json) {
    return ChatSource(
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

/// A suggested action from AI response.
class ChatAction {
  const ChatAction({required this.type, this.items, this.text});

  final String type;
  final String? items;
  final String? text;

  factory ChatAction.fromJson(Map<String, dynamic> json) {
    return ChatAction(
      type: json['type'] as String? ?? '',
      items: json['items'] as String?,
      text: json['text'] as String?,
    );
  }
}

/// A tracker item suggested by AI.
class ChatTrackerItem {
  const ChatTrackerItem({required this.type, required this.title, this.date});

  final String type;
  final String title;
  final String? date;

  factory ChatTrackerItem.fromJson(Map<String, dynamic> json) {
    return ChatTrackerItem(
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String?,
    );
  }
}

/// Usage info returned in chat response.
class ChatUsageInfo {
  const ChatUsageInfo({
    required this.used,
    required this.limit,
    required this.tier,
  });

  final int used;
  final int limit;
  final String tier;

  int get remaining => limit > 0 ? (limit - used).clamp(0, limit) : -1;
  bool get isUnlimited => limit <= 0;

  factory ChatUsageInfo.fromJson(Map<String, dynamic> json) {
    return ChatUsageInfo(
      used: json['used'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
      tier: json['tier'] as String? ?? 'free',
    );
  }
}
