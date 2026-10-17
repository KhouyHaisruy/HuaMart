import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/navigation/widgets/app_shell.dart';

/// Named routes for HuaMart POS.
///
/// The [AppShell] owns in-place navigation between the six primary
/// destinations (standard for POS devices); these routes exist so the app can
/// be deep-linked or tested screen-by-screen without the shell.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String shell = '/';

  static Map<String, WidgetBuilder> get routes => <String, WidgetBuilder>{
        login: (_) => const LoginScreen(),
        shell: (_) => const AppShell(),
      };
}
