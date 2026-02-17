import 'package:dio/dio.dart';

import '../domain/navigator_domain.dart';

/// Repository for Navigator API calls.
class NavigatorRepository {
  const NavigatorRepository({required this.apiClient});

  final Dio apiClient;

  /// Fetch all navigator domains.
  Future<List<NavigatorDomain>> getDomains() async {
    final response = await apiClient.get('/navigator/domains');
    final data = response.data['data'] as Map<String, dynamic>?;
    final domains = data?['domains'] as List<dynamic>? ?? [];
    return domains
        .map((e) => NavigatorDomain.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch guides for a specific domain.
  Future<List<NavigatorGuide>> getGuides(String domain) async {
    final response = await apiClient.get('/navigator/$domain/guides');
    final data = response.data['data'] as Map<String, dynamic>?;
    final guides = data?['guides'] as List<dynamic>? ?? [];
    return guides
        .map((e) => NavigatorGuide.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch the status of a domain (active / coming_soon).
  Future<String> getDomainStatus(String domain) async {
    final response = await apiClient.get('/navigator/$domain/guides');
    final data = response.data['data'] as Map<String, dynamic>?;
    return data?['status'] as String? ?? 'active';
  }

  /// Fetch a single guide's detail.
  Future<NavigatorGuideDetail> getGuideDetail(
    String domain,
    String slug,
  ) async {
    final response = await apiClient.get('/navigator/$domain/guides/$slug');
    final data =
        response.data['data'] as Map<String, dynamic>? ??
        response.data as Map<String, dynamic>;
    return NavigatorGuideDetail.fromJson(data);
  }
}
