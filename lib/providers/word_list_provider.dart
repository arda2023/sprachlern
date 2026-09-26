import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/word_list_data.dart';
import 'package:sprachlern/services/supabase_client.dart';
import 'package:sprachlern/services/word_list_repository.dart';

final wordListRepositoryProvider = Provider<WordListRepository>(
  (ref) => WordListRepository(ref.watch(supabaseClientProvider)),
);

/// Learned words are loaded from user_word_progress and sorted for the A–Z bar.
final wordListProvider = FutureProvider<List<WordListEntry>>((ref) async {
  final entries = await ref
      .watch(wordListRepositoryProvider)
      .fetchLearnedWords();
  return [...entries]..sort(
    (a, b) => a.headword.toLowerCase().compareTo(b.headword.toLowerCase()),
  );
});

/// `null` for a headword that is not in the learned-word list.
final wordInfoProvider = FutureProvider.family<WordInfoData?, String>((
  ref,
  headword,
) async {
  final entries = await ref.watch(wordListProvider.future);
  for (final entry in entries) {
    if (entry.headword == headword) {
      return WordInfoData(
        headword: entry.headword,
        translation: entry.translation,
        exampleSentence: entry.exampleSentence,
      );
    }
  }
  return null;
});
