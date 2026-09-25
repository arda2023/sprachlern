import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/screens/exercise_screen.dart';

void main() {
  testWidgets(
    'Übung rendert, füllt die Lücke und schließt den Grammatikhinweis',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ExerciseScreen())),
      );

      expect(
        find.byKey(const ValueKey('exercise_blank_cursor')),
        findsOneWidget,
      );
      expect(find.text('call'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('exercise_blank')));
      await tester.pump();
      expect(find.byKey(const ValueKey('exercise_blank_cursor')), findsNothing);
      expect(find.text('call'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('grammar_hint_row')));
      await tester.pumpAndSettle();
      expect(find.text('Modalverb „could“'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('grammar_hint_close')));
      await tester.pumpAndSettle();
      expect(find.text('Modalverb „could“'), findsNothing);
    },
  );
}
