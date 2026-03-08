import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../config/app_config.dart';
import '../providers/auth_provider.dart';
import '../providers/router_provider.dart';
import '../theme/app_colors.dart';

/// Main shell with bottom navigation.
///
/// Tabs: Home, Chat, Guide, SOS, (Profile — hidden for anonymous TestFlight)
/// Per DESIGN_SYSTEM.md §6.5.1 and §6.7:
///   - SOS tab icon is always [AppColors.error] (#DC2626).
///   - Active indicator uses [AppColors.primaryContainer].
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _allTabs = [
    AppRoutes.home,
    AppRoutes.chat,
    AppRoutes.navigate,
    AppRoutes.emergency,
    AppRoutes.profile,
  ];

  /// In TestFlight mode, hide Profile tab for anonymous users.
  List<String> _visibleTabs(bool hideProfile) {
    if (hideProfile) {
      return _allTabs.where((t) => t != AppRoutes.profile).toList();
    }
    return _allTabs;
  }

  int _currentIndex(BuildContext context, List<String> tabs) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = tabs.indexOf(location);
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authStateProvider).valueOrNull;
    final hideProfile =
        AppConfig.testFlightMode && (user == null || user.isAnonymous);
    final tabs = _visibleTabs(hideProfile);
    final currentIndex = _currentIndex(context, tabs);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            final target = tabs[index];
            context.go(target);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.tabHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline),
              selectedIcon: const Icon(Icons.chat_bubble),
              label: l10n.tabChat,
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore),
              label: l10n.tabGuide,
            ),
            NavigationDestination(
              icon: const Icon(
                Icons.emergency_outlined,
                color: AppColors.error,
              ),
              selectedIcon: const Icon(Icons.emergency, color: AppColors.error),
              label: l10n.tabSOS,
            ),
            if (!hideProfile)
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: l10n.tabAccount,
              ),
          ],
        ),
      ),
    );
  }
}
