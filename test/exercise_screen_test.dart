import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sprachlern/providers/exercise_provider.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/providers/content_provider.dart';
import 'package:sprachlern/router/app_router.dart';
import 'package:sprachlern/services/exercise_repository.dart';
import 'package:sprachlern/services/supabase_client.dart';
import 'package:sprachlern/screens/exercise_screen.dart';
import 'package:sprachlern/widgets/diff_input_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'helpers/stack_fixtures.dart';

const _rows = [
  {
    'stack_word_id': 'word-1',
    'german_word': 'anrufen',
    'german_example': 'Ich könnte dich morgen anrufen.',
    'english_example': 'I could call you tomorrow.',
    'target_word': 'call',
    'memory_level': 2,
  },
  {
    'stack_word_id': 'word-2',
    'german_word': 'umsteigen',
    'german_example': 'Du musst in Köln umsteigen.',
    'english_example': 'You have to change trains in Cologne.',
    'target_word': 'change trains',
    'memory_level': 0,
  },
];

class _ScreenRepository implements ExerciseRepository {
  final submittedAnswers = <({String stackWordId, bool correct})>[];

  @override
  Future<List<Map<String, dynamic>>> fetchNextCards(
    String stackId, {
    int limit = 20,
  }) async => _rows;

  @override
  Future<void> submitAnswer(String stackWordId, bool correct) async {
    submittedAnswers.add((stackWordId: stackWordId, correct: correct));
  }
}

SupabaseClient _client(List<Map<String, dynamic>> answers) => SupabaseClient(
  'https://example.invalid',
  'test-key',
  authOptions: const AuthClientOptions(autoRefreshToken: false),
  httpClient: MockClient((request) async {
    if (request.url.path.endsWith('/get_next_cards')) {
      expect(jsonDecode(request.body), {
        'p_stack_id': 'test-stack',
        'p_limit': 20,
      });
      return http.Response(
        jsonEncode(_rows),
        200,
        request: request,
        headers: {'content-type': 'application/json'},
      );
    }
    expect(request.url.path, '/rest/v1/rpc/submit_answer');
    answers.add(Map<String, dynamic>.from(jsonDecode(request.body) as Map));
    return http.Response('', 204, request: request);
  }),
);

