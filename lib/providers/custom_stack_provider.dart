import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/services/custom_stack_repository.dart';
import 'package:sprachlern/services/sentence_generation_service.dart';
import 'package:sprachlern/services/supabase_client.dart';

/// Stays on the mock until the Edge Function contract is settled — see
/// `GeminiSentenceService` and NEXTSTEPS.md, "BLOCKED".
final sentenceGenerationServiceProvider = Provider<SentenceGenerationService>(
  (ref) => MockSentenceGenerationService(),
);

final customStackRepositoryProvider = Provider<CustomStackRepository>(
  (ref) => CustomStackRepository(ref.watch(supabaseClientProvider)),
);

/// Holds the signed-in user's stack as loaded from Supabase.
///
/// The state stays a plain [CustomStack] (empty until the load completes)
/// because the custom stack screens read it synchronously and were out of
/// scope for this change; see NEXTSTEPS.md.
class CustomStackNotifier extends Notifier<CustomStack> {
  /// Completes with the stack's database id once the initial load is done;
  /// `null` while nobody is signed in.
  Future<String>? _stackId;

  @override
  CustomStack build() {
    // Watching the user makes a sign-in as someone else reload their stack
    // instead of keeping the previous user's cards in memory.
    final userId = ref.watch(currentUserIdProvider);
    _stackId = userId == null ? null : _load();
    return const CustomStack();
  }

  Future<String> _load() async {
    final loaded = await ref.read(customStackRepositoryProvider).loadStack();
    // A rebuild (e.g. a user switch) makes this ref stale; drop the result.
    if (ref.mounted) state = loaded.stack;
    return loaded.id;
  }

  /// Entries are separated by `;`, trimmed, and empty ones dropped.
  List<String> _split(String rawInput) => [
    for (final part in rawInput.split(';'))
      if (part.trim().isNotEmpty) part.trim(),
  ];

  Future<void> addFromWords(String rawInput) async {
    final words = _split(rawInput);
    if (words.isEmpty) return;
    await _append((service) => service.fromWords(words));
  }

  Future<void> addFromText(String rawInput) async {
    final sentences = _split(rawInput);
    if (sentences.isEmpty) return;
    await _append((service) => service.fromSentences(sentences));
  }

  /// Generates cards, stores them, then appends the rows the insert returned —
  /// no refetch, and only confirmed rows reach the state.
  Future<void> _append(
    Future<List<CustomStackCard>> Function(SentenceGenerationService) generate,
  ) async {
    final pendingStackId = _stackId;
    if (pendingStackId == null) {
      throw StateError('No signed-in user: cannot save cards.');
    }
    final service = ref.read(sentenceGenerationServiceProvider);
    final repository = ref.read(customStackRepositoryProvider);

    final stackId = await pendingStackId;
    final saved = await repository.insertCards(
      stackId,
      await generate(service),
    );

    if (ref.mounted) state = state.copyWith(cards: [...state.cards, ...saved]);
  }
}

final customStackProvider = NotifierProvider<CustomStackNotifier, CustomStack>(
  CustomStackNotifier.new,
);
