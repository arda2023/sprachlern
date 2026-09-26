import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/providers/custom_stack_provider.dart';
import 'package:sprachlern/services/supabase_client.dart';
import 'package:sprachlern/router/app_router.dart';
import 'package:sprachlern/screens/custom_stack_exercise_screen.dart';
import 'package:sprachlern/screens/custom_stack_screen.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/diff_input_field.dart';
import 'package:sprachlern/widgets/fill_in_card.dart';

const _cards = [
  CustomStackCard(
    id: 'custom-1',
    targetWord: 'Fruit',
    englishSentence: 'Fruit is healthy.',
    germanSentence: 'Obst ist gesund.',
  ),
  CustomStackCard(
    id: 'custom-2',
    targetWord: 'Go',
    englishSentence: 'Go home now.',
    germanSentence: 'Geh jetzt nach Hause.',
  ),
];

class _LoadedCustomStack extends CustomStackNotifier {
  _LoadedCustomStack(this.cards);

  final List<CustomStackCard> cards;

  @override
  CustomStack build() => CustomStack(cards: cards);
}

Future<GoRouter> _pump(
  WidgetTester tester, {
  List<CustomStackCard> cards = _cards,
  String location = '/custom-stack/exercise',
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      isAuthenticatedProvider.overrideWithValue(true),
      customStackProvider.overrideWith(() => _LoadedCustomStack(cards)),
      // Already loaded cards must suffice for every action in this screen.
      supabaseClientProvider.overrideWith((ref) {
        throw StateError('Custom practice must not access Supabase');
      }),
    ],
  );
  addTearDown(container.dispose);
  final router = container.read(routerProvider)..go(location);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

Finder get _field => find.byKey(const ValueKey('diff_input_text_field'));

Future<void> _type(WidgetTester tester, String input) async {
  await tester.enterText(_field, input);
  await tester.pump();
}

Future<void> _action(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('exercise_action')));
  await tester.pumpAndSettle();
}

Color _frameColor(WidgetTester tester) =>
    ((tester
                        .widget<Container>(
                          find.byKey(const ValueKey('diff_input_frame')),
                        )
                        .decoration!
                    as BoxDecoration)
                .border!
            as Border)
        .top
        .color;

