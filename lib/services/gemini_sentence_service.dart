import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:sprachlern/services/sentence_generation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Builds cards through the `generate-sentence` Edge Function, which
/// translates a German sentence to English and picks a gap word. The Gemini
/// key stays in the function; the client only sends the German sentence.
class GeminiSentenceService implements SentenceGenerationService {
  GeminiSentenceService(this._functions);

  final FunctionsClient _functions;

  static const _functionName = 'generate-sentence';

  /// Leading/trailing characters that are neither letters nor digits, so a gap
  /// word like "time." becomes "time" while "don't" stays intact.
  static final _edgePunctuation = RegExp(
    r'^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$',
    unicode: true,
  );

  /// Words have no sentence yet: a local template supplies the German one —
  /// no reason to spend an LLM call on that — and the function translates it.
  @override
  Future<List<CustomStackCard>> fromWords(List<String> germanWords) =>
      _generate([
        for (final (index, word) in germanWords.indexed)
          germanTemplateSentence(word, index),
      ]);

  @override
  Future<List<CustomStackCard>> fromSentences(List<String> germanSentences) =>
      _generate(germanSentences);

  /// One call per sentence, in order. A single failure fails the whole batch,
  /// so a half-generated batch is never saved. Non-2xx responses surface as
  /// the SDK's `FunctionException`.
  Future<List<CustomStackCard>> _generate(List<String> germanSentences) async {
    final cards = <CustomStackCard>[];
    for (final germanSentence in germanSentences) {
      final response = await _functions.invoke(
        _functionName,
        body: {'germanSentence': germanSentence},
      );
      cards.add(_cardFrom(germanSentence, response.data));
    }
    return cards;
  }

  /// Rejects answers whose gap word is missing from the English sentence: such
  /// a card could never be turned into a gap exercise.
  static CustomStackCard _cardFrom(String germanSentence, Object? data) {
    if (data case {
      'englishSentence': final String englishSentence,
      'gapWord': final String gapWord,
    }) {
      final english = englishSentence.trim();
      final gap = gapWord.trim().replaceAll(_edgePunctuation, '');
      if (gap.isNotEmpty && english.toLowerCase().contains(gap.toLowerCase())) {
        return CustomStackCard(
          id: '',
          targetWord: gap,
          englishSentence: english,
          germanSentence: germanSentence,
        );
      }
    }
    throw FormatException(
      'generate-sentence returned no usable {englishSentence, gapWord} for '
      '"$germanSentence"',
      data,
    );
  }
}
