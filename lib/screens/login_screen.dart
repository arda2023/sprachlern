import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/auth_form.dart';

/// Email/password sign-in. On success the router's auth redirect moves on to
/// /home; this screen never navigates there itself.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: AuthForm(
          title: 'Anmelden',
          submitLabel: 'Anmelden',
          onSubmit: (email, password) async {
            await ref
                .read(authServiceProvider)
                .signIn(email: email, password: password);
            return null;
          },
          switchPrompt: 'Noch keinen Account?',
          switchLabel: 'Registrieren',
          onSwitch: () => context.go('/register'),
        ),
      ),
    );
  }
}
