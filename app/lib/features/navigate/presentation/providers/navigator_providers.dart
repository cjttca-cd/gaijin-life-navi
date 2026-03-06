import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../data/emergency_repository.dart';
import '../../data/navigator_repository.dart';
import '../../domain/emergency_data.dart';
import '../../domain/navigator_domain.dart';

// ─── DI ──────────────────────────────────────────────────────

final _navigatorDioProvider = Provider<Dio>((ref) {
  return createApiClient();
});

final navigatorRepositoryProvider = Provider<NavigatorRepository>((ref) {
  return NavigatorRepository(apiClient: ref.watch(_navigatorDioProvider));
});

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return EmergencyRepository(apiClient: ref.watch(_navigatorDioProvider));
});

// ─── Helpers ─────────────────────────────────────────────────

/// Resolve the guide language from the user's locale selection.
/// Falls back to ``ja`` when no locale is explicitly set.
String _guideLang(ProviderRef ref) {
  final locale = ref.watch(localeProvider);
  return locale?.languageCode ?? 'ja';
}

// ─── Data Providers ──────────────────────────────────────────

/// All navigator domains (language-aware).
final navigatorDomainsProvider = FutureProvider<List<NavigatorDomain>>((
  ref,
) async {
  final repo = ref.watch(navigatorRepositoryProvider);
  return repo.getDomains(lang: _guideLang(ref));
});

/// Guides for a specific domain (language-aware).
final domainGuidesProvider =
    FutureProvider.family<List<NavigatorGuide>, String>((ref, domain) async {
      final repo = ref.watch(navigatorRepositoryProvider);
      return repo.getGuides(domain, lang: _guideLang(ref));
    });

/// Single guide detail (language-aware).
final guideDetailProvider =
    FutureProvider.family<NavigatorGuideDetail, ({String domain, String slug})>(
      (ref, params) async {
        final repo = ref.watch(navigatorRepositoryProvider);
        return repo.getGuideDetail(
          params.domain,
          params.slug,
          lang: _guideLang(ref),
        );
      },
    );

/// All guides across all active domains (for cross-domain search, language-aware).
final allGuidesProvider = FutureProvider<List<NavigatorGuide>>((ref) async {
  final repo = ref.watch(navigatorRepositoryProvider);
  final lang = _guideLang(ref);
  final domains = await ref.watch(navigatorDomainsProvider.future);
  final activeDomains = domains.where((d) => d.isActive).toList();

  final allGuides = <NavigatorGuide>[];
  for (final domain in activeDomains) {
    final guides = await repo.getGuides(domain.id, lang: lang);
    allGuides.addAll(guides.map((g) => g.withDomain(domain.id)));
  }
  return allGuides;
});

/// Emergency data from GET /api/v1/emergency.
final emergencyDataProvider = FutureProvider<EmergencyData>((ref) async {
  final repo = ref.watch(emergencyRepositoryProvider);
  return repo.getEmergency();
});
