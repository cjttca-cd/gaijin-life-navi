/// A navigator domain (e.g. Banking, Visa, Medical).
class NavigatorDomain {
  const NavigatorDomain({
    required this.id,
    required this.label,
    this.icon,
    required this.status,
    this.guideCount = 0,
  });

  final String id;
  final String label;
  final String? icon;

  /// "active" or "coming_soon"
  final String status;
  final int guideCount;

  bool get isActive => status == 'active';
  bool get isComingSoon => status == 'coming_soon';

  factory NavigatorDomain.fromJson(Map<String, dynamic> json) {
    return NavigatorDomain(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      icon: json['icon'] as String?,
      status: json['status'] as String? ?? 'active',
      guideCount: json['guide_count'] as int? ?? 0,
    );
  }
}

/// A guide entry in a domain's guide list.
class NavigatorGuide {
  const NavigatorGuide({
    required this.slug,
    required this.title,
    this.summary,
    this.domain,
    this.access = 'public',
  });

  final String slug;
  final String title;
  final String? summary;

  /// Domain ID this guide belongs to (set when aggregating cross-domain).
  final String? domain;

  /// Access level: "public", "premium", or "agent-only".
  final String access;

  /// Whether this guide requires a premium subscription.
  bool get isPremium => access == 'premium';

  /// Create a copy with a domain assigned.
  NavigatorGuide withDomain(String domainId) {
    return NavigatorGuide(
      slug: slug,
      title: title,
      summary: summary,
      domain: domainId,
      access: access,
    );
  }

  factory NavigatorGuide.fromJson(Map<String, dynamic> json) {
    return NavigatorGuide(
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      domain: json['domain'] as String?,
      access: json['access'] as String? ?? 'public',
    );
  }
}

/// Full guide detail with markdown content.
class NavigatorGuideDetail {
  const NavigatorGuideDetail({
    required this.title,
    required this.content,
    this.summary,
    this.domain,
    this.access = 'public',
    this.locked = false,
    this.excerpt,
    this.upgradeCta = false,
  });

  final String title;

  /// Markdown body.
  final String content;
  final String? summary;
  final String? domain;

  /// Access level: "public", "premium", or "agent-only".
  final String access;

  /// Whether the full content is locked for the current user.
  final bool locked;

  /// Short excerpt shown when the guide is locked.
  final String? excerpt;

  /// Whether to show an upgrade CTA.
  final bool upgradeCta;

  factory NavigatorGuideDetail.fromJson(Map<String, dynamic> json) {
    return NavigatorGuideDetail(
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      summary: json['summary'] as String?,
      domain: json['domain'] as String?,
      access: json['access'] as String? ?? 'public',
      locked: json['locked'] as bool? ?? false,
      excerpt: json['excerpt'] as String?,
      upgradeCta: json['upgrade_cta'] as bool? ?? false,
    );
  }
}
