import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/main.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/router/app_router.dart';
import 'package:sprachlern/screens/home_screen.dart';
import 'package:sprachlern/screens/login_screen.dart';
import 'package:sprachlern/screens/register_screen.dart';
import 'package:sprachlern/screens/settings_screen.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'helpers/fake_auth_service.dart';

/// Pumps the whole app — real router and redirect — on a fake auth service.
Future<ProviderContainer> _pumpApp(
  WidgetTester tester,
  FakeAuthService auth,
) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [authServiceProvider.overrideWithValue(auth)],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const MyApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

Future<void> _fillForm(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const ValueKey('auth_email')),
    'nutzer@beispiel.de',
  );
  await tester.enterText(
    find.byKey(const ValueKey('auth_password')),
    'geheim123',
  );
  await tester.pump();
}

double _submitOpacity(WidgetTester tester) => tester
    .widget<Opacity>(
      find.ancestor(
        of: find.byKey(const ValueKey('auth_submit')),
        matching: find.byType(Opacity),
      ),
    )
    .opacity;

void main() {
  testWidgets('Ohne Session: Start auf /login, andere Routen leiten dorthin', (
    tester,
  ) async {
    final container = await _pumpApp(tester, FakeAuthService());
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_0')), findsNothing);

    container.read(routerProvider).go('/settings');
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);

    // /register stays reachable without a session, and links back.
    await tester.tap(find.byKey(const ValueKey('auth_switch')));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('auth_switch')));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Login: Ladezustand während des Aufrufs, danach /home', (
    tester,
  ) async {
    final auth = FakeAuthService()..pendingAuthCall = Completer<void>();
    await _pumpApp(tester, auth);

    // Disabled (40 %, design.md 5.12) until both fields are filled.
    expect(_submitOpacity(tester), 0.4);
    await _fillForm(tester);
    expect(_submitOpacity(tester), 1);

    await tester.tap(find.byKey(const ValueKey('auth_submit')));
    await tester.pump();
    expect(find.byKey(const ValueKey('auth_loading')), findsOneWidget);
    expect(find.text('Anmelden'), findsOneWidget, reason: 'label swapped out');
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('auth_email')))
          .enabled,
      isFalse,
    );

    auth.pendingAuthCall!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_0')), findsOneWidget);
  });

  testWidgets('Login: falsches Passwort zeigt Fehlermeldung ohne Absturz', (
    tester,
  ) async {
    final auth = FakeAuthService()
      ..signInError = const AuthException(
        'Invalid login credentials',
        statusCode: '400',
      );
    await _pumpApp(tester, auth);

    await _fillForm(tester);
    await tester.tap(find.byKey(const ValueKey('auth_submit')));
    await tester.pumpAndSettle();

    final error = tester.widget<Text>(find.byKey(const ValueKey('auth_error')));
    expect(error.data, 'Invalid login credentials');
    expect(error.style!.color, AppColors.error);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('auth_loading')), findsNothing);
    expect(_submitOpacity(tester), 1, reason: 'retry possible');
  });

  testWidgets('Registrieren mit sofortiger Session führt zu /home', (
    tester,
  ) async {
    final container = await _pumpApp(tester, FakeAuthService());
    container.read(routerProvider).go('/register');
    await tester.pumpAndSettle();

    await _fillForm(tester);
    await tester.tap(find.byKey(const ValueKey('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Registrieren mit E-Mail-Bestätigung zeigt einen Hinweis', (
    tester,
  ) async {
    final auth = FakeAuthService()..signUpNeedsConfirmation = true;
    final container = await _pumpApp(tester, auth);
    container.read(routerProvider).go('/register');
    await tester.pumpAndSettle();

    await _fillForm(tester);
    await tester.tap(find.byKey(const ValueKey('auth_submit')));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('auth_info')), findsOneWidget);
    expect(find.byKey(const ValueKey('auth_error')), findsNothing);
  });

  testWidgets('Angemeldet: /login leitet um, "Abmelden" führt zu /login', (
    tester,
  ) async {
    final auth = FakeAuthService(signedIn: true);
    final container = await _pumpApp(tester, auth);
    expect(find.byType(HomeScreen), findsOneWidget);

    final router = container.read(routerProvider);
    router.go('/login');
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);

    router.go('/account');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('account_sign_out')));
    await tester.pumpAndSettle();

    expect(auth.signOutCalls, 1);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_0')), findsNothing);
  });
}
