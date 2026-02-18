import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
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

// ─── Data Providers ──────────────────────────────────────────

/// All navigator domains.
final navigatorDomainsProvider = FutureProvider<List<NavigatorDomain>>((
  ref,
) async {
  final repo = ref.watch(navigatorRepositoryProvider);
  return repo.getDomains();
});

/// Guides for a specific domain.
final domainGuidesProvider =
    FutureProvider.family<List<NavigatorGuide>, String>((ref, domain) async {
      final repo = ref.watch(navigatorRepositoryProvider);
      return repo.getGuides(domain);
    });

/// Single guide detail.
final guideDetailProvider =
    FutureProvider.family<NavigatorGuideDetail, ({String domain, String slug})>(
      (ref, params) async {
        final repo = ref.watch(navigatorRepositoryProvider);
        return repo.getGuideDetail(params.domain, params.slug);
      },
    );

/// All guides across all active domains (for cross-domain search).
final allGuidesProvider = FutureProvider<List<NavigatorGuide>>((ref) async {
  final repo = ref.watch(navigatorRepositoryProvider);
  final domains = await ref.watch(navigatorDomainsProvider.future);
  final activeDomains = domains.where((d) => d.isActive).toList();

  final allGuides = <NavigatorGuide>[];
  for (final domain in activeDomains) {
    final guides = await repo.getGuides(domain.id);
    allGuides.addAll(guides.map((g) => g.withDomain(domain.id)));
  }
  return allGuides;
});

/// Emergency data from GET /api/v1/emergency.
final emergencyDataProvider = FutureProvider<EmergencyData>((ref) async {
  final repo = ref.watch(emergencyRepositoryProvider);
  return repo.getEmergency();
});
