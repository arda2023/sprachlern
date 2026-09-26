import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/exercise_data.dart';
import 'package:sprachlern/services/exercise_repository.dart';
import 'package:sprachlern/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => ExerciseRepository(ref.watch(supabaseClientProvider)),
);

class ExerciseSession {
  const ExerciseSession({
    required this.cards,
    this.currentIndex = 0,
    this.isSubmitting = false,
    this.submitError,
  });

  final List<ExerciseData> cards;
  final int currentIndex;
  final bool isSubmitting;
  final String? submitError;

  ExerciseData? get currentExercise =>
      currentIndex < cards.length ? cards[currentIndex] : null;
}

class ExerciseNotifier extends AsyncNotifier<ExerciseSession> {
  ExerciseNotifier(this.stackId);

  final String stackId;
  late ExerciseRepository _repository;

  @override
  Future<ExerciseSession> build() async {
    _repository = ref.watch(exerciseRepositoryProvider);
    try {
      final rows = await _repository.fetchNextCards(stackId);
      return ExerciseSession(
        cards: List.unmodifiable([
          for (final (index, row) in rows.indexed)
            _exerciseFromRow(row, index + 1, rows.length),
        ]),
      );
    } catch (error) {
      final message = StringBuffer()
        ..writeln('ExerciseNotifier.get_next_cards failed')
        ..writeln('type: ${error.runtimeType}');
      if (error is PostgrestException) {
        message
          ..writeln('message: ${error.message}')
          ..writeln('code: ${error.code}')
          ..writeln('details: ${error.details}')
          ..writeln('hint: ${error.hint}');
      } else {
        message.writeln('message: $error');
      }
      debugPrint(message.toString());
      rethrow;
    }
  }

  Future<void> submitAnswer(bool correct) async {
    final session = state.asData?.value;
    final exercise = session?.currentExercise;
    if (session == null || exercise == null || session.isSubmitting) return;

    state = AsyncData(
      ExerciseSession(
        cards: session.cards,
        currentIndex: session.currentIndex,
        isSubmitting: true,
      ),
    );
    try {
      final wordId = exercise.stackWordId;
      if (wordId != null) await _repository.submitAnswer(wordId, correct);
      if (!ref.mounted) return;
      state = AsyncData(
        ExerciseSession(
          cards: session.cards,
          currentIndex: session.currentIndex + 1,
        ),
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = AsyncData(
        ExerciseSession(
          cards: session.cards,
          currentIndex: session.currentIndex,
          submitError: 'Die Antwort konnte nicht gespeichert werden.',
        ),
      );
      rethrow;
    }
  }

  static ExerciseData _exerciseFromRow(
    Map<String, dynamic> row,
    int currentCard,
    int totalCards,
  ) {
    final sentence = (row['english_example'] as String).trim();
    final target = (row['target_word'] as String?)?.trim();
    if (target == null || target.isEmpty) {
      throw FormatException('Missing target_word for ${row['stack_word_id']}');
    }
    // Match whole words/phrases; keep punctuation outside the blank.
    final match = RegExp(
      r'(^|[^\p{L}\p{N}])' + RegExp.escape(target) + r'(?=$|[^\p{L}\p{N}])',
      caseSensitive: false,
      unicode: true,
    ).firstMatch(sentence);
    if (match == null) {
      throw FormatException('target_word is absent from english_example');
    }
    final start = match.start + match.group(1)!.length;
    List<ExerciseToken> tokensFor(String text) => [
      for (final word in text.trim().split(RegExp(r'\s+')))
        if (word.isNotEmpty) ExerciseToken(text: word),
    ];
    return ExerciseData(
      stackWordId: row['stack_word_id'] as String,
      tokens: [
        ...tokensFor(sentence.substring(0, start)),
        const ExerciseToken(text: '', isBlank: true),
        ...tokensFor(sentence.substring(start + target.length)),
      ],
      wordStatus: row['memory_level'] as int,
      targetAnswer: sentence.substring(start, start + target.length),
      germanHeadword: row['german_word'] as String,
      germanExampleSentence: row['german_example'] as String,
      currentCard: currentCard,
      totalCards: totalCards,
      // The RPC provides no token translations or grammar explanation.
      grammarHintTitle: 'Grammatikhinweis',
      grammarHintDescription:
          'Für diese Karte ist kein Grammatikhinweis verfügbar.',
    );
  }
}

final exerciseProvider =
    AsyncNotifierProvider.family<ExerciseNotifier, ExerciseSession, String>(
      ExerciseNotifier.new,
    );
