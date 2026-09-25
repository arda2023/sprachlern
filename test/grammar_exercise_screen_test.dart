import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('grammar_feedback_incorrect')),
      findsNothing,
    );
    _expectBorderColor(tester, 'grammar_option_0', AppColors.success);
  });
}

void _expectBorderColor(WidgetTester tester, String key, Color color) {
  final container = tester.widget<Container>(find.byKey(ValueKey(key)));
  final decoration = container.decoration! as BoxDecoration;
  final border = decoration.border! as Border;
  expect(border.top.color, color);
  expect(border.top.width, 2);
}
