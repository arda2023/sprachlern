import 'package:sprachlern/models/custom_stack_data.dart';

/// Turns raw user input into learnable cards.
///
/// The methods are asynchronous on purpose: this mock is a placeholder for a
/// real LLM call routed through a Supabase Edge Function (see CLAUDE.md,
/// "KI-Anbindung (geplant)"), so the API key never reaches the client bundle.
/// Swapping the implementation must not require any caller changes.
abstract class SentenceGenerationService {
  Future<List<CustomStackCard>> fromWords(List<String> germanWords);

  Future<List<CustomStackCard>> fromSentences(List<String> germanSentences);
}

class MockSentenceGenerationService implements SentenceGenerationService {
  MockSentenceGenerationService();

  int _nextId = 0;

  static const _templates = [
    'Ich mag {word} sehr.',
    'Wir haben gestern über {word} gesprochen.',
    'Kannst du mir {word} erklären?',
    'Heute geht es um {word}.',
  ];

  /// Characters stripped before measuring word length in [fromSentences].
  static final _punctuation = RegExp(r'''^[^\wÄÖÜäöüß]+|[^\wÄÖÜäöüß]+$''');

  String _id() => 'card-${_nextId++}';

  @override
  Future<List<CustomStackCard>> fromWords(List<String> germanWords) async => [
    for (final (index, word) in germanWords.indexed)
      CustomStackCard(
        id: _id(),
        targetWord: word,
        germanSentence: _templates[index % _templates.length].replaceAll(
          '{word}',
          word,
        ),
      ),
  ];

  /// Heuristic: the longest word of the sentence becomes the target, ties going
  /// to the first occurrence. Leading/trailing punctuation is ignored when
  /// measuring. This is a deliberate placeholder — a real LLM will later pick
  /// the pedagogically interesting word instead.
  @override
  Future<List<CustomStackCard>> fromSentences(
    List<String> germanSentences,
  ) async => [
    for (final sentence in germanSentences)
      CustomStackCard(
        id: _id(),
        targetWord: _longestWord(sentence),
        germanSentence: sentence,
      ),
  ];

  String _longestWord(String sentence) {
    var longest = '';
    for (final token in sentence.split(RegExp(r'\s+'))) {
      final word = token.replaceAll(_punctuation, '');
      if (word.length > longest.length) longest = word;
    }
    return longest;
  }
}
