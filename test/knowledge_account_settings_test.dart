import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/screens/account_screen.dart';
import 'package:sprachlern/screens/knowledge_center_screen.dart';
import 'package:sprachlern/screens/settings_screen.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/account_list_row.dart';
import 'package:sprachlern/widgets/account_profile_row.dart';
import 'package:sprachlern/widgets/app_toggle.dart';
import 'package:sprachlern/widgets/knowledge_stat_row.dart';
import 'package:sprachlern/widgets/settings_toggle_row.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _pumpScreen(WidgetTester tester, Widget screen) async {
  _phoneSize(tester);
  await tester.pumpWidget(ProviderScope(child: MaterialApp(home: screen)));
  await tester.pumpAndSettle();
}

Color _dotColor(WidgetTester tester, String id) {
  final container = tester.widget<Container>(
    find.byKey(ValueKey('knowledge_dot_$id')),
  );
  return (container.decoration! as BoxDecoration).color!;
}

void main() {
  testWidgets('Wissenszentrum: 3 + 1 Zeilen mit den Punktfarben aus 5.6', (
    tester,
  ) async {
    await _pumpScreen(tester, const KnowledgeCenterScreen());

    expect(find.byType(KnowledgeStatRow), findsNWidgets(4));
    expect(
      find.byKey(const ValueKey('knowledge_illustration')),
      findsOneWidget,
    );

    expect(_dotColor(tester, 'total-words'), AppColors.cyan);
    expect(_dotColor(tester, 'known-words'), AppColors.cyan);
    expect(_dotColor(tester, 'words-to-learn'), AppColors.orange);
    expect(_dotColor(tester, 'learned-words'), AppColors.lilac);

    // German thousands separator (design.md 2).
    expect(find.text('1.456'), findsOneWidget);
  });

  testWidgets('Wissenszentrum: Zeilen-Tap öffnet Info-Sheet ohne Button', (
    tester,
  ) async {
    await _pumpScreen(tester, const KnowledgeCenterScreen());

    await tester.tap(find.byKey(const ValueKey('knowledge_stat_total-words')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('knowledge_stat_sheet_title')),
      findsOneWidget,
    );
    // Info sheet without a button: only the ✕ closes it (design.md 5.11).
    expect(find.byKey(const ValueKey('knowledge_stat_close')), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(ElevatedButton), findsNothing);

    await tester.tap(find.byKey(const ValueKey('knowledge_stat_close')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('knowledge_stat_sheet_title')),
      findsNothing,
    );
  });

  testWidgets('Konto: Profilzeilen, Liste, Version, Links und Abmelden', (
    tester,
  ) async {
    await _pumpScreen(tester, const AccountScreen());

    expect(find.byType(AccountProfileRow), findsNWidgets(2));
    expect(find.byType(AccountListRow), findsNWidgets(5));
    expect(find.text('Kontoeinstellungen'), findsOneWidget);
    expect(find.text('Testabo'), findsOneWidget);
    expect(find.byKey(const ValueKey('account_version')), findsOneWidget);
    expect(find.byKey(const ValueKey('account_sign_out')), findsOneWidget);

    // Placeholder address only — never data from the reference screenshots.
    expect(find.text('nutzer@beispiel.de'), findsOneWidget);

    // Red dot next to "Abonnement" (design.md 6).
    final dot = tester.widget<Container>(
      find.byKey(const ValueKey('account_dot_subscription')),
    );
    expect((dot.decoration! as BoxDecoration).color, AppColors.error);

    // Legal links in --blue-link (design.md 1.2).
    final link = tester.widget<Text>(find.text('Datenschutz'));
    expect(link.style!.color, AppColors.blueLink);
  });

  testWidgets('Konto: "Kontoeinstellungen" öffnet die Einstellungen', (
    tester,
  ) async {
    _phoneSize(tester);
    final router = GoRouter(
      initialLocation: '/account',
      routes: [
        GoRoute(path: '/account', builder: (_, _) => const AccountScreen()),
        GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('account_row_account-settings')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets(
    'Einstellungen: mindestens 5 Toggles, Zustand bleibt beim Zurückkehren',
    (tester) async {
      _phoneSize(tester);
      final router = GoRouter(
        initialLocation: '/account',
        routes: [
          GoRoute(path: '/account', builder: (_, _) => const AccountScreen()),
          GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('account_row_account-settings')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SettingsToggleRow), findsNWidgets(5));
      // The two inert value rows plus "Grammatiktabellen" (design.md 6).
      expect(find.text('Motiv'), findsOneWidget);
      expect(find.text('Automatisch'), findsOneWidget);
      expect(find.text('Grammatiktabellen'), findsOneWidget);

      bool isOn(String key) => tester
          .widget<AppToggle>(find.byKey(ValueKey('settings_toggle_$key')))
          .value;

      expect(isOn('muted'), isFalse);
      expect(isOn('autoAdvance'), isFalse);
      expect(isOn('notifications'), isTrue);

      // Each toggle flips on its own.
      await tester.tap(find.byKey(const ValueKey('settings_toggle_muted')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('settings_toggle_autoAdvance')),
      );
      await tester.pumpAndSettle();
      expect(isOn('muted'), isTrue);
      expect(isOn('autoAdvance'), isTrue);
      expect(isOn('notifications'), isTrue);

      // Leaving and re-entering the screen keeps the state of the session.
      await tester.tap(find.byTooltip('Zurück zum Konto'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('account_row_account-settings')),
      );
      await tester.pumpAndSettle();
      expect(isOn('muted'), isTrue);
      expect(isOn('autoAdvance'), isTrue);
      expect(isOn('notifications'), isTrue);
    },
  );
}
