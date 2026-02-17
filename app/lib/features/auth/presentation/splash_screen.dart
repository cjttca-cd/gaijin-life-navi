import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/router_provider.dart';
import '../../../core/theme/app_spacing.dart';

/// Splash screen (S01) — DESIGN_SYSTEM.md §8.1.
///
/// Full-screen [colorPrimary] background with logo, app name and spinner.
/// After 2 s, navigates based on auth / language / onboarding state.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait at least 2 seconds (handoff-auth S01 spec).
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authState = ref.read(authStateProvider);
    final hasLanguage = ref.read(localeProvider.notifier).hasSelectedLanguage;
    final isLoggedIn = authState.valueOrNull != null;

    if (!mounted) return;

    if (!hasLanguage) {
      context.go(AppRoutes.language);
    } else if (!isLoggedIn) {
      context.go(AppRoutes.login);
    } else {
      // Logged in — go to home (onboarding redirect handled by router).
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            // Logo icon — §8.1.
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.explore, size: 48, color: cs.onPrimary),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            // App name — displayLarge, white.
            Text(
              'Gaijin Life Navi',
              style: tt.displayLarge?.copyWith(color: cs.onPrimary),
            ),
            const Spacer(flex: 2),
            // Spinner.
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: cs.onPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.space5xl),
          ],
        ),
      ),
    );
  }
}
