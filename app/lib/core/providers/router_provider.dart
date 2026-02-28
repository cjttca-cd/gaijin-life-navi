import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/language_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/chat/presentation/chat_conversation_screen.dart';
import '../../features/chat/presentation/chat_guest_screen.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/navigate/presentation/emergency_screen.dart';
import '../../features/navigate/presentation/guide_detail_screen.dart';
import '../../features/navigate/presentation/guide_list_screen.dart';
import '../../features/navigate/presentation/navigate_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/subscription/presentation/subscription_screen.dart';
import '../../features/tracker/presentation/tracker_screen.dart';
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
  static const String settings = '/settings';

  // Subscription
  static const String subscription = '/subscription';

  // Tracker
  static const String tracker = '/tracker';

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

      // Routes accessible without authentication (guest access).
      // Per BUSINESS_RULES.md §2 Access Boundary Matrix:
      //   - Home (limited), Navigator, Emergency, Subscription are public
      //   - Chat tab shows guest promotion screen (handled in widget)
      //   - Profile redirects to login
      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.language,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.resetPassword,
        AppRoutes.emergency,
        // Guest-accessible routes
        AppRoutes.home,
        AppRoutes.navigate,
        AppRoutes.chat, // Shows ChatGuestScreen for unauthenticated users
        AppRoutes.subscription,
      ];

      // Check exact match or path-prefix match for dynamic routes.
      final isPublicRoute =
          publicRoutes.contains(currentPath) ||
          currentPath.startsWith('/navigate/') ||
          currentPath.startsWith('/emergency');

      if (!isLoggedIn && !isPublicRoute) {
        return AppRoutes.login;
      }

      // Profile requires real auth (not anonymous)
      if (currentPath == AppRoutes.profile) {
        final user = authState.valueOrNull;
        if (user == null || user.isAnonymous) {
          return AppRoutes.login;
        }
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

      // Tracker (full-screen).
      GoRoute(
        path: AppRoutes.tracker,
        builder: (context, state) => const TrackerScreen(),
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
                    const NoTransitionPage(child: _ChatTabRouter()),
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

/// Routes the Chat tab: logged-in users (including anonymous) go to
/// [ChatListScreen]; unauthenticated users get anonymous auth first.
/// Per Plan C: guests get 5 lifetime chats via anonymous Firebase auth.
class _ChatTabRouter extends ConsumerWidget {
  const _ChatTabRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user != null) {
      // Logged in (real or anonymous) → chat list
      return const ChatListScreen();
    }
    // Not logged in → trigger anonymous auth
    return const _AnonymousAuthGate();
  }
}

/// Automatically signs in anonymously then shows [ChatListScreen].
class _AnonymousAuthGate extends ConsumerStatefulWidget {
  const _AnonymousAuthGate();

  @override
  ConsumerState<_AnonymousAuthGate> createState() => _AnonymousAuthGateState();
}

class _AnonymousAuthGateState extends ConsumerState<_AnonymousAuthGate> {
  bool _signingIn = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _doAnonymousSignIn();
  }

  Future<void> _doAnonymousSignIn() async {
    if (_signingIn) return;
    setState(() {
      _signingIn = true;
      _failed = false;
    });
    final auth = ref.read(firebaseAuthProvider);
    final user = await signInAnonymously(auth);
    if (mounted) {
      setState(() {
        _signingIn = false;
        _failed = user == null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If auth state has a user now (anonymous sign-in completed), show chat
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user != null) {
      return const ChatListScreen();
    }

    if (_failed) {
      // Fallback: show the guest promotion screen
      return const ChatGuestScreen();
    }

    // Loading state
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
