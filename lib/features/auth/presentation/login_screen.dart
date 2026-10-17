import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';

/// Local UI-only state for the login form (no auth logic yet).
class LoginFormState {
  const LoginFormState({this.username = '', this.pin = '', this.remember = true});

  final String username;
  final String pin;
  final bool remember;

  LoginFormState copyWith({String? username, String? pin, bool? remember}) {
    return LoginFormState(
      username: username ?? this.username,
      pin: pin ?? this.pin,
      remember: remember ?? this.remember,
    );
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(const LoginFormState());

  void setUsername(String value) => state = state.copyWith(username: value);
  void setPin(String value) => state = state.copyWith(pin: value);
  void setRemember(bool value) => state = state.copyWith(remember: value);

  /// Placeholder — real authentication arrives in a later iteration.
  void submit() {}
}

final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>(
  (ref) => LoginFormNotifier(),
);

/// Login screen: branded split layout sized for 1280x800 tablet POS devices.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key, this.onLoginSuccess});

  /// Called when the user taps Sign In. Wiring real auth is out of scope.
  final VoidCallback? onLoginSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(loginFormProvider);
    final notifier = ref.read(loginFormProvider.notifier);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final branding = const _LoginBranding();
    final card = _LoginCard(
      form: form,
      notifier: notifier,
      onSubmit: onLoginSuccess ?? () {},
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isWide
            ? Row(
                children: [
                  const Expanded(flex: 5, child: branding),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 460.w),
                        child: Padding(
                          padding: Spacing.page,
                          child: card,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: SingleChildScrollView(
                  padding: Spacing.page,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 460.w),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        branding,
                        SizedBox(height: Spacing.xl),
                        card,
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

/// Left-hand brand panel.
class _LoginBranding extends StatelessWidget {
  const _LoginBranding();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: Padding(
        padding: Spacing.page,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.storefront_rounded,
                size: 72.r, color: AppColors.textOnPrimary),
            SizedBox(height: Spacing.lg),
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textOnPrimary,
              ),
            ),
            SizedBox(height: Spacing.sm),
            Text(
              'Fast, reliable point of sale\nfor your store.',
              style: TextStyle(
                fontSize: 16.sp,
                height: 1.5,
                color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Username / PIN form card.
class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.form,
    required this.notifier,
    required this.onSubmit,
  });

  final LoginFormState form;
  final LoginFormNotifier notifier;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: Spacing.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: Spacing.xs),
            Text(
              'Sign in to continue selling.',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: Spacing.lg),
            TextField(
              onChanged: notifier.setUsername,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon:
                    Icon(Icons.person_outline, size: Spacing.iconMd),
              ),
            ),
            SizedBox(height: Spacing.formItemGap.bottom),
            TextField(
              onChanged: notifier.setPin,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'PIN',
                prefixIcon: Icon(Icons.lock_outline, size: Spacing.iconMd),
              ),
            ),
            SizedBox(height: Spacing.sm),
            Row(
              children: [
                Checkbox(
                  value: form.remember,
                  onChanged: (v) => notifier.setRemember(v ?? false),
                ),
                Text(
                  'Remember me',
                  style:
                      TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
            SizedBox(height: Spacing.md),
            SizedBox(
              height: Spacing.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: onSubmit,
                icon: Icon(Icons.login_rounded, size: Spacing.iconMd),
                label: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: Spacing.md),
            TextButton(
              onPressed: () {}, // password reset — future iteration
              child: Text(
                'Forgot PIN?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
