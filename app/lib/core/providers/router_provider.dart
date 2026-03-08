import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/language_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/chat/presentation/chat_conversation_screen.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../config/app_config.dart';
import '../../features/chat/presentation/widgets/trial_setup_dialog.dart';
import '../../features/profile/presentation/providers/profile_providers.dart';
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

      // Profile: unauthenticated → login (production) or /chat (TestFlight).
      // Anonymous users (TestFlight) can access the simplified profile view.
      if (currentPath == AppRoutes.profile) {
        final user = authState.valueOrNull;
        if (user == null) {
          return AppConfig.testFlightMode ? AppRoutes.chat : AppRoutes.login;
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
///
/// In TestFlight mode, anonymous users without a profile see a
/// [TrialSetupDialog] before accessing the chat list.
class _ChatTabRouter extends ConsumerWidget {
  const _ChatTabRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user != null) {
      // Logged in (real or anonymous) → chat list (with trial gate)
      return const _TrialSetupGate();
    }
    // Not logged in → trigger anonymous auth
    return const _AnonymousAuthGate();
  }
}

/// Gate that checks if a TestFlight anonymous user needs trial setup.
///
/// If [AppConfig.testFlightMode] is true, user is anonymous, and their
/// profile has no nationality set, a non-dismissible [TrialSetupDialog]
/// is shown before they can access the chat list.
class _TrialSetupGate extends ConsumerStatefulWidget {
  const _TrialSetupGate();

  @override
  ConsumerState<_TrialSetupGate> createState() => _TrialSetupGateState();
}

class _TrialSetupGateState extends ConsumerState<_TrialSetupGate> {
  bool _dialogShown = false;
  bool _setupComplete = false;

  @override
  Widget build(BuildContext context) {
    // Skip gate for non-TestFlight or non-anonymous users.
    if (!AppConfig.testFlightMode || !ref.watch(isAnonymousProvider)) {
      return const ChatListScreen();
    }

    // If setup is already complete (dialog returned true), show chat.
    if (_setupComplete) {
      return const ChatListScreen();
    }

    // Watch profile to check if nationality is already set.
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) {
        // Profile fetch failed — show dialog anyway.
        _showDialogOnce();
        return const ChatListScreen();
      },
      data: (profile) {
        if (profile.nationality != null && profile.nationality!.isNotEmpty) {
          // Already set up — go straight to chat.
          return const ChatListScreen();
        }
        // Need setup — show dialog.
        _showDialogOnce();
        return const Scaffold(
            body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  void _showDialogOnce() {
    if (_dialogShown) return;
    _dialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final success = await TrialSetupDialog.show(context);
      if (mounted) {
        setState(() => _setupComplete = success);
      }
    });
  }
}

/// Mark trial setup as completed (persists in SharedPreferences).
/// Called from TrialSetupDialog after successful setup.
Future<void> markTrialSetupComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('trial_setup_done', true);
}

/// Automatically signs in anonymously then shows [_TrialSetupGate].
class _AnonymousAuthGate extends ConsumerStatefulWidget {
  const _AnonymousAuthGate();

  @override
  ConsumerState<_AnonymousAuthGate> createState() => _AnonymousAuthGateState();
}

class _AnonymousAuthGateState extends ConsumerState<_AnonymousAuthGate> {
  bool _signingIn = false;
  bool _failed = false;
  bool _dialogShown = false;
  bool _checkingLocal = true; // checking SharedPreferences



  @override
  void initState() {
    super.initState();
    if (AppConfig.testFlightMode) {
      // TestFlight: check if user has completed trial setup before
      _checkReturningUser();
    } else {
      // Production: auto sign-in immediately
      _checkingLocal = false;
      _doAnonymousSignIn();
    }
  }

  /// Check SharedPreferences for returning anonymous users.
  /// If trial was completed before → auto sign-in silently.
  /// If first time → show dialog.
  Future<void> _checkReturningUser() async {
    final prefs = await SharedPreferences.getInstance();
    final hasDoneTrial = prefs.getBool('trial_setup_done') ?? false;
    if (!mounted) return;

    if (hasDoneTrial) {
      // Returning user → auto sign-in, no dialog
      setState(() => _checkingLocal = false);
      _doAnonymousSignIn();
    } else {
      // First time → show dialog
      setState(() => _checkingLocal = false);
    }
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // If auth state has a user now (anonymous sign-in completed), show chat
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user != null) {
      return const _TrialSetupGate();
    }

    // Still checking SharedPreferences or signing in
    if (_checkingLocal || _signingIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_failed) {
      return const ChatGuestScreen();
    }

    // TestFlight first-time user: show setup prompt
    if (AppConfig.testFlightMode) {
      if (!_dialogShown) {
        _dialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showSetupDialog();
        });
      }

      return Scaffold(
        appBar: AppBar(title: Text(l10n.chatTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.smart_toy_outlined, size: 64,
                    color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  l10n.testFlightChatSetupPrompt,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _showSetupDialog,
                  icon: const Icon(Icons.tune),
                  label: Text(l10n.testFlightChatSetupButton),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Production: loading state
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  void _showSetupDialog() {
    TrialSetupDialog.show(context, signInFirst: true);
    // After dialog, auth state may update → widget rebuilds
  }
}