void main() {
  testWidgets('Filled custom stack opens its nested exercise route', (
    tester,
  ) async {
    await _pump(tester, location: '/custom-stack');
    expect(find.byKey(const ValueKey('custom_stack_exercise')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('custom_stack_exercise')));
    await tester.pumpAndSettle();

    expect(find.byType(CustomStackExerciseScreen), findsOneWidget);
    expect(
      GoRouterState.of(tester.element(find.byType(CustomStackExerciseScreen)))
          .uri
          .path,
      '/custom-stack/exercise',
    );
    expect(find.text('1/2'), findsOneWidget);
    expect(
      tester.widget<DiffInputField>(find.byType(DiffInputField)).targetAnswer,
      'Fruit',
    );
  });

  testWidgets('Empty stack has no exercise entry and direct route stays safe', (
    tester,
  ) async {
    final router = await _pump(tester, cards: [], location: '/custom-stack');
    expect(find.byKey(const ValueKey('custom_stack_exercise')), findsNothing);
    expect(find.byKey(const ValueKey('custom_stack_add')), findsOneWidget);
    expect(find.byType(CustomStackScreen), findsOneWidget);

    router.go('/custom-stack/exercise');
    await tester.pumpAndSettle();
    expect(find.text('Noch keine Karten vorhanden.'), findsOneWidget);
    expect(find.byType(DiffInputField), findsNothing);
    expect(find.byKey(const ValueKey('exercise_action')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Custom FillInCard has no status, label or status spacing', (
    tester,
  ) async {
    await _pump(tester);
    expect(find.byType(StatusIndicator), findsNothing);
    expect(find.byKey(const ValueKey('status_segment_0')), findsNothing);
    expect(find.text('Neues Wort'), findsNothing);
    final fill = tester.widget<FillInCard>(find.byType(FillInCard));
    expect(fill.showStatusIndicator, isFalse);
    expect(fill.exercise.stackWordId, isNull);
    final column = tester.widget<Column>(
      find
          .descendant(
            of: find.byType(FillInCard),
            matching: find.byType(Column),
          )
          .first,
    );
    expect(column.children.first, isA<Wrap>());

    await tester.tap(find.byKey(const ValueKey('translation_toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Obst ist gesund.'), findsOneWidget);
  });

  testWidgets('Wrong attempts stay local: red frame, partial then full hint', (
    tester,
  ) async {
    await _pump(tester);
    await _type(tester, 'wrong');
    expect(find.text('Eingeben'), findsOneWidget);
    expect(_frameColor(tester), AppColors.field);
    await _action(tester);
    expect(find.text('1/2'), findsOneWidget);
    expect(_frameColor(tester), AppColors.error);
    expect(tester.widget<Text>(_hint).data, 'Fr...');
    expect(
      tester.widget<Text>(_hint).style!.color,
      AppColors.error.withValues(alpha: 0.4),
    );
    expect(tester.widget<TextField>(_field).controller!.text, isEmpty);
    expect(tester.widget<TextField>(_field).readOnly, isFalse);

    await _type(tester, 'still wrong');
    expect(_frameColor(tester), AppColors.field);
    expect(_hint, findsNothing);
    await _action(tester);
    expect(tester.widget<Text>(_hint).data, 'Fruit');
    expect(find.text('1/2'), findsOneWidget);
    expect(
      tester.widget<DiffInputField>(find.byType(DiffInputField)).attemptCount,
      2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Reveal word is cyan and does not count a wrong attempt', (
    tester,
  ) async {
    await _pump(tester);
    expect(find.text('Wort erfahren'), findsOneWidget);
    await _action(tester);
    final solution = tester.widget<Text>(
      find.byKey(const ValueKey('diff_input_solution')),
    );
    expect(solution.data, 'Fruit');
    expect(solution.style!.color, AppColors.cyan.withValues(alpha: 0.4));
    expect(_frameColor(tester), AppColors.field);
    expect(
      tester.widget<DiffInputField>(find.byType(DiffInputField)).attemptCount,
      0,
    );
    expect(find.text('1/2'), findsOneWidget);

    await _type(tester, 'Fruit');
    expect(find.byKey(const ValueKey('diff_input_solution')), findsNothing);
    await _action(tester);
    expect(find.text('Weiter'), findsOneWidget);
    expect(find.byKey(const ValueKey('exercise_action_check')), findsOneWidget);
  });

  testWidgets('Correct confirmation waits for Weiter and resets next card', (
    tester,
  ) async {
    await _pump(tester);
    await _type(tester, 'wrong');
    await _action(tester);
    await _type(tester, '  fRuIt  ');
    await _action(tester);
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('Weiter'), findsOneWidget);
    expect(_frameColor(tester), AppColors.success);
    expect(tester.widget<TextField>(_field).readOnly, isTrue);
    expect(find.byKey(const ValueKey('exercise_action_check')), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('1/2'), findsOneWidget);

    await _action(tester);
    expect(find.text('2/2'), findsOneWidget);
    final diff = tester.widget<DiffInputField>(find.byType(DiffInputField));
    expect(diff.targetAnswer, 'Go');
    expect(diff.attemptCount, 0);
    expect(diff.isWrong, isFalse);
    expect(diff.isCorrect, isFalse);
    expect(diff.solutionRevealed, isFalse);
    expect(tester.widget<TextField>(_field).controller!.text, isEmpty);
    expect(find.text('Wort erfahren'), findsOneWidget);
  });

  testWidgets('Last correct card returns to custom stack only after Weiter', (
    tester,
  ) async {
    final router = await _pump(tester, cards: [_cards.first]);
    await _type(tester, 'Fruit');
    await _action(tester);
    expect(find.byType(CustomStackExerciseScreen), findsOneWidget);
    expect(find.text('1/1'), findsOneWidget);
    await _action(tester);
    expect(router.routeInformationProvider.value.uri.path, '/custom-stack');
    expect(find.byType(CustomStackScreen), findsOneWidget);
    expect(find.byType(CustomStackExerciseScreen), findsNothing);
  });

  testWidgets('Keyboard done uses the same confirmation and Weiter flow', (
    tester,
  ) async {
    final router = await _pump(tester, cards: [_cards.first]);
    await tester.tap(_field);
    await _type(tester, 'Fruit');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Weiter'), findsOneWidget);
    final field = tester.widget<TextField>(_field);
    field.onSubmitted!('Fruit');
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/custom-stack');
  });

  testWidgets('Gap mapping supports phrases and keeps punctuation outside', (
    tester,
  ) async {
    await _pump(
      tester,
      cards: [
        const CustomStackCard(
          id: 'phrase',
          targetWord: 'change trains',
          englishSentence: 'You have to change trains, today.',
          germanSentence: 'Heute musst du umsteigen.',
        ),
      ],
    );
    final exercise = tester
        .widget<FillInCard>(find.byType(FillInCard))
        .exercise;
    expect(exercise.targetAnswer, 'change trains');
    expect(exercise.tokens.map((token) => token.text), [
      'You',
      'have',
      'to',
      '',
      ',',
      'today.',
    ]);
    expect(exercise.tokens.where((token) => token.isBlank), hasLength(1));
  });

  testWidgets('Legacy card without English sentence shows safe error state', (
    tester,
  ) async {
    await _pump(
      tester,
      cards: [
        const CustomStackCard(
          id: 'legacy',
          targetWord: 'bread',
          englishSentence: '',
          germanSentence: 'Ich kaufe Brot.',
        ),
      ],
    );
    expect(
      find.text('Diese Karte hat keinen passenden englischen Lückensatz.'),
      findsOneWidget,
    );
    expect(find.byType(DiffInputField), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Finder get _hint => find.byKey(const ValueKey('diff_input_hint'));
