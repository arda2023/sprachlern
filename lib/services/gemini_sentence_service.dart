import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:sprachlern/services/sentence_generation_service.dart';

/// Placeholder for the LLM-backed generator behind the `generate-sentence`
/// Edge Function.
///
/// Deliberately not implemented: the function translates German to English and
/// returns `{englishSentence, gapWord}`, while [CustomStackCard] stores a
/// German target word and a German sentence. See NEXTSTEPS.md, section
/// "BLOCKED — Edge-Function-Contract", before wiring this up.
class GeminiSentenceService implements SentenceGenerationService {
  const GeminiSentenceService();

  @override
  Future<List<CustomStackCard>> fromWords(List<String> germanWords) =>
      throw UnimplementedError(_blocked);

  @override
  Future<List<CustomStackCard>> fromSentences(List<String> germanSentences) =>
      throw UnimplementedError(_blocked);

  static const _blocked =
      'generate-sentence returns an English translation, but CustomStackCard '
      'needs German content — see NEXTSTEPS.md, "BLOCKED".';
}
