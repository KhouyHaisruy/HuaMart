import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/responsive.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/navigation/providers/navigation_provider.dart';
import 'features/navigation/widgets/app_shell.dart';

/// Root widget for HuaMart POS.
///
/// Bootstraps ScreenUtil against a 1280x800 tablet design canvas and shows
/// either the [LoginScreen] or the navigated [AppShell]. Because business
/// logic is intentionally out of scope, the Sign In button simply flips the
/// local UI-only session flag below (replaced later by a real auth provider).
class HuaMartPosApp extends ConsumerStatefulWidget {
  const HuaMartPosApp({super.key});

  @override
  ConsumerState<HuaMartPosApp> createState() => _HuaMartPosAppState();
}

class _HuaMartPosAppState extends ConsumerState<HuaMartPosApp> {
  /// Placeholder session state — replaced by a real auth provider later.
  bool _signedIn = false;

  void _signIn() {
    setState(() => _signedIn = true);
    ref.read(navIndexProvider.notifier).select(0); // land on POS Home
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenUtil.wrap(
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routes: AppRoutes.routes,
        home: _signedIn
            ? const AppShell()
            : LoginScreen(onLoginSuccess: _signIn),
      ),
    );
  }
}
