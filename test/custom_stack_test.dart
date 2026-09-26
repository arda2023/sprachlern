import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/providers/custom_stack_provider.dart';
import 'package:sprachlern/screens/add_words_screen.dart';
import 'package:sprachlern/screens/custom_stack_screen.dart';
import 'package:sprachlern/services/custom_stack_repository.dart';
import 'package:sprachlern/widgets/custom_stack_card_row.dart';

/// In-memory stand-in for Supabase: it outlives a [ProviderScope], so a fresh
/// scope over the same instance behaves like an app restart.
class _FakeCustomStackRepository implements CustomStackRepository {
  _FakeCustomStackRepository([List<CustomStackCard> cards = const []])
    : cards = [...cards];

  static const stackId = 'stack-1';

  final List<CustomStackCard> cards;
  final insertedInto = <String>[];
  int _nextId = 0;

  @override
  Future<({String id, CustomStack stack})> loadStack() async =>
      (id: stackId, stack: CustomStack(cards: await fetchCards(stackId)));

  @override
  Future<List<CustomStackCard>> fetchCards(String stackId) async =>
      List.of(cards);

  @override
  Future<List<CustomStackCard>> insertCards(
    String stackId,
    List<CustomStackCard> newCards,
  ) async {
    insertedInto.add(stackId);
    final saved = [
      for (final card in newCards)
        CustomStackCard(
          id: 'db-${_nextId++}',
          targetWord: card.targetWord,
          germanSentence: card.germanSentence,
        ),
    ];
    cards.addAll(saved);
    return saved;
  }
}

GoRouter _router() => GoRouter(
  initialLocation: '/custom-stack',
  routes: [
    GoRoute(
      path: '/custom-stack',
      builder: (_, _) => const CustomStackScreen(),
      routes: [GoRoute(path: 'add', builder: (_, _) => const AddWordsScreen())],
    ),
  ],
);

/// The stack now loads per signed-in user from the repository, so the flow
/// runs with a fixed user id and an in-memory repository instead of Supabase.
Future<void> _pumpFlow(
  WidgetTester tester, {
  _FakeCustomStackRepository? repository,
}) async {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        currentUserIdProvider.overrideWithValue('test-user'),
        customStackRepositoryProvider.overrideWithValue(
          repository ?? _FakeCustomStackRepository(),
        ),
      ],
      child: MaterialApp.router(routerConfig: _router()),
    ),
  );
  await tester.pumpAndSettle();
}

/// Opens the add screen, switches mode if needed, types [input] and submits.
Future<void> _addEntries(
  WidgetTester tester,
  String input, {
  required bool textMode,
}) async {
  await tester.tap(find.byKey(const ValueKey('custom_stack_add')));
  await tester.pumpAndSettle();

  if (textMode) {
    await tester.tap(find.byKey(const ValueKey('input_mode_Text')));
    await tester.pumpAndSettle();
  }

  await tester.enterText(find.byKey(const ValueKey('add_words_field')), input);
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const ValueKey('add_words_submit')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Leerer Stapel zeigt Leerzustand, "Hinzufügen" ist deaktiviert', (
    tester,
  ) async {
    await _pumpFlow(tester);

    expect(find.text('Karten: 0'), findsOneWidget);
    expect(
      find.text('Noch keine Karten. Füge Wörter hinzu, um zu starten.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('custom_stack_add')));
    await tester.pumpAndSettle();

    // Disabled: 40 % opacity per design.md 5.12.
    final opacity = tester.widget<Opacity>(
      find.ancestor(
        of: find.byKey(const ValueKey('add_words_submit')),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacity.opacity, 0.4);

    // Tapping while disabled must not create cards.
    await tester.tap(find.byKey(const ValueKey('add_words_submit')));
    await tester.pumpAndSettle();
    expect(find.byType(AddWordsScreen), findsOneWidget);
  });

  testWidgets('Wörter-Modus erzeugt je Wort eine Karte mit generiertem Satz', (
    tester,
  ) async {
    await _pumpFlow(tester);
    await _addEntries(tester, 'Essen;Gemüse;backen', textMode: false);

    expect(find.text('Karten: 3'), findsOneWidget);
    expect(find.byType(CustomStackCardRow), findsNWidgets(3));

    for (final word in ['Essen', 'Gemüse', 'backen']) {
      expect(find.text(word), findsOneWidget);
    }

    // Each card carries a generated sentence containing its target word.
    final rows = tester.widgetList<CustomStackCardRow>(
      find.byType(CustomStackCardRow),
    );
    for (final row in rows) {
      expect(row.card.germanSentence, contains(row.card.targetWord));
      expect(row.card.germanSentence, isNot(equals(row.card.targetWord)));
    }
  });

  testWidgets('Text-Modus lässt Sätze unverändert und setzt ein Zielwort', (
    tester,
  ) async {
    await _pumpFlow(tester);
    await _addEntries(
      tester,
      'Was machst du gerade?;Ich habe keine Zeit.',
      textMode: true,
    );

    expect(find.text('Karten: 2'), findsOneWidget);
    expect(find.byType(CustomStackCardRow), findsNWidgets(2));

    final rows = tester
        .widgetList<CustomStackCardRow>(find.byType(CustomStackCardRow))
        .toList();

    // Sentences survive verbatim (only trimmed).
    expect(rows[0].card.germanSentence, 'Was machst du gerade?');
    expect(rows[1].card.germanSentence, 'Ich habe keine Zeit.');

    // Longest-word heuristic, punctuation ignored.
    expect(rows[0].card.targetWord, 'machst');
    expect(rows[1].card.targetWord, 'keine');
  });

  testWidgets('Lädt den gespeicherten Stapel und speichert neue Karten', (
    tester,
  ) async {
    final repository = _FakeCustomStackRepository([
      const CustomStackCard(
        id: 'db-existing',
        targetWord: 'Brot',
        germanSentence: 'Ich kaufe Brot.',
      ),
    ]);
    await _pumpFlow(tester, repository: repository);

    // The existing card comes from the repository, not from memory.
    expect(find.text('Karten: 1'), findsOneWidget);
    expect(find.text('Brot'), findsOneWidget);

    await _addEntries(tester, 'Essen;Gemüse', textMode: false);

    expect(find.text('Karten: 3'), findsOneWidget);
    expect(repository.insertedInto, [_FakeCustomStackRepository.stackId]);
    expect(repository.cards.map((c) => c.targetWord), [
      'Brot',
      'Essen',
      'Gemüse',
    ]);
    // The state holds the stored rows, with database ids.
    final ids = tester
        .widgetList<CustomStackCardRow>(find.byType(CustomStackCardRow))
        .map((row) => row.card.id);
    expect(ids, ['db-existing', 'db-0', 'db-1']);

    // A fresh scope over the same repository, i.e. an app restart.
    await tester.pumpWidget(const SizedBox());
    await _pumpFlow(tester, repository: repository);
    expect(find.text('Karten: 3'), findsOneWidget);
  });
}
