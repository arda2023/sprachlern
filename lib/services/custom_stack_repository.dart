import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads and writes the signed-in user's custom stack in Supabase
/// (`custom_stacks` / `custom_stack_cards`, access guarded by RLS).
class CustomStackRepository {
  CustomStackRepository(this._client);

  final SupabaseClient _client;

  static const _stacksTable = 'custom_stacks';
  static const _cardsTable = 'custom_stack_cards';
  static const _cardColumns = 'id, target_word, german_sentence';

  /// Loads the user's stack together with its cards. There is one stack per
  /// user for now; it is created with the default name on first access.
  ///
  /// The id is returned beside the model because [CustomStack] has no id
  /// field, yet inserting cards needs it.
  Future<({String id, CustomStack stack})> loadStack() async {
    final userId = _requireUserId();

    // Oldest first, so a duplicate from a concurrent first access never wins.
    final existing = await _client
        .from(_stacksTable)
        .select('id, name')
        .eq('user_id', userId)
        .order('created_at')
        .limit(1)
        .maybeSingle();

    final row =
        existing ??
        await _client
            .from(_stacksTable)
            .insert({'user_id': userId, 'name': const CustomStack().name})
            .select('id, name')
            .single();

    final id = row['id'].toString();
    return (
      id: id,
      stack: CustomStack(
        name: row['name'] as String,
        cards: await fetchCards(id),
      ),
    );
  }

  Future<List<CustomStackCard>> fetchCards(String stackId) async {
    final rows = await _client
        .from(_cardsTable)
        .select(_cardColumns)
        .eq('stack_id', stackId)
        // A batch insert gives every row the same created_at; id breaks ties.
        .order('created_at')
        .order('id');
    return [for (final row in rows) _cardFromRow(row)];
  }

  /// Inserts [cards] in one request and returns them as stored, i.e. with the
  /// ids the database assigned. The incoming ids are discarded.
  Future<List<CustomStackCard>> insertCards(
    String stackId,
    List<CustomStackCard> cards,
  ) async {
    if (cards.isEmpty) return const [];

    final rows = await _client
        .from(_cardsTable)
        .insert([
          for (final card in cards)
            {
              'stack_id': stackId,
              'target_word': card.targetWord,
              'german_sentence': card.germanSentence,
            },
        ])
        .select(_cardColumns);
    return [for (final row in rows) _cardFromRow(row)];
  }

  String _requireUserId() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('No signed-in user: the custom stack is per user.');
    }
    return userId;
  }

  static CustomStackCard _cardFromRow(Map<String, dynamic> row) =>
      CustomStackCard(
        id: row['id'].toString(),
        targetWord: row['target_word'] as String,
        germanSentence: row['german_sentence'] as String,
      );
}
