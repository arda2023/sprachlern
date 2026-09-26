import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:sprachlern/services/sentence_generation_service.dart';

/// Swap this override to move from the mock to the LLM-backed implementation.
final sentenceGenerationServiceProvider = Provider<SentenceGenerationService>(
  (ref) => MockSentenceGenerationService(),
);

class CustomStackNotifier extends Notifier<CustomStack> {
  @override
  CustomStack build() => const CustomStack();

  /// Entries are separated by `;`, trimmed, and empty ones dropped.
  List<String> _split(String rawInput) => [
    for (final part in rawInput.split(';'))
      if (part.trim().isNotEmpty) part.trim(),
  ];

  Future<void> addFromWords(String rawInput) async {
    final words = _split(rawInput);
    if (words.isEmpty) return;
    await _append(
      (service) => service.fromWords(words),
    );
  }

  Future<void> addFromText(String rawInput) async {
    final sentences = _split(rawInput);
    if (sentences.isEmpty) return;
    await _append(
      (service) => service.fromSentences(sentences),
    );
  }

  Future<void> _append(
    Future<List<CustomStackCard>> Function(SentenceGenerationService) generate,
  ) async {
    final cards = await generate(ref.read(sentenceGenerationServiceProvider));
    state = state.copyWith(cards: [...state.cards, ...cards]);
  }
}

final customStackProvider = NotifierProvider<CustomStackNotifier, CustomStack>(
  CustomStackNotifier.new,
);
