import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/diff_input_field.dart';

void main() {
  for (final attemptFailed in [false, true]) {
    testWidgets('empty input: attemptFailed=$attemptFailed shows only cursor', (
      tester,
    ) async {
      await tester.pumpWidget(_app(attemptFailed: attemptFailed));

      expect(
        find.byKey(const ValueKey('diff_input_text_field')),
        findsOneWidget,
      );
      expect(find.text('call'), findsNothing);
      expect(find.byKey(const ValueKey('diff_input_cursor')), findsOneWidget);
      expect(find.byKey(const ValueKey('diff_input_overlay')), findsNothing);
    });
  }

  testWidgets('first attempt: wrong input is cyan without solution or red', (
    tester,
  ) async {
    await tester.pumpWidget(_app(targetAnswer: 'understood'));
    await tester.enterText(find.byType(TextField), 'understandd');
    await tester.pump();

    expect(_overlayText(tester), 'understandd');
    expect(_overlayColors(tester), everyElement(AppColors.cyan));
    expect(find.text('understood', findRichText: true), findsNothing);
  });

  testWidgets(
    'failed attempt: understandd has red edits and dimmed understood',
    (tester) async {
      await tester.pumpWidget(
        _app(targetAnswer: 'understood', attemptFailed: true),
      );
      await tester.enterText(find.byType(TextField), 'understandd');
      await tester.pump();

      expect(_overlayText(tester), 'understanddunderstood');
      final colors = _overlayColors(tester);
      expect(colors.take(7), everyElement(AppColors.cyan));
      expect(colors[7], AppColors.error);
      expect(colors[8], AppColors.error);
      expect(colors[9], AppColors.cyan);
      expect(colors[10], AppColors.error);
      expect(
        colors.skip(11),
        everyElement(AppColors.cyan.withValues(alpha: 0.4)),
      );
    },
  );

  testWidgets(
    'failed attempt: understoood insertion is cyan without solution',
    (tester) async {
      await tester.pumpWidget(
        _app(targetAnswer: 'understood', attemptFailed: true),
      );
      await tester.enterText(find.byType(TextField), 'understoood');
      await tester.pump();

      expect(_overlayText(tester), 'understoood');
      expect(_overlayColors(tester), everyElement(AppColors.cyan));
    },
  );

  testWidgets('failed attempt: exact understood is cyan without solution', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(targetAnswer: 'understood', attemptFailed: true),
    );
    await tester.enterText(find.byType(TextField), 'understood');
    await tester.pump();

    expect(_overlayText(tester), 'understood');
    expect(_overlayColors(tester), everyElement(AppColors.cyan));
  });

  testWidgets('alignment preserves matches after inserted characters', (
    tester,
  ) async {
    await tester.pumpWidget(_app(attemptFailed: true));
    await tester.enterText(find.byType(TextField), 'xxcall');
    await tester.pump();

    expect(_overlayText(tester), 'xxcallcall');
    final colors = _overlayColors(tester);
    expect(colors.take(2), everyElement(AppColors.error));
    expect(colors.skip(2).take(4), everyElement(AppColors.cyan));
    expect(colors.skip(6), everyElement(AppColors.cyan.withValues(alpha: 0.4)));
  });

  testWidgets('alignment preserves matches after a missing character', (
    tester,
  ) async {
    await tester.pumpWidget(_app(attemptFailed: true));
    await tester.enterText(find.byType(TextField), 'cll');
    await tester.pump();

    expect(_overlayText(tester), 'clla');
    final colors = _overlayColors(tester);
    expect(colors.take(3), everyElement(AppColors.cyan));
    expect(colors.last, AppColors.cyan.withValues(alpha: 0.4));
  });

  testWidgets('alignment and tolerated insertion are case insensitive', (
    tester,
  ) async {
    await tester.pumpWidget(_app(attemptFailed: true));
    for (final input in ['CALL', 'CaLl ']) {
      await tester.enterText(find.byType(TextField), input);
      await tester.pump();
      expect(_overlayText(tester), input);
      expect(_overlayColors(tester), everyElement(AppColors.cyan));
    }
  });

  testWidgets('failed-attempt update keeps input and activates feedback', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.enterText(find.byType(TextField), 'tall');
    await tester.pump();
    expect(_overlayText(tester), 'tall');

    await tester.pumpWidget(_app(attemptFailed: true));
    expect(_overlayText(tester), 'tallcall');
    expect(_overlayColors(tester).first, AppColors.error);
  });

  testWidgets('matching prefix is cyan and remaining answer is dimmed', (
    tester,
  ) async {
    await tester.pumpWidget(_app(attemptFailed: true));
    await tester.enterText(
      find.byKey(const ValueKey('diff_input_text_field')),
      'cal',
    );
    await tester.pump();

    expect(_overlayText(tester), 'call');
    final colors = _overlayColors(tester);
    expect(colors.take(3), everyElement(AppColors.cyan));
    expect(colors.last, AppColors.cyan.withValues(alpha: 0.4));
  });

  testWidgets('incorrect characters are red and overlay stays visible', (
    tester,
  ) async {
    await tester.pumpWidget(_app(attemptFailed: true));
    await tester.enterText(
      find.byKey(const ValueKey('diff_input_text_field')),
      'tall',
    );
    await tester.pump();

    expect(_overlayText(tester), 'tallcall');
    final colors = _overlayColors(tester);
    expect(colors[0], AppColors.error);
    expect(colors.skip(1).take(3), everyElement(AppColors.cyan));
    expect(colors.last, AppColors.cyan.withValues(alpha: 0.4));
  });

  testWidgets('completely wrong answer displays full target dimmed', (
    tester,
  ) async {
    await tester.pumpWidget(_app(attemptFailed: true));
    await tester.enterText(
      find.byKey(const ValueKey('diff_input_text_field')),
      'xyz',
    );
    await tester.pump();

    expect(_overlayText(tester), 'xyzcall');
    final colors = _overlayColors(tester);
    expect(colors.take(3), everyElement(AppColors.error));
    expect(colors.skip(3), everyElement(AppColors.cyan.withValues(alpha: 0.4)));
  });

  testWidgets('onChanged reports each text edit', (tester) async {
    final changes = <String>[];
    await tester.pumpWidget(_app(onChanged: changes.add));
    await tester.enterText(
      find.byKey(const ValueKey('diff_input_text_field')),
      'ca',
    );
    await tester.pump();
    expect(changes, ['ca']);
  });

  testWidgets('field can receive normal keyboard input', (tester) async {
    final changes = <String>[];
    await tester.pumpWidget(_app(onChanged: changes.add));
    await tester.tap(find.byKey(const ValueKey('diff_input_text_field')));
    await tester.enterText(
      find.byKey(const ValueKey('diff_input_text_field')),
      'call',
    );
    await tester.pump();

    expect(changes, ['call']);
    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('diff_input_text_field')),
    );
    expect(field.cursorColor, AppColors.cyan);
  });
}

Widget _app({
  String targetAnswer = 'call',
  bool attemptFailed = false,
  ValueChanged<String>? onChanged,
}) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: DiffInputField(
        targetAnswer: targetAnswer,
        attemptFailed: attemptFailed,
        onChanged: onChanged ?? (_) {},
      ),
    ),
  ),
);

String _overlayText(WidgetTester tester) => tester
    .widget<RichText>(find.byKey(const ValueKey('diff_input_overlay')))
    .text
    .toPlainText();

List<Color?> _overlayColors(WidgetTester tester) {
  final root = tester
      .widget<RichText>(find.byKey(const ValueKey('diff_input_overlay')))
      .text;
  final colors = <Color?>[];
  void visit(InlineSpan span, TextStyle? inherited) {
    final style = span.style ?? inherited;
    if (span is TextSpan) {
      final chars = (span.text ?? '').runes;
      for (final _ in chars) {
        colors.add(style?.color);
      }
      for (final child in span.children ?? const <InlineSpan>[]) {
        visit(child, style);
      }
    }
  }

  visit(root, null);
  return colors;
}
