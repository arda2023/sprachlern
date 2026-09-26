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
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/exercise_input_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'helpers/stack_fixtures.dart';

const _rows = [
  {
    'stack_word_id': 'word-1',
    'german_word': 'Obst',
    'german_example': 'Obst ist gesund.',
    'english_example': 'Fruit is healthy.',
    'target_word': 'Fruit',
    'memory_level': 2,
  },
  {
    'stack_word_id': 'word-2',
    'german_word': 'gehen',
    'german_example': 'Geh jetzt nach Hause.',
    'english_example': 'Go home now.',
    'target_word': 'Go',
    'memory_level': 0,
  },
];

class _ScreenRepository implements ExerciseRepository {
  final submittedAnswers = <({String stackWordId, bool correct})>[];

  /// When true, every submit is recorded and then fails.
  bool failSubmit = false;

  @override
  Future<List<Map<String, dynamic>>> fetchNextCards(
    String stackId, {
    int limit = 20,
  }) async => _rows;

  @override
  Future<void> submitAnswer(String stackWordId, bool correct) async {
    submittedAnswers.add((stackWordId: stackWordId, correct: correct));
    if (failSubmit) throw Exception('network down');
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

Future<_ScreenRepository> _pumpExercise(WidgetTester tester) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final repository = _ScreenRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [exerciseRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: ExerciseScreen(stackId: 'test-stack')),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(
    find.byKey(const ValueKey('diff_input_text_field')),
    text,
  );
  await tester.pump();
}

Future<void> _tapAction(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('exercise_action')));
  await tester.pumpAndSettle();
}

String _actionLabel(WidgetTester tester) => tester
    .widget<Text>(
      find.descendant(
        of: find.byKey(const ValueKey('exercise_action')),
        matching: find.byType(Text),
      ),
    )
    .data!;

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

String? _hint(WidgetTester tester) {
  final hint = find.byKey(const ValueKey('diff_input_hint'));
  return hint.evaluate().isEmpty ? null : tester.widget<Text>(hint).data;
}

bool _onCard(String stackWordId) =>
    find.byKey(ValueKey('exercise_card_$stackWordId')).evaluate().isNotEmpty;

/// Solves the "Fruit" card on the first try and moves on to the "Go" card.
Future<void> _solveFirstCard(WidgetTester tester) async {
  await _type(tester, 'Fruit');
  await _tapAction(tester);
  await _tapAction(tester);
}

