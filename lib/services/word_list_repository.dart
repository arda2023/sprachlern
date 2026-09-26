import 'package:sprachlern/models/word_list_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads the words the signed-in user has already practised.
class WordListRepository {
  WordListRepository(this._client);

  final SupabaseClient _client;

  Future<List<WordListEntry>> fetchLearnedWords() async {
    final rows = await _client.from('user_word_progress').select('''
      stack_word_id,
      repetitions,
      last_seen_at,
      is_favorite,
      is_deactivated,
      is_in_playlist,
      stack_words!inner(
        target_word,
        german_word,
        english_example
      )
    ''');

    return [for (final row in rows) _entryFromRow(row)];
  }

  static WordListEntry _entryFromRow(Map<String, dynamic> row) {
    final stackWord = row['stack_words'] as Map<String, dynamic>;
    return WordListEntry(
      stackWordId: row['stack_word_id'] as String,
      headword: stackWord['target_word'] as String,
      translation: stackWord['german_word'] as String,
      exampleSentence: stackWord['english_example'] as String,
      lastSeen: _formatLastSeen(_dateTimeOrNull(row['last_seen_at'])),
      repeatCount: row['repetitions'] as int? ?? 0,
      isFavorite: row['is_favorite'] as bool? ?? false,
      isDeactivated: row['is_deactivated'] as bool? ?? false,
      isInPlaylist: row['is_in_playlist'] as bool? ?? false,
    );
  }

  static DateTime? _dateTimeOrNull(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static String _formatLastSeen(DateTime? seenAt) {
    if (seenAt == null) return 'noch nicht gesehen';

    final elapsed = DateTime.now().difference(seenAt.toLocal());
    if (elapsed.isNegative || elapsed.inMinutes < 1) return 'gerade eben';
    if (elapsed.inHours < 1) {
      return 'vor ${elapsed.inMinutes} ${elapsed.inMinutes == 1 ? 'Minute' : 'Minuten'}';
    }
    if (elapsed.inDays == 0) {
      return 'vor ${elapsed.inHours} ${elapsed.inHours == 1 ? 'Stunde' : 'Stunden'}';
    }
    if (elapsed.inDays == 1) return 'gestern';
    if (elapsed.inDays < 7) return 'vor ${elapsed.inDays} Tagen';
    final weeks = elapsed.inDays ~/ 7;
    if (weeks < 5) return 'vor $weeks ${weeks == 1 ? 'Woche' : 'Wochen'}';
    final months = elapsed.inDays ~/ 30;
    return 'vor $months ${months == 1 ? 'Monat' : 'Monaten'}';
  }
}
