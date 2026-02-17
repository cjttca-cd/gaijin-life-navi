import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import 'core/providers/locale_provider.dart';
import 'core/providers/router_provider.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: GaijinLifeNaviApp()));
}

/// Root application widget.
class GaijinLifeNaviApp extends ConsumerWidget {
  const GaijinLifeNaviApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Gaijin Life Navi',
      debugShowCheckedModeBanner: false,
      // Phase 0: Light theme only (DESIGN_SYSTEM.md §1.8).
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
