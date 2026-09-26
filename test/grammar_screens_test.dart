import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/grammar_exercise_provider.dart';
import 'package:sprachlern/providers/settings_provider.dart';
import 'package:sprachlern/screens/grammar_exercise_screen.dart';
import 'package:sprachlern/screens/grammar_explanation_screen.dart';
import 'package:sprachlern/screens/grammar_list_screen.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/grammar_topic_row.dart';

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

void main() {
  testWidgets('Grammatik: Tabs filtern offene und fertige Übungen', (
    tester,
  ) async {
    await _pumpScreen(tester, const GrammarListScreen());

    // "Meine Übungen": only the three open rows.
    expect(find.byType(GrammarTopicRow), findsNWidgets(3));
    expect(find.text('Adjektiv oder Adverb'), findsOneWidget);
    expect(find.text('Artikel: a, an, the'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('grammar_tab_1')));
    await tester.pumpAndSettle();

    // "Fertig": the three completed rows, and none of the open ones.
    expect(find.byType(GrammarTopicRow), findsNWidgets(3));
    expect(find.text('Artikel: a, an, the'), findsOneWidget);
    expect(find.text('Adjektiv oder Adverb'), findsNothing);
  });

  testWidgets('Grammatikhinweise: Niveau-Tab öffnet die helle Erklärung', (
    tester,
  ) async {
    _phoneSize(tester);
    final router = GoRouter(
      initialLocation: '/grammar-topics',
      routes: [
        GoRoute(
          path: '/grammar-topics',
          builder: (_, _) => const GrammarExplanationScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) => GrammarExplanationDetailScreen(
                topicId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    // Level 1 ("Anfänger") holds two topics, level 2 different ones.
    expect(find.text('Wochentage'), findsOneWidget);
    expect(find.text('Modalverben'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('grammar_level_tab_1')));
    await tester.pumpAndSettle();
    expect(find.text('Wochentage'), findsNothing);
    expect(find.text('Modalverben'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('grammar_hint_modalverben')));
    await tester.pumpAndSettle();

    // Light theme, this topic's table rows and its "Achtung!" box.
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).last);
    expect(scaffold.backgroundColor, AppColors.lightBg);
    expect(find.text('can'), findsOneWidget);
    expect(find.text('können'), findsOneWidget);
    expect(find.text('should'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('grammar_warning_heading')),
      findsOneWidget,
    );

    final box = tester.widget<Container>(
      find.byKey(const ValueKey('grammar_warning_box')),
    );
    final border = (box.decoration! as BoxDecoration).border! as Border;
    expect(border.top.color, AppColors.lightBorder);
    expect(border.top.width, 1);
  });

  testWidgets(
    'Grammatik-Übung: Auto-Weiter nur bei aktivem Toggle, sonst per Tap',
    (tester) async {
      _phoneSize(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: GrammarExerciseScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Toggle off by default: the card stays put after a correct answer.
      expect(
        find.text('We went through the ___ check together.'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('grammar_option_0')));
      await tester.pump(GrammarExerciseNotifier.autoAdvanceDelay * 3);
      expect(
        find.text('We went through the final check together.'),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('grammar_feedback_correct')),
        findsOneWidget,
      );

      // The explicit "Weiter" link moves on to the next mock card.
      await tester.tap(find.byKey(const ValueKey('grammar_next_card')));
      await tester.pumpAndSettle();
      expect(
        find.text('She ___ the report before the meeting.'),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('grammar_next_card')), findsNothing);

      // Toggle on: "Weiter" remains available during feedback, then the card
      // advances by itself.
      container.read(settingsProvider.notifier).toggle('autoAdvance');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('grammar_option_0')));
      await tester.pump();
      expect(find.byKey(const ValueKey('grammar_next_card')), findsOneWidget);
      await tester.pump(GrammarExerciseNotifier.autoAdvanceDelay);
      await tester.pumpAndSettle();
      expect(find.text('They have lived here ___ 2019.'), findsOneWidget);
    },
  );

  testWidgets('Grammatik-Übung: lila Fortschrittsfüllung hat eine Höhe', (
    tester,
  ) async {
    await _pumpScreen(tester, const GrammarExerciseScreen());

    final fill = tester.getRect(
      find.byKey(const ValueKey('grammar_progress_fill')),
    );
    expect(fill.height, greaterThan(0));
    expect(fill.width, greaterThan(0));
  });
}
