import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/text_data.dart';
import 'package:sprachlern/models/word_list_data.dart';
import 'package:sprachlern/providers/word_list_provider.dart';
import 'package:sprachlern/services/word_list_repository.dart';
import 'package:sprachlern/screens/text_exercise_screen.dart';
import 'package:sprachlern/screens/texts_screen.dart';
import 'package:sprachlern/screens/word_list_screen.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/round_play_button.dart';
import 'package:sprachlern/widgets/text_cover_card.dart';
import 'package:sprachlern/widgets/text_gap_field.dart';
import 'package:sprachlern/widgets/word_list_row.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

class _FakeWordListRepository extends WordListRepository {
  _FakeWordListRepository(this.entries)
    : super(
        SupabaseClient(
          'https://example.supabase.co',
          'test-key',
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      );

  final List<WordListEntry> entries;

  @override
  Future<List<WordListEntry>> fetchLearnedWords() async => entries;
}

Future<void> _pumpScreen(
  WidgetTester tester,
  Widget screen, {
  List<WordListEntry>? learnedWords,
}) async {
  _phoneSize(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (learnedWords != null)
          wordListRepositoryProvider.overrideWithValue(
            _FakeWordListRepository(learnedWords),
          ),
      ],
      child: MaterialApp(home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

final _learnedWords = [
  const WordListEntry(
    stackWordId: 'umbrella-id',
    headword: 'umbrella',
    translation: 'Regenschirm',
    exampleSentence: 'Take an umbrella, it might rain.',
    lastSeen: 'vor 2 Tagen',
    repeatCount: 3,
  ),
  const WordListEntry(
    stackWordId: 'bridge-id',
    headword: 'bridge',
    translation: 'Brücke',
    exampleSentence: 'The bridge is closed today.',
    lastSeen: 'vor 5 Tagen',
    repeatCount: 1,
  ),
  const WordListEntry(
    stackWordId: 'cheerful-id',
    headword: 'cheerful',
    translation: 'fröhlich',
    exampleSentence: 'She is a cheerful girl.',
    lastSeen: 'vor 1 Woche',
    repeatCount: 2,
    isCurrentlySelected: true,
  ),
  const WordListEntry(
    stackWordId: 'borrow-id',
    headword: 'borrow',
    translation: 'ausleihen',
    exampleSentence: 'Can I borrow your pen?',
    lastSeen: 'vor 3 Tagen',
    repeatCount: 4,
  ),
  const WordListEntry(
    stackWordId: 'delay-id',
    headword: 'delay',
    translation: 'Verspätung',
    exampleSentence: 'The train has a short delay.',
    lastSeen: 'gestern',
    repeatCount: 2,
  ),
  const WordListEntry(
    stackWordId: 'harbor-id',
    headword: 'harbor',
    translation: 'Hafen',
    exampleSentence: 'We walked along the harbor.',
    lastSeen: 'vor 2 Wochen',
    repeatCount: 1,
  ),
  const WordListEntry(
    stackWordId: 'journey-id',
    headword: 'journey',
    translation: 'Reise',
    exampleSentence: 'It was a long journey.',
    lastSeen: 'vor 4 Tagen',
    repeatCount: 3,
  ),
  const WordListEntry(
    stackWordId: 'knowledge-id',
    headword: 'knowledge',
    translation: 'Wissen',
    exampleSentence: 'Knowledge is power.',
    lastSeen: 'vor 6 Tagen',
    repeatCount: 1,
  ),
  const WordListEntry(
    stackWordId: 'lantern-id',
    headword: 'lantern',
    translation: 'Laterne',
    exampleSentence: 'He lit the lantern at dusk.',
    lastSeen: 'vor 3 Wochen',
    repeatCount: 1,
  ),
  const WordListEntry(
    stackWordId: 'meadow-id',
    headword: 'meadow',
    translation: 'Wiese',
    exampleSentence: 'Cows were grazing in the meadow.',
    lastSeen: 'vor 9 Tagen',
    repeatCount: 2,
  ),
  const WordListEntry(
    stackWordId: 'neighbor-id',
    headword: 'neighbor',
    translation: 'Nachbar',
    exampleSentence: 'My neighbor plays the piano.',
    lastSeen: 'vor 2 Tagen',
    repeatCount: 5,
  ),
  const WordListEntry(
    stackWordId: 'quiet-id',
    headword: 'quiet',
    translation: 'leise',
    exampleSentence: 'Please be quiet in the library.',
    lastSeen: 'vor 1 Woche',
    repeatCount: 2,
  ),
  const WordListEntry(
    stackWordId: 'reliable-id',
    headword: 'reliable',
    translation: 'zuverlässig',
    exampleSentence: 'He is a reliable friend.',
    lastSeen: 'vor 12 Tagen',
    repeatCount: 1,
  ),
  const WordListEntry(
    stackWordId: 'sunrise-id',
    headword: 'sunrise',
    translation: 'Sonnenaufgang',
    exampleSentence: 'We watched the sunrise together.',
    lastSeen: 'gestern',
    repeatCount: 3,
  ),
];

String _gapText(WidgetTester tester, int index) => tester
    .widget<TextField>(
      find.descendant(
        of: find.byKey(ValueKey('text_gap_$index')),
        matching: find.byType(TextField),
      ),
    )
    .controller!
    .text;

void main() {
  testWidgets('Texte: Cover → Vorschau-Sheet → Text-Übung', (tester) async {
    _phoneSize(tester);
    final router = GoRouter(
      initialLocation: '/texts',
      routes: [
        GoRoute(
          path: '/texts',
          builder: (_, _) => const TextsScreen(),
          routes: [
            GoRoute(
              path: ':id/exercise',
              builder: (_, state) =>
                  TextExerciseScreen(textId: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    // Both cover palettes are on screen, 88 × 128 each.
    final arts = tester.widgetList<TextCoverArt>(find.byType(TextCoverArt));
    expect(arts.length, greaterThanOrEqualTo(2));
    expect(arts.map((a) => a.palette).toSet(), TextCoverPalette.values.toSet());
    expect(
      tester.getSize(find.byType(TextCoverArt).first),
      const Size(TextCoverArt.width, TextCoverArt.height),
    );

    await tester.tap(find.byKey(const ValueKey('text_cover_rainy-morning')));
    await tester.pumpAndSettle();

    // Preview sheet: cover + title + badge, two exercise rows, no primary button.
    final sheet = find.byType(BottomSheet);
    expect(sheet, findsOneWidget);
    expect(
      find.descendant(of: sheet, matching: find.text('The Rainy Morning')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('A1')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('Verben')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('Beliebige Wortart')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.byType(RoundPlayButton)),
      findsNWidgets(2),
    );
    expect(
      find.descendant(of: sheet, matching: find.byType(FilledButton)),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('text_preview_play_Verben')));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byType(TextExerciseScreen), findsOneWidget);
    expect(find.text('The Rainy Morning'), findsOneWidget);
  });

  testWidgets('Text-Übung: Lücken inline mit Grundwort als Platzhalter', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const TextExerciseScreen(textId: 'rainy-morning'),
    );

    final gaps = find.byType(TextGapField);
    expect(gaps, findsNWidgets(3));

    // 128 × 28 and the base word as placeholder, empty at the start.
    for (final (index, base) in ['wake', 'take', 'walk'].indexed) {
      final gap = find.byKey(ValueKey('text_gap_$index'));
      expect(
        tester.getSize(gap),
        const Size(TextGapField.width, TextGapField.height),
      );
      expect(
        find.descendant(of: gap, matching: find.text(base)),
        findsOneWidget,
      );
      expect(_gapText(tester, index), isEmpty);
    }

    // The gaps are set inline in the reading text, not below it.
    final firstGap = tester.getRect(find.byKey(const ValueKey('text_gap_0')));
    final secondGap = tester.getRect(find.byKey(const ValueKey('text_gap_1')));
    expect(secondGap.top, greaterThan(firstGap.bottom));
    expect(
      find.textContaining('up at seven', findRichText: true),
      findsOneWidget,
    );

    // Top bar: title, close, lightbulb; accessory bar: both icons + text button.
    expect(find.text('The Rainy Morning'), findsOneWidget);
    expect(find.byIcon(FLucideIcons.x), findsOneWidget);
    expect(find.byIcon(FLucideIcons.lightbulb), findsOneWidget);
    expect(find.byIcon(FLucideIcons.languages), findsOneWidget);
    expect(find.byIcon(FLucideIcons.arrowLeftRight), findsOneWidget);
    expect(find.text('Antwort anzeigen'), findsOneWidget);
    expect(
      tester.getTopLeft(find.byIcon(FLucideIcons.languages)).dx,
      lessThan(tester.getTopLeft(find.text('Antwort anzeigen')).dx),
    );
  });

  testWidgets(
    'Text-Übung: Balken läuft von links, Leiste sitzt über der Tastatur',
    (tester) async {
      await _pumpScreen(
        tester,
        const TextExerciseScreen(textId: 'rainy-morning'),
      );

      // Progress 1 / 3: the fill starts at the left edge and is a third wide.
      final fill = find.descendant(
        of: find.byType(TextExerciseScreen),
        matching: find.byType(FractionallySizedBox),
      );
      expect(fill, findsOneWidget);
      expect(tester.getTopLeft(fill).dx, 0);
      expect(tester.getSize(fill), const Size(125, 2));

      // With the keyboard up (300 px) the accessory bar ends where it starts.
      final reveal = find.text('Antwort anzeigen');
      expect(tester.getBottomLeft(reveal).dy, greaterThan(800));

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      final bottom = tester.getBottomLeft(reveal).dy;
      expect(bottom, lessThanOrEqualTo(900 - 300));
      expect(bottom, greaterThan(900 - 300 - 48));
      expect(find.byType(TextGapField), findsNWidgets(3));
    },
  );

  testWidgets('Text-Übung: "Antwort anzeigen" füllt Lücken nacheinander', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const TextExerciseScreen(textId: 'rainy-morning'),
    );

    // Typing works in a gap and shows the focus border state.
    await tester.tap(find.byKey(const ValueKey('text_gap_1')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('text_gap_1')), 'tak');
    expect(_gapText(tester, 1), 'tak');

    // Reveals the gap the learner works in, replacing the typed text.
    await tester.tap(find.byKey(const ValueKey('text_exercise_reveal')));
    await tester.pumpAndSettle();
    expect(_gapText(tester, 1), 'takes');
    expect(_gapText(tester, 0), isEmpty);

    // Next press: that gap is done, so the first open one follows.
    await tester.tap(find.byKey(const ValueKey('text_exercise_reveal')));
    await tester.pumpAndSettle();
    expect(_gapText(tester, 0), 'wakes');

    await tester.tap(find.byKey(const ValueKey('text_exercise_reveal')));
    await tester.pumpAndSettle();
    expect(_gapText(tester, 2), 'walks');

    // Everything revealed: a further press changes nothing.
    await tester.tap(find.byKey(const ValueKey('text_exercise_reveal')));
    await tester.pumpAndSettle();
    expect(
      [for (var i = 0; i < 3; i++) _gapText(tester, i)],
      ['wakes', 'takes', 'walks'],
    );
  });

  testWidgets('Text-Übung: unbekannter Text zeigt Hinweis statt Absturz', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const TextExerciseScreen(textId: 'gibt-es-nicht'),
    );

    expect(find.text('Dieser Text ist nicht verfügbar.'), findsOneWidget);
    expect(find.byType(TextGapField), findsNothing);
  });

  testWidgets('Wortliste: Suche filtert, Teal-Pill, Info-Sheet mit Zähler', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const WordListScreen(),
      learnedWords: _learnedWords,
    );

    expect(find.byType(WordListRow), findsAtLeastNWidgets(10));

    // Exactly one entry is "currently selected" and sits on the teal pill.
    final pill = find.byKey(const ValueKey('word_row_selected_pill'));
    expect(pill, findsOneWidget);
    final decoration =
        tester.widget<DecoratedBox>(pill).decoration as BoxDecoration;
    expect(decoration.color, AppColors.tealPill);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('word_row_cheerful')),
        matching: pill,
      ),
      findsOneWidget,
    );

    // Substring match on the headword, case-insensitive.
    final total = tester.widgetList(find.byType(WordListRow)).length;
    await tester.enterText(
      find.byKey(const ValueKey('word_search_field')),
      'BOR',
    );
    await tester.pumpAndSettle();
    expect(find.byType(WordListRow), findsNWidgets(3));
    for (final word in ['borrow', 'harbor', 'neighbor']) {
      expect(find.byKey(ValueKey('word_row_$word')), findsOneWidget);
    }
    expect(find.byKey(const ValueKey('word_row_umbrella')), findsNothing);
    expect(total, greaterThan(3));

    await tester.enterText(
      find.byKey(const ValueKey('word_search_field')),
      'zzz',
    );
    await tester.pumpAndSettle();
    expect(find.byType(WordListRow), findsNothing);
    expect(find.text('Keine Wörter gefunden.'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('word_search_field')), '');
    await tester.pumpAndSettle();
    expect(find.byType(WordListRow), findsNWidgets(total));

    // Row → info sheet on --surface, notes counter follows the input.
    await tester.tap(find.byKey(const ValueKey('word_row_cheerful')));
    await tester.pumpAndSettle();

    final sheet = find.byType(BottomSheet);
    expect(sheet, findsOneWidget);
    expect(
      tester.widget<BottomSheet>(sheet).backgroundColor,
      AppColors.surface,
    );
    expect(find.text('Informationen zum Wort'), findsOneWidget);
    expect(
      find.descendant(of: sheet, matching: find.text('cheerful')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('fröhlich')),
      findsOneWidget,
    );
    expect(find.text('Füge eigene Notizen hinzu …'), findsOneWidget);
    expect(find.text('0 / 1000'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('word_note_field')),
      'Hallo',
    );
    await tester.pumpAndSettle();
    expect(find.text('5 / 1000'), findsOneWidget);
    expect(find.text('0 / 1000'), findsNothing);

    // Closes via ✕ only — there is no primary button.
    await tester.tap(find.byKey(const ValueKey('word_info_close')));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('Wortliste: A–Z-Leiste zeigt vorhandene Buchstaben und springt', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const WordListScreen(),
      learnedWords: _learnedWords,
    );

    // Only letters with entries appear (no A, no E, no V …).
    expect(find.byKey(const ValueKey('az_B')), findsOneWidget);
    expect(find.byKey(const ValueKey('az_U')), findsOneWidget);
    expect(find.byKey(const ValueKey('az_A')), findsNothing);

    final listScrollable = find
        .descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Scrollable),
        )
        .first;
    final position = tester.state<ScrollableState>(listScrollable).position;
    expect(position.pixels, 0);

    await tester.tap(find.byKey(const ValueKey('az_U')));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThan(0));

    await tester.tap(find.byKey(const ValueKey('az_B')));
    await tester.pumpAndSettle();
    expect(position.pixels, 0);
  });

  testWidgets('Wortliste: ohne Fortschritt bleibt der Leerzustand', (
    tester,
  ) async {
    await _pumpScreen(tester, const WordListScreen(), learnedWords: const []);

    expect(find.text('Keine Wörter gefunden.'), findsOneWidget);
    expect(find.byType(WordListRow), findsNothing);
  });

  testWidgets('Wortliste: zeigt nur gelernte Wörter mit Fortschrittsdaten', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const WordListScreen(),
      learnedWords: const [
        WordListEntry(
          stackWordId: 'one',
          headword: 'alpha',
          translation: 'Alpha',
          exampleSentence: 'Alpha sentence.',
          lastSeen: 'gestern',
          repeatCount: 4,
        ),
        WordListEntry(
          stackWordId: 'two',
          headword: 'beta',
          translation: 'Beta',
          exampleSentence: 'Beta sentence.',
          lastSeen: 'vor 2 Tagen',
          repeatCount: 2,
        ),
      ],
    );

    expect(find.byType(WordListRow), findsNWidgets(2));
    expect(
      find.text('Zuletzt gesehen: gestern | Wiederholt: 4 Mal'),
      findsOneWidget,
    );
    expect(
      find.text('Zuletzt gesehen: vor 2 Tagen | Wiederholt: 2 Mal'),
      findsOneWidget,
    );
    expect(find.text('umbrella'), findsNothing);
  });
}
