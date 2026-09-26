import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/providers/grammar_exercise_provider.dart';
import 'package:sprachlern/screens/grammar_exercise_screen.dart';
import 'package:sprachlern/theme/app_colors.dart';

void main() {
  testWidgets('Grammatikübung zeigt nur für die Auswahl ein Feedback', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: GrammarExerciseScreen())),
    );

    await tester.tap(find.byKey(const ValueKey('grammar_option_1')));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('grammar_feedback_incorrect')),
      findsOneWidget,
    );
    _expectBorderColor(tester, 'grammar_option_1', AppColors.error);
    expect(
      tester
          .widget<Container>(find.byKey(const ValueKey('grammar_option_0')))
          .decoration,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('grammar_option_0')));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('grammar_feedback_correct')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('grammar_feedback_incorrect')),
      findsOneWidget,
    );
    _expectBorderColor(tester, 'grammar_option_1', AppColors.error);
  });

  testWidgets('richtige Auswahl füllt die Satzlücke', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: GrammarExerciseScreen())),
    );

    expect(
      find.text('We went through the ___ check together.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('grammar_option_0')));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('grammar_feedback_correct')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('grammar_feedback_incorrect')),
      findsNothing,
    );
    _expectBorderColor(tester, 'grammar_option_0', AppColors.success);
    expect(
      find.text('We went through the final check together.'),
      findsOneWidget,
    );
    expect(find.text('We went through the ___ check together.'), findsNothing);
  });

  testWidgets('erste Auswahl füllt die Lücke und sperrt weitere Taps', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: GrammarExerciseScreen()),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('grammar_option_1')));
    await tester.pump();
    expect(
      find.text('We went through the final check together.'),
      findsOneWidget,
    );
    expect(container.read(grammarExerciseProvider).selectedOptionIndex, 1);

    await tester.tap(find.byKey(const ValueKey('grammar_option_0')));
    await tester.pump();

    expect(container.read(grammarExerciseProvider).selectedOptionIndex, 1);
    expect(
      find.text('We went through the final check together.'),
      findsOneWidget,
    );
  });

  testWidgets('falsche Auswahl setzt die richtige Lösung in die Lücke', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: GrammarExerciseScreen())),
    );

    await tester.tap(find.byKey(const ValueKey('grammar_option_1')));
    await tester.pump();

    expect(
      find.text('We went through the final check together.'),
      findsOneWidget,
    );
    expect(
      find.text('We went through the finally check together.'),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('grammar_feedback_incorrect')),
      findsOneWidget,
    );
  });

  testWidgets(
    'Weiter erscheint nach falscher Auswahl und entsperrt neue Karte',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: GrammarExerciseScreen()),
        ),
      );

      expect(find.byKey(const ValueKey('grammar_next_card')), findsNothing);
      await tester.tap(find.byKey(const ValueKey('grammar_option_1')));
      await tester.pump();
      expect(find.byKey(const ValueKey('grammar_next_card')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('grammar_next_card')));
      await tester.pump();
      expect(
        find.text('She ___ the report before the meeting.'),
        findsOneWidget,
      );
      expect(
        container.read(grammarExerciseProvider).selectedOptionIndex,
        isNull,
      );
      expect(find.byKey(const ValueKey('grammar_next_card')), findsNothing);

      await tester.tap(find.byKey(const ValueKey('grammar_option_1')));
      await tester.pump();
      expect(container.read(grammarExerciseProvider).selectedOptionIndex, 1);
    },
  );
}

void _expectBorderColor(WidgetTester tester, String key, Color color) {
  final container = tester.widget<Container>(find.byKey(ValueKey(key)));
  final decoration = container.decoration! as BoxDecoration;
  final border = decoration.border! as Border;
  expect(border.top.color, color);
  expect(border.top.width, 2);
}
