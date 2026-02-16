import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/language_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/home/presentation/main_shell.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/tracker/presentation/tracker_screen.dart';
import '../../features/navigate/presentation/navigate_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import 'auth_provider.dart';
import 'locale_provider.dart';

/// Route paths as constants.
class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String tracker = '/tracker';
  static const String navigate = '/navigate';
  static const String profile = '/profile';
}

/// Navigation key for refreshing the router when auth state changes.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Provider for the GoRouter instance.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  // Watch locale to trigger router refresh on language change.
  ref.watch(localeProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.root,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isLoading = authState.isLoading;
      final hasSelectedLanguage = ref.read(localeProvider.notifier).hasSelectedLanguage;
      final currentPath = state.matchedLocation;

      // While auth is loading, don't redirect.
      if (isLoading) return null;

      // Public routes that don't require auth.
      final publicRoutes = [
        AppRoutes.root,
        AppRoutes.language,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.resetPassword,
      ];

      // If not logged in and trying to access a protected route, redirect to login.
      if (!isLoggedIn && !publicRoutes.contains(currentPath)) {
        return AppRoutes.login;
      }

      // If logged in and on a public auth route, redirect to home.
      if (isLoggedIn &&
          (currentPath == AppRoutes.login ||
           currentPath == AppRoutes.register ||
           currentPath == AppRoutes.root)) {
        return AppRoutes.home;
      }

      // Root route: if no language selected, go to language selection.
      if (currentPath == AppRoutes.root && !isLoggedIn) {
        if (!hasSelectedLanguage) {
          return AppRoutes.language;
        }
        return AppRoutes.login;
      }

      return null;
    },
    routes: [
      // Root redirect route
      GoRoute(
        path: AppRoutes.root,
        builder: (context, state) => const SizedBox.shrink(),
      ),

      // Language selection
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const LanguageScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),

      // Main shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.chat,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.tracker,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TrackerScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.navigate,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NavigateScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
