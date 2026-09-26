import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/diff_input_field.dart';

Widget _app({
  String targetAnswer = 'Fruit',
  bool isWrong = false,
  int attemptCount = 0,
  bool solutionRevealed = false,
  bool isCorrect = false,
  ValueChanged<String>? onChanged,
}) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: DiffInputField(
        targetAnswer: targetAnswer,
        isWrong: isWrong,
        attemptCount: attemptCount,
        solutionRevealed: solutionRevealed,
        isCorrect: isCorrect,
        onChanged: onChanged ?? (_) {},
      ),
    ),
  ),
);

Border _frame(WidgetTester tester) =>
    (tester
                    .widget<Container>(
                      find.byKey(const ValueKey('diff_input_frame')),
                    )
                    .decoration!
                as BoxDecoration)
            .border!
        as Border;

Text _textByKey(WidgetTester tester, String key) =>
    tester.widget<Text>(find.byKey(ValueKey(key)));

TextField _field(WidgetTester tester) => tester.widget<TextField>(
  find.byKey(const ValueKey('diff_input_text_field')),
);

final _dimmedError = AppColors.error.withValues(alpha: 0.4);
final _dimmedCyan = AppColors.cyan.withValues(alpha: 0.4);

void main() {
  testWidgets('Leeres Feld: nur Cursor, normaler Rand, keine Lösung', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    expect(find.byKey(const ValueKey('diff_input_cursor')), findsOneWidget);
    expect(find.byKey(const ValueKey('diff_input_solution')), findsNothing);
    expect(find.byKey(const ValueKey('diff_input_hint')), findsNothing);
    expect(find.text('Fruit'), findsNothing);
    // The 2 px frame is there but in the gap's own colour, so invisible.
    expect(_frame(tester).top.color, AppColors.field);
    expect(_frame(tester).top.width, 2);
  });

  testWidgets('Tippen ohne Bestätigung: cyan, normaler Rand, kein Vergleich', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.enterText(find.byType(TextField), 'Frut');
    await tester.pump();

    expect(_field(tester).style!.color, AppColors.cyan);
    expect(_frame(tester).top.color, AppColors.field);
    expect(find.byKey(const ValueKey('diff_input_cursor')), findsNothing);
    expect(find.byKey(const ValueKey('diff_input_hint')), findsNothing);
    expect(find.text('Fruit'), findsNothing);
  });

  testWidgets('Fall 3: erster Fehlversuch bei "Fruit" – roter Rand, "Fr...", Feld geleert', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.enterText(find.byType(TextField), 'Frut');
    await tester.pumpWidget(_app(isWrong: true, attemptCount: 1));

    expect(_frame(tester).top.color, AppColors.error);
    expect(_frame(tester).top.width, 2);
    // Feld wurde geleert: alte Eingabe steht nicht mehr drin
    expect(_field(tester).controller!.text, isEmpty);
    expect(find.text('Frut'), findsNothing);

    final hint = _textByKey(tester, 'diff_input_hint');
    expect(hint.data, 'Fr...');
    expect(hint.style!.color, _dimmedError);
  });

  testWidgets('Fall 4: ab dem zweiten Fehlversuch ganze Lösung "Fruit"', (
    tester,
  ) async {
    for (final attemptCount in [2, 3]) {
      await tester.pumpWidget(_app());
      await tester.enterText(find.byType(TextField), 'Frut');
      await tester.pumpWidget(_app(isWrong: true, attemptCount: attemptCount));

      expect(_frame(tester).top.color, AppColors.error);
      expect(_field(tester).controller!.text, isEmpty);
      expect(find.text('Frut'), findsNothing);
      final hint = _textByKey(tester, 'diff_input_hint');
      expect(hint.data, 'Fruit');
      expect(hint.style!.color, _dimmedError);
    }
  });

  testWidgets('Fall 5: Wort mit 2 Buchstaben – erster Hinweis nur "G..."', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(targetAnswer: 'Go'),
    );
    await tester.enterText(find.byType(TextField), 'Ga');
    await tester.pumpWidget(
      _app(targetAnswer: 'Go', isWrong: true, attemptCount: 1),
    );

    expect(_field(tester).controller!.text, isEmpty);
    expect(find.text('Ga'), findsNothing);
    expect(_textByKey(tester, 'diff_input_hint').data, 'G...');
  });

  testWidgets('Fall 5 Grenze: bei genau 3 Buchstaben zwei Zeichen', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(targetAnswer: 'cat'),
    );
    await tester.enterText(find.byType(TextField), 'cot');
    await tester.pumpWidget(
      _app(targetAnswer: 'cat', isWrong: true, attemptCount: 1),
    );

    expect(_field(tester).controller!.text, isEmpty);
    expect(find.text('cot'), findsNothing);
    expect(_textByKey(tester, 'diff_input_hint').data, 'ca...');
  });

  testWidgets('Weitertippen nach Fehlversuch: Hinweis verschwindet, Text ist cyan', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.enterText(find.byType(TextField), 'Frut');
    await tester.pumpWidget(_app(isWrong: true, attemptCount: 1));

    expect(_textByKey(tester, 'diff_input_hint').data, 'Fr...');
    expect(_field(tester).controller!.text, isEmpty);

    // Nutzer tippt direkt weiter in das geleerte Feld:
    await tester.enterText(find.byType(TextField), 'F');
    await tester.pump();

    expect(find.byKey(const ValueKey('diff_input_hint')), findsNothing);
    expect(_field(tester).controller!.text, 'F');
    expect(_field(tester).style!.color, AppColors.cyan);
  });

  testWidgets('Fall 1: Wort erfahren – Lösung gedimmt in Cyan, kein Rot', (
    tester,
  ) async {
    await tester.pumpWidget(_app(solutionRevealed: true));

    final solution = _textByKey(tester, 'diff_input_solution');
    expect(solution.data, 'Fruit');
    expect(solution.style!.color, _dimmedCyan);
    expect(_frame(tester).top.color, AppColors.field);
    expect(find.byKey(const ValueKey('diff_input_hint')), findsNothing);
    expect(find.byKey(const ValueKey('diff_input_cursor')), findsNothing);
    // Revealing does not fill the field; the learner types the word.
    expect(_field(tester).controller!.text, isEmpty);

    await tester.enterText(find.byType(TextField), 'F');
    await tester.pump();
    expect(find.byKey(const ValueKey('diff_input_solution')), findsNothing);
  });

  testWidgets('Richtige Eingabe: cyan, grüner Rand, Feld gesperrt', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.enterText(find.byType(TextField), 'Fruit');
    await tester.pumpWidget(_app(isCorrect: true));

    expect(_frame(tester).top.color, AppColors.success);
    expect(_field(tester).style!.color, AppColors.cyan);
    expect(_field(tester).readOnly, isTrue);
    expect(find.byKey(const ValueKey('diff_input_hint')), findsNothing);
  });

  testWidgets('onChanged meldet jede Änderung', (tester) async {
    final changes = <String>[];
    await tester.pumpWidget(_app(onChanged: changes.add));

    await tester.enterText(find.byType(TextField), 'F');
    await tester.enterText(find.byType(TextField), 'Fr');

    expect(changes, ['F', 'Fr']);
  });
}