void main() {
  testWidgets(
    'Fall 1: leeres Feld – "Wort erfahren" zeigt Lösung ohne Rot, wertet false',
    (tester) async {
      final repository = await _pumpExercise(tester);
      expect(_actionLabel(tester), 'Wort erfahren');

      await _tapAction(tester);

      final solution = tester.widget<Text>(
        find.byKey(const ValueKey('diff_input_solution')),
      );
      expect(solution.data, 'Fruit');
      expect(solution.style!.color, AppColors.cyan.withValues(alpha: 0.4));
      expect(_frameColor(tester), isNot(AppColors.error));
      expect(_hint(tester), isNull);
      // Not recalled from memory: SM-2 gets false, once.
      expect(repository.submittedAnswers, [
        (stackWordId: 'word-1', correct: false),
      ]);
      expect(_onCard('word-1'), isTrue);
      expect(_actionLabel(tester), 'Wort erfahren');

      await _tapAction(tester);
      expect(repository.submittedAnswers, hasLength(1));
    },
  );

  testWidgets(
    'Wort erfahren, danach richtig – "Weiter" wechselt ohne true-Aufruf',
    (tester) async {
      final repository = await _pumpExercise(tester);

      await _tapAction(tester);
      await _type(tester, 'Fruit');
      await _tapAction(tester);
      expect(_actionLabel(tester), 'Weiter');

      await _tapAction(tester);

      expect(repository.submittedAnswers, [
        (stackWordId: 'word-1', correct: false),
      ]);
      expect(_onCard('word-2'), isTrue);
    },
  );

  testWidgets('Fall 2: Text eingegeben – Button zeigt "Eingeben"', (
    tester,
  ) async {
    await _pumpExercise(tester);

    await _type(tester, 'F');
    expect(_actionLabel(tester), 'Eingeben');

    await _type(tester, '');
    expect(_actionLabel(tester), 'Wort erfahren');
  });

  testWidgets(
    'Fall 3: erster Fehlversuch "Fruit" – roter Rand, "Fr...", einmal false',
    (tester) async {
      final repository = await _pumpExercise(tester);

      await _type(tester, 'Frut');
      await _tapAction(tester);

      expect(_frameColor(tester), AppColors.error);
      expect(_hint(tester), 'Fr...');
      expect(repository.submittedAnswers, [
        (stackWordId: 'word-1', correct: false),
      ]);
      expect(_onCard('word-1'), isTrue);
      expect(_actionLabel(tester), 'Eingeben');
    },
  );

  testWidgets(
    'Fall 4: zweiter Fehlversuch – ganze Lösung "Fruit", kein zweiter Aufruf',
    (tester) async {
      final repository = await _pumpExercise(tester);

      await _type(tester, 'Frut');
      await _tapAction(tester);
      await _type(tester, 'Frucht');
      // Editing clears the feedback until the next confirmation.
      expect(_frameColor(tester), isNot(AppColors.error));
      expect(_hint(tester), isNull);
      await _tapAction(tester);

      expect(_frameColor(tester), AppColors.error);
      expect(_hint(tester), 'Fruit');
      expect(repository.submittedAnswers, hasLength(1));
      expect(_onCard('word-1'), isTrue);
    },
  );

  testWidgets('Fall 5: Wort mit 2 Buchstaben – Hinweis "G..."', (tester) async {
    await _pumpExercise(tester);
    await _solveFirstCard(tester);
    expect(_onCard('word-2'), isTrue);

    await _type(tester, 'Ga');
    await _tapAction(tester);

    expect(_frameColor(tester), AppColors.error);
    expect(_hint(tester), 'G...');
  });

  testWidgets(
    'Fall 6: sofort richtig – "Weiter" mit Häkchen, Tap sendet true und wechselt',
    (tester) async {
      final repository = await _pumpExercise(tester);

      await _type(tester, 'fruit ');
      await _tapAction(tester);

      expect(_actionLabel(tester), 'Weiter');
      expect(
        find.byKey(const ValueKey('exercise_action_check')),
        findsOneWidget,
      );
      expect(_frameColor(tester), AppColors.success);
      // Scored only on "Weiter".
      expect(repository.submittedAnswers, isEmpty);
      expect(_onCard('word-1'), isTrue);

      await _tapAction(tester);

      expect(repository.submittedAnswers, [
        (stackWordId: 'word-1', correct: true),
      ]);
      expect(_onCard('word-2'), isTrue);
    },
  );

  testWidgets(
    'Fall 7: richtig nach Fehlversuch – "Weiter" wechselt ohne weiteren Aufruf',
    (tester) async {
      final repository = await _pumpExercise(tester);

      await _type(tester, 'Frut');
      await _tapAction(tester);
      await _type(tester, 'Fruit');
      await _tapAction(tester);

      expect(_actionLabel(tester), 'Weiter');
      expect(
        find.byKey(const ValueKey('exercise_action_check')),
        findsOneWidget,
      );

      await _tapAction(tester);

      expect(repository.submittedAnswers, [
        (stackWordId: 'word-1', correct: false),
      ]);
      expect(_onCard('word-2'), isTrue);
    },
  );

  testWidgets('Fall 8: neue Karte – Zustand komplett zurückgesetzt', (
    tester,
  ) async {
    final repository = await _pumpExercise(tester);

    // Card 1 collects every kind of state: revealed, two misses, solved.
    await _tapAction(tester);
    await _type(tester, 'Frut');
    await _tapAction(tester);
    await _type(tester, 'Frucht');
    await _tapAction(tester);
    await _type(tester, 'Fruit');
    await _tapAction(tester);
    await _tapAction(tester);
    expect(_onCard('word-2'), isTrue);

    expect(_actionLabel(tester), 'Wort erfahren');
    expect(_frameColor(tester), AppColors.field);
    expect(_hint(tester), isNull);
    expect(find.byKey(const ValueKey('diff_input_solution')), findsNothing);
    expect(find.byKey(const ValueKey('exercise_action_check')), findsNothing);
    expect(find.byKey(const ValueKey('diff_input_cursor')), findsOneWidget);

    // Counters start over: first hint stage, and a new false for word-2.
    await _type(tester, 'Ga');
    await _tapAction(tester);
    expect(_hint(tester), 'G...');
    expect(repository.submittedAnswers, [
      (stackWordId: 'word-1', correct: false),
      (stackWordId: 'word-2', correct: false),
    ]);
  });

  testWidgets('Eingabezeile sitzt direkt über der Tastatur (5.7)', (
    tester,
  ) async {
    await _pumpExercise(tester);
    const keyboardHeight = 300.0;
    tester.view.viewInsets = const FakeViewPadding(bottom: keyboardHeight);
    await tester.pumpAndSettle();

    const keyboardTop = 812 - keyboardHeight;
    expect(tester.getRect(find.byType(ExerciseInputBar)).bottom, keyboardTop);
    expect(
      tester.getRect(find.byKey(const ValueKey('exercise_action'))).bottom,
      lessThanOrEqualTo(keyboardTop),
    );
  });

  testWidgets('Eingabetaste der Tastatur löst dieselbe Aktion aus', (
    tester,
  ) async {
    await _pumpExercise(tester);
    await _type(tester, 'Fruit');

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(_actionLabel(tester), 'Weiter');
  });

  testWidgets('Speicherfehler: Hinweis, und trotzdem höchstens ein Aufruf', (
    tester,
  ) async {
    final repository = await _pumpExercise(tester);
    repository.failSubmit = true;

    await _type(tester, 'Frut');
    await _tapAction(tester);
    expect(
      find.text('Deine Antwort konnte nicht gespeichert werden.'),
      findsOneWidget,
    );
    await _type(tester, 'Fruit');
    await _tapAction(tester);
    await _tapAction(tester);

    // The failed false is not retried, and "Weiter" adds nothing.
    expect(repository.submittedAnswers, hasLength(1));
    expect(_onCard('word-2'), isTrue);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
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
      expect(find.text('Fruit'), findsNothing);

      await tester.enterText(
        find.byKey(const ValueKey('diff_input_text_field')),
        'Fruit',
      );
      await tester.pump();
      expect(find.text('Fruit'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('grammar_hint_row')));
      await tester.pumpAndSettle();
      expect(find.text('Grammatikhinweis'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('grammar_hint_close')));
      await tester.pumpAndSettle();
      expect(find.text('Grammatikhinweis'), findsNothing);
    },
  );

  test(
    'queue maps RPC data; submitAnswer only scores, nextCard advances',
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
      expect(exercise.targetAnswer, 'Fruit');
      expect(exercise.tokens.map((token) => token.text), [
        '',
        'is',
        'healthy.',
      ]);
      expect(exercise.tokens.first.isBlank, isTrue);
      expect(exercise.currentCard, 1);
      expect(exercise.totalCards, 2);

      final notifier = container.read(provider.notifier);
      await notifier.submitAnswer(false);
      // Scoring no longer moves on by itself.
      expect(
        container.read(provider).requireValue.currentExercise!.stackWordId,
        'word-1',
      );

      notifier.nextCard();
      final second = container.read(provider).requireValue.currentExercise!;
      expect(second.stackWordId, 'word-2');
      expect(second.targetAnswer, 'Go');
      expect(second.currentCard, 2);
      await notifier.submitAnswer(true);
      notifier.nextCard();
      expect(answers, [
        {'p_stack_word_id': 'word-1', 'p_correct': false},
        {'p_stack_word_id': 'word-2', 'p_correct': true},
      ]);
      expect(container.read(provider).requireValue.currentExercise, isNull);
      expect(container.read(provider).requireValue.currentIndex, 2);
    },
  );
}
