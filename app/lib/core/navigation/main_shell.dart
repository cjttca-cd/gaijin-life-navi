import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../providers/router_provider.dart';
import '../theme/app_colors.dart';

/// Main shell with 5-tab BottomNavigationBar.
///
/// Tabs: Home, Chat, Guide, SOS, Profile
/// Per DESIGN_SYSTEM.md §6.5.1 and §6.7:
///   - SOS tab icon is always [AppColors.error] (#DC2626).
///   - Active indicator uses [AppColors.primaryContainer].
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.chat,
    AppRoutes.navigate,
    '/emergency', // placeholder path for SOS tab
    AppRoutes.profile,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexOf(location);
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = _currentIndex(context);

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
            final target = _tabs[index];
            if (target == '/emergency') {
              // SOS tab — for now navigate to medical/emergency
              context.push(AppRoutes.medical);
              return;
            }
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
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l10n.tabProfile,
            ),
          ],
        ),
      ),
    );
  }
}
