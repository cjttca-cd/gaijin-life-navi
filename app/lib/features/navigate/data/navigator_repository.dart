import 'package:dio/dio.dart';

import '../domain/navigator_domain.dart';

/// Repository for Navigator API calls.
class NavigatorRepository {
  const NavigatorRepository({required this.apiClient});

  final Dio apiClient;

  /// Fetch all navigator domains.
  ///
  /// [lang] — ISO 639-1 language code (e.g. ``zh``, ``ja``).
  /// When omitted the backend defaults to ``ja``.
  Future<List<NavigatorDomain>> getDomains({String? lang}) async {
    final response = await apiClient.get(
      '/navigator/domains',
      queryParameters: {if (lang != null) 'lang': lang},
    );
    final data = response.data['data'] as Map<String, dynamic>?;
    final domains = data?['domains'] as List<dynamic>? ?? [];
    return domains
        .map((e) => NavigatorDomain.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch guides for a specific domain.
  ///
  /// [lang] — ISO 639-1 language code.  Falls back to ``ja`` on the server
  /// when the requested language is unavailable.
  Future<List<NavigatorGuide>> getGuides(String domain, {String? lang}) async {
    final response = await apiClient.get(
      '/navigator/$domain/guides',
      queryParameters: {if (lang != null) 'lang': lang},
    );
    final data = response.data['data'] as Map<String, dynamic>?;
    final guides = data?['guides'] as List<dynamic>? ?? [];
    return guides
        .map((e) => NavigatorGuide.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch the status of a domain.
  Future<String> getDomainStatus(String domain) async {
    final response = await apiClient.get('/navigator/$domain/guides');
    final data = response.data['data'] as Map<String, dynamic>?;
    return data?['status'] as String? ?? 'active';
  }

  /// Fetch a single guide's detail.
  ///
  /// [lang] — ISO 639-1 language code.
  Future<NavigatorGuideDetail> getGuideDetail(
    String domain,
    String slug, {
    String? lang,
  }) async {
    final response = await apiClient.get(
      '/navigator/$domain/guides/$slug',
      queryParameters: {if (lang != null) 'lang': lang},
    );
    final data =
        response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return NavigatorGuideDetail.fromJson(data);
  }
}
