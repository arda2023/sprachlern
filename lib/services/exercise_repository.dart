import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Loads due and new cards for the authenticated user through Supabase RPC.
class ExerciseRepository {
  ExerciseRepository(this._client);

  final SupabaseClient _client;

  Future<List<Map<String, dynamic>>> fetchNextCards(
    String stackId, {
    int limit = 20,
  }) async {
    try {
      final rows = await _client.rpc(
        'get_next_cards',
        params: {'p_stack_id': stackId, 'p_limit': limit},
      );
      return [
        for (final row in rows as List) Map<String, dynamic>.from(row as Map),
      ];
    } catch (error) {
      final message = StringBuffer()
        ..writeln('ExerciseRepository.get_next_cards failed')
        ..writeln('type: ${error.runtimeType}');
      if (error is PostgrestException) {
        message
          ..writeln('message: ${error.message}')
          ..writeln('code: ${error.code}')
          ..writeln('details: ${error.details}')
          ..writeln('hint: ${error.hint}');
      } else {
        message.writeln('message: $error');
      }
      debugPrint(message.toString());
      rethrow;
    }
  }

  Future<void> submitAnswer(String stackWordId, bool correct) async {
    await _client.rpc(
      'submit_answer',
      params: {'p_stack_word_id': stackWordId, 'p_correct': correct},
    );
  }
}
