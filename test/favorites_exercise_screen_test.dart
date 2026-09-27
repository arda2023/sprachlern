import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/models/word_list_data.dart';
import 'package:sprachlern/providers/content_provider.dart';
import 'package:sprachlern/providers/word_list_provider.dart';
import 'package:sprachlern/screens/favorites_exercise_screen.dart';
import 'package:sprachlern/screens/stack_list_screen.dart';
import 'package:sprachlern/services/word_list_repository.dart';
import 'package:sprachlern/widgets/diff_input_field.dart';
import 'package:sprachlern/widgets/fill_in_card.dart';
import 'package:sprachlern/widgets/stack_list_item.dart';

class _FavoritesRepository extends WordListRepository {
  _FavoritesRepository(this.entries)
    : super(
        SupabaseClient(
          'https://example.supabase.co',
          'test-key',
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      );

  final List<WordListEntry> entries;
  int fetchFavoritesCalls = 0;
  int setFavoriteCalls = 0;

  @override
  Future<List<WordListEntry>> fetchFavorites() async {
    fetchFavoritesCalls++;
    return entries;
  }

  @override
  Future<void> setFavorite(String stackWordId, bool favorite) async {
    setFavoriteCalls++;
  }
}

const _favoriteEntries = [
  WordListEntry(
    stackWordId: 'favorite-call',
    headword: 'call',
    translation: 'anrufen',
    exampleSentence: 'Please call me.',
    lastSeen: 'gestern',
    repeatCount: 2,
    isFavorite: true,
  ),
  WordListEntry(
    stackWordId: 'favorite-book',
    headword: 'book',
    translation: 'buchen',
    exampleSentence: 'We should book a room.',
    lastSeen: 'vor 2 Tagen',
    repeatCount: 1,
    isFavorite: true,
  ),
];

void _phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(375, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

Future<void> _pumpFavorites(
  WidgetTester tester,
  _FavoritesRepository repository,
) async {
  _phoneSize(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [wordListRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: FavoritesExerciseScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Favoriten-Übung zeigt Diff-Eingabe ohne SM-2-Aufruf', (
    tester,
  ) async {
    final repository = _FavoritesRepository(_favoriteEntries.toList());
    await _pumpFavorites(tester, repository);

    expect(find.byType(FillInCard), findsOneWidget);
    expect(find.byType(DiffInputField), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('diff_input_text_field')),
      'xyz',
    );
    await tester.tap(find.byKey(const ValueKey('exercise_action')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('diff_input_hint')), findsOneWidget);
    expect(repository.setFavoriteCalls, 0);

    await tester.enterText(
      find.byKey(const ValueKey('diff_input_text_field')),
      'book',
    );
    expect(
      tester
          .widget<TextField>(
            find.byKey(const ValueKey('diff_input_text_field')),
          )
          .controller
          ?.text,
      'book',
    );
    expect(find.text('Eingeben'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('exercise_action')));
    await tester.pumpAndSettle();
    expect(find.text('Weiter'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('exercise_action')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('favorites_exercise_card_1')),
      findsOneWidget,
    );
    expect(repository.setFavoriteCalls, 0);
  });

  testWidgets('Leere Favoriten-Übung zeigt einen Leerzustand', (tester) async {
    await _pumpFavorites(tester, _FavoritesRepository([]));

    expect(find.text('Du hast noch keine Favoriten.'), findsOneWidget);
    expect(find.byType(FillInCard), findsNothing);
  });

  testWidgets('Stapel-Liste zeigt Favoriten nur bei vorhandenen Einträgen', (
    tester,
  ) async {
    final stacks = [
      const VocabularyStackData(
        id: 'stack-1',
        icon: Icons.layers,
        title: 'Reisen',
        difficultyLevel: 1,
      ),
    ];
    final repository = _FavoritesRepository(_favoriteEntries.toList());
    _phoneSize(tester);
    final router = GoRouter(
      initialLocation: '/stacks',
      routes: [
        GoRoute(path: '/stacks', builder: (_, _) => const StackListScreen()),
        GoRoute(
          path: '/favorites/exercise',
          builder: (_, _) => const FavoritesExerciseScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stackListProvider.overrideWith((ref) async => stacks),
          wordListRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('stack_item_favoriten')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('stack_item_favoriten')));
    await tester.pumpAndSettle();
    expect(find.byType(FavoritesExerciseScreen), findsOneWidget);
  });

  testWidgets('Stapel-Liste blendet Favoriten ohne Einträge aus', (
    tester,
  ) async {
    final repository = _FavoritesRepository([]);
    _phoneSize(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stackListProvider.overrideWith((ref) async => const []),
          wordListRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: StackListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Favoriten'), findsNothing);
    expect(find.byType(StackListItem), findsNothing);
  });
}
