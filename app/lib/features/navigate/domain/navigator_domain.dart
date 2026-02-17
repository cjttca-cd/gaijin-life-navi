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
  const NavigatorGuide({required this.slug, required this.title, this.summary});

  final String slug;
  final String title;
  final String? summary;

  factory NavigatorGuide.fromJson(Map<String, dynamic> json) {
    return NavigatorGuide(
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
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
  });

  final String title;

  /// Markdown body.
  final String content;
  final String? summary;
  final String? domain;

  factory NavigatorGuideDetail.fromJson(Map<String, dynamic> json) {
    return NavigatorGuideDetail(
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      summary: json['summary'] as String?,
      domain: json['domain'] as String?,
    );
  }
}