void main() {
  for (final (input, expectedCorrect) in [
    ('call', true),
    ('wrong', false),
    ('caall', false),
  ]) {
    testWidgets(
      'confirmation of "$input" submits $expectedCorrect and advances',
      (tester) async {
        final repository = _ScreenRepository();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              exerciseRepositoryProvider.overrideWithValue(repository),
            ],
            child: const MaterialApp(
              home: ExerciseScreen(stackId: 'test-stack'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester
              .widget<DiffInputField>(find.byType(DiffInputField))
              .attemptFailed,
          isFalse,
        );

        final field = find.byKey(const ValueKey('diff_input_text_field'));
        await tester.tap(field);
        await tester.enterText(field, input);
        await tester.pump();
        await tester.testTextInput.receiveAction(TextInputAction.done);

        await tester.pump(const Duration(milliseconds: 699));
        expect(repository.submittedAnswers, isEmpty);
        expect(
          find.byKey(const ValueKey('diff_input_overlay')),
          findsOneWidget,
        );
        expect(
          tester
              .widget<DiffInputField>(find.byType(DiffInputField))
              .attemptFailed,
          !expectedCorrect,
        );
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pumpAndSettle();

        expect(repository.submittedAnswers, hasLength(1));
        expect(repository.submittedAnswers.single.stackWordId, 'word-1');
        expect(repository.submittedAnswers.single.correct, expectedCorrect);
        expect(find.text('umsteigen'), findsOneWidget);
        expect(find.byKey(const ValueKey('diff_input_cursor')), findsOneWidget);
        expect(
          tester
              .widget<DiffInputField>(find.byType(DiffInputField))
              .attemptFailed,
          isFalse,
        );
      },
    );
  }

  testWidgets('submitting an empty answer reports false without crashing', (
    tester,
  ) async {
    final repository = _ScreenRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [exerciseRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: ExerciseScreen(stackId: 'test-stack')),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('diff_input_text_field')));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(repository.submittedAnswers, hasLength(1));
    expect(repository.submittedAnswers.single.correct, isFalse);
    expect(find.text('umsteigen'), findsOneWidget);
  });

  testWidgets('Detail and revue navigate to the exercise for their stack', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        isAuthenticatedProvider.overrideWithValue(true),
        stackListProvider.overrideWith((ref) async => fixtureStacks),
        stackDetailsProvider.overrideWith(
          (ref, id) async => fixtureDetails[id],
        ),
        exerciseRepositoryProvider.overrideWithValue(_ScreenRepository()),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(routerProvider);
    router.go('/stacks/reisen-und-alltag');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lerne mit diesem Stapel'));
    await tester.pumpAndSettle();
    expect(
      GoRouterState.of(tester.element(find.byType(ExerciseScreen))).uri.path,
      '/stacks/reisen-und-alltag/exercise',
    );
    expect(
      tester.widget<ExerciseScreen>(find.byType(ExerciseScreen)).stackId,
      'reisen-und-alltag',
    );

    router.go('/stack-revue');
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('revue_play_arbeit-und-termine')),
    );
    await tester.pumpAndSettle();
    expect(
      GoRouterState.of(tester.element(find.byType(ExerciseScreen))).uri.path,
      '/stacks/arbeit-und-termine/exercise',
    );
    expect(
      tester.widget<ExerciseScreen>(find.byType(ExerciseScreen)).stackId,
      'arbeit-und-termine',
    );
  });
  testWidgets(
    'Übung rendert, füllt die Lücke und schließt den Grammatikhinweis',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exerciseRepositoryProvider.overrideWithValue(_ScreenRepository()),
          ],
          child: const MaterialApp(home: ExerciseScreen(stackId: 'test-stack')),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('diff_input_text_field')),
        findsOneWidget,
      );
      expect(find.text('call'), findsNothing);

      await tester.enterText(
        find.byKey(const ValueKey('diff_input_text_field')),
        'call',
      );
      await tester.pump();
      expect(find.text('call'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('grammar_hint_row')));
      await tester.pumpAndSettle();
      expect(find.text('Grammatikhinweis'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('grammar_hint_close')));
      await tester.pumpAndSettle();
      expect(find.text('Grammatikhinweis'), findsNothing);
    },
  );

  test(
    'queue maps RPC data and submits both answer outcomes before advancing',
    () async {
      final answers = <Map<String, dynamic>>[];
      final client = _client(answers);
      addTearDown(client.dispose);
      final container = ProviderContainer(
        overrides: [supabaseClientProvider.overrideWithValue(client)],
      );
      addTearDown(container.dispose);
      final provider = exerciseProvider('test-stack');
      final session = await container.read(provider.future);
      expect(session.cards, hasLength(2));
      final exercise = session.currentExercise!;
      expect(exercise.stackWordId, 'word-1');
      expect(exercise.wordStatus, 2);
      expect(exercise.targetAnswer, 'call');
      expect(exercise.tokens.map((token) => token.text), [
        'I',
        'could',
        '',
        'you',
        'tomorrow.',
      ]);
      expect(exercise.tokens.where((token) => token.isBlank), hasLength(1));
      expect(exercise.currentCard, 1);
      expect(exercise.totalCards, 2);

      final notifier = container.read(provider.notifier);
      await notifier.submitAnswer(false);
      final second = container.read(provider).requireValue.currentExercise!;
      expect(second.stackWordId, 'word-2');
      expect(second.targetAnswer, 'change trains');
      expect(second.currentCard, 2);
      await notifier.submitAnswer(true);
      expect(answers, [
        {'p_stack_word_id': 'word-1', 'p_correct': false},
        {'p_stack_word_id': 'word-2', 'p_correct': true},
      ]);
      expect(container.read(provider).requireValue.currentExercise, isNull);
      expect(container.read(provider).requireValue.currentIndex, 2);
    },
  );
}
