import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/language_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/chat/presentation/chat_conversation_screen.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/navigate/presentation/emergency_screen.dart';
import '../../features/navigate/presentation/guide_detail_screen.dart';
import '../../features/navigate/presentation/guide_list_screen.dart';
import '../../features/navigate/presentation/navigate_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_edit_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/subscription/presentation/subscription_screen.dart';
import '../navigation/main_shell.dart';
import 'auth_provider.dart';
import 'locale_provider.dart';

/// Route paths as constants.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String root = '/';
  static const String language = '/language';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String chatConversation = '/chat/:id';
  static const String navigate = '/navigate';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String settings = '/settings';

  // Subscription
  static const String subscription = '/subscription';

  // Navigator (Guide) sub-routes
  static const String guideList = '/navigate/:domain';
  static const String guideDetail = '/navigate/:domain/:slug';

  // Emergency (SOS tab)
  static const String emergency = '/emergency';
}

/// Navigation key for refreshing the router when auth state changes.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Provider for the GoRouter instance.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  ref.watch(localeProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isLoading = authState.isLoading;
      final currentPath = state.matchedLocation;

      if (isLoading) return null;

      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.language,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.resetPassword,
        AppRoutes.emergency,
      ];

      if (!isLoggedIn && !publicRoutes.contains(currentPath)) {
        return AppRoutes.login;
      }

      if (isLoggedIn &&
          (currentPath == AppRoutes.login ||
              currentPath == AppRoutes.register)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Splash screen (S01).
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Language selection (S02).
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const LanguageScreen(),
      ),

      // Auth routes.
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

      // Onboarding (S06, full-screen).
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Chat conversation (full-screen, not in shell).
      GoRoute(
        path: AppRoutes.chatConversation,
        builder: (context, state) {
          final sessionId = state.pathParameters['id']!;
          return ChatConversationScreen(sessionId: sessionId);
        },
      ),

      // Navigator Guide List — domain guides.
      GoRoute(
        path: AppRoutes.guideList,
        builder: (context, state) {
          final domain = state.pathParameters['domain']!;
          return GuideListScreen(domain: domain);
        },
      ),

      // Navigator Guide Detail — single guide.
      GoRoute(
        path: AppRoutes.guideDetail,
        builder: (context, state) {
          final domain = state.pathParameters['domain']!;
          final slug = state.pathParameters['slug']!;
          return GuideDetailScreen(domain: domain, slug: slug);
        },
      ),

      // Subscription (full-screen).
      GoRoute(
        path: AppRoutes.subscription,
        builder: (context, state) => const SubscriptionScreen(),
      ),

      // Profile Edit (full-screen).
      GoRoute(
        path: AppRoutes.profileEdit,
        builder: (context, state) => const ProfileEditScreen(),
      ),

      // Settings (full-screen).
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Main shell with bottom navigation.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder:
                (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.chat,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ChatListScreen()),
          ),
          GoRoute(
            path: AppRoutes.navigate,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: NavigateScreen()),
          ),
          GoRoute(
            path: AppRoutes.emergency,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: EmergencyScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
});
