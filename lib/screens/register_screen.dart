import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/auth_form.dart';

/// Email/password sign-up. If the project signs the user in straight away,
/// the router's auth redirect moves on to /home.
class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: AuthForm(
          title: 'Registrieren',
          submitLabel: 'Registrieren',
          onSubmit: (email, password) async {
            final auth = ref.read(authServiceProvider);
            await auth.signUp(email: email, password: password);
            // With email confirmation on, sign-up yields no session and the
            // redirect does not fire — say what happens next instead.
            return auth.currentSession == null
                ? 'Fast geschafft: Bestätige deine E-Mail-Adresse über den '
                      'Link in deinem Postfach und melde dich dann an.'
                : null;
          },
          switchPrompt: 'Schon einen Account?',
          switchLabel: 'Anmelden',
          onSwitch: () => context.go('/login'),
        ),
      ),
    );
  }
}
