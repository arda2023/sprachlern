import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/models/exercise_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/fill_in_card.dart';

Widget _appWithIndicator(int status) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: StatusIndicator(status: status),
    ),
  ),
);

Widget _appWithCard(int status) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: FillInCard(
        exercise: ExerciseData(
          tokens: const [
            ExerciseToken(text: 'Fruit', isBlank: true),
            ExerciseToken(text: 'is healthy.'),
          ],
          wordStatus: status,
          targetAnswer: 'Fruit',
          germanHeadword: 'Obst',
          germanExampleSentence: 'Obst ist gesund.',
          currentCard: 1,
          totalCards: 5,
          grammarHintTitle: 'Nomen',
          grammarHintDescription: 'Substantiv',
        ),
        isWrong: false,
        attemptCount: 0,
        solutionRevealed: false,
        isCorrect: false,
        onAnswerChanged: (_) {},
        onAnswerSubmitted: (_) {},
        onGrammarHintTap: () {},
      ),
    ),
  ),
);

Color _segmentColor(WidgetTester tester, int index) {
  final container = tester.widget<Container>(
    find.byKey(ValueKey('status_segment_$index')),
  );
  return (container.decoration! as BoxDecoration).color!;
}

void main() {
  group('Status-Indikator (design.md 5.19)', () {
    testWidgets(
      'Stufe 1: status=1 -> erstes Segment AppColors.orange, restliche AppColors.surface2',
      (tester) async {
        await tester.pumpWidget(_appWithIndicator(1));

        expect(_segmentColor(tester, 0), AppColors.orange);
        expect(_segmentColor(tester, 1), AppColors.surface2);
        expect(_segmentColor(tester, 2), AppColors.surface2);
        expect(_segmentColor(tester, 3), AppColors.surface2);
        expect(_segmentColor(tester, 4), AppColors.surface2);
        expect(find.text('Neues Wort'), findsOneWidget);
      },
    );

    testWidgets(
      'Stufe 3: status=3 -> erste drei Segmente AppColors.cyan, restliche AppColors.surface2',
      (tester) async {
        await tester.pumpWidget(_appWithIndicator(3));

        expect(_segmentColor(tester, 0), AppColors.cyan);
        expect(_segmentColor(tester, 1), AppColors.cyan);
        expect(_segmentColor(tester, 2), AppColors.cyan);
        expect(_segmentColor(tester, 3), AppColors.surface2);
        expect(_segmentColor(tester, 4), AppColors.surface2);
        expect(find.text('Neues Wort'), findsNothing);
      },
    );

    testWidgets(
      'Stufe 5: status=5 -> alle fünf Segmente AppColors.success',
      (tester) async {
        await tester.pumpWidget(_appWithIndicator(5));

        expect(_segmentColor(tester, 0), AppColors.success);
        expect(_segmentColor(tester, 1), AppColors.success);
        expect(_segmentColor(tester, 2), AppColors.success);
        expect(_segmentColor(tester, 3), AppColors.success);
        expect(_segmentColor(tester, 4), AppColors.success);
        expect(find.text('Neues Wort'), findsNothing);
      },
    );

    testWidgets(
      'Stufe 0: status=0 -> alle Segmente AppColors.surface2, "Neues Wort"-Label sichtbar',
      (tester) async {
        await tester.pumpWidget(_appWithIndicator(0));

        expect(_segmentColor(tester, 0), AppColors.surface2);
        expect(_segmentColor(tester, 1), AppColors.surface2);
        expect(_segmentColor(tester, 2), AppColors.surface2);
        expect(_segmentColor(tester, 3), AppColors.surface2);
        expect(_segmentColor(tester, 4), AppColors.surface2);
        expect(find.text('Neues Wort'), findsOneWidget);
      },
    );

    testWidgets(
      'Stufen 2 und 4: cyan gefüllte Segmente, kein "Neues Wort"',
      (tester) async {
        await tester.pumpWidget(_appWithIndicator(2));
        expect(_segmentColor(tester, 0), AppColors.cyan);
        expect(_segmentColor(tester, 1), AppColors.cyan);
        expect(_segmentColor(tester, 2), AppColors.surface2);
        expect(find.text('Neues Wort'), findsNothing);

        await tester.pumpWidget(_appWithIndicator(4));
        expect(_segmentColor(tester, 0), AppColors.cyan);
        expect(_segmentColor(tester, 1), AppColors.cyan);
        expect(_segmentColor(tester, 2), AppColors.cyan);
        expect(_segmentColor(tester, 3), AppColors.cyan);
        expect(_segmentColor(tester, 4), AppColors.surface2);
        expect(find.text('Neues Wort'), findsNothing);
      },
    );

    testWidgets(
      'FillInCard integriert Status-Indikator korrekt',
      (tester) async {
        await tester.pumpWidget(_appWithCard(3));

        expect(_segmentColor(tester, 0), AppColors.cyan);
        expect(_segmentColor(tester, 1), AppColors.cyan);
        expect(_segmentColor(tester, 2), AppColors.cyan);
        expect(_segmentColor(tester, 3), AppColors.surface2);
        expect(_segmentColor(tester, 4), AppColors.surface2);
        expect(find.text('Neues Wort'), findsNothing);
      },
    );
  });
}
