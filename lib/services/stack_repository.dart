import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/utils/icon_mapping.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads the global catalog; clients have no write access.
class StackRepository {
  StackRepository(this._client);

  final SupabaseClient _client;

  Future<List<VocabularyStackData>> fetchStacks() async {
    final rows = await _client
        .from('stacks')
        .select()
        .order('sort_order', ascending: true);
    return [for (final row in rows) _stackFromRow(row)];
  }

  Future<StackDetailData?> fetchStackDetail(String stackId) async {
    final row = await _client
        .from('stacks')
        .select()
        .eq('id', stackId)
        .maybeSingle();
    if (row == null) return null;
    final words = await _client
        .from('stack_words')
        .select()
        .eq('stack_id', stackId)
        .order('sort_order', ascending: true);
    return StackDetailData(
      stack: _stackFromRow(row),
      description: row['description'] as String,
      difficultyLabel: row['difficulty_label'] as String,
      newWordsSeen: row['new_words_seen'] as int,
      newWordsTotal: row['new_words_total'] as int,
      learnedWords: row['learned_words'] as int,
      totalWords: row['total_words'] as int,
      recentWords: [
        for (final word in words)
          RecentWordEntry(
            germanWord: word['german_word'] as String,
            germanExample: word['german_example'] as String,
            englishExample: word['english_example'] as String,
          ),
      ],
    );
  }

  // Resolve stored icon names at the boundary, keeping UI models unchanged.
  static VocabularyStackData _stackFromRow(Map<String, dynamic> row) =>
      VocabularyStackData(
        id: row['id'] as String,
        icon: iconForName(row['icon_name'] as String),
        title: row['title'] as String,
        difficultyLevel: row['difficulty_level'] as int,
        progress: null,
      );
}
