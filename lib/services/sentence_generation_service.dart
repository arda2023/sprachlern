import 'package:sprachlern/models/custom_stack_data.dart';

/// Turns raw user input into learnable cards.
///
/// Asynchronous because the implementation calls an LLM through a Supabase
/// Edge Function, so the API key never reaches the client bundle.
abstract class SentenceGenerationService {
  Future<List<CustomStackCard>> fromWords(List<String> germanWords);

  Future<List<CustomStackCard>> fromSentences(List<String> germanSentences);
}

const _germanTemplates = [
  'Ich mag {word} sehr.',
  'Wir haben gestern über {word} gesprochen.',
  'Kannst du mir {word} erklären?',
  'Heute geht es um {word}.',
];

/// A German example sentence around [word]. Word input has no sentence of its
/// own; [index] cycles through a few templates so a batch reads less uniform.
String germanTemplateSentence(String word, int index) =>
    _germanTemplates[index % _germanTemplates.length].replaceAll(
      '{word}',
      word,
    );
