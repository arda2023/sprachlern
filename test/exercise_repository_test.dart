import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sprachlern/services/exercise_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test(
    'fetchNextCards passes stack and limit and returns raw RPC rows',
    () async {
      final rows = [
        {
          'stack_word_id': 'word-id',
          'german_word': 'Gepäck',
          'german_example': 'Mein Gepäck ist noch nicht angekommen.',
          'english_example': 'My luggage has not arrived yet.',
          'memory_level': 2,
        },
      ];
      final client = SupabaseClient(
        'https://example.invalid',
        'test-key',
        httpClient: MockClient((request) async {
          expect(request.url.path, '/rest/v1/rpc/get_next_cards');
          expect(jsonDecode(request.body), {
            'p_stack_id': 'reisen-und-alltag',
            'p_limit': 3,
          });
          return http.Response(
            jsonEncode(rows),
            200,
            request: request,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      addTearDown(client.dispose);

      expect(
        await ExerciseRepository(client)
            .fetchNextCards('reisen-und-alltag', limit: 3),
        rows,
      );
    },
  );

  for (final correct in [false, true]) {
    test('submitAnswer sends correctness $correct to Supabase RPC', () async {
      var calls = 0;
      final client = SupabaseClient(
        'https://example.invalid',
        'test-key',
        httpClient: MockClient((request) async {
          calls++;
          expect(request.url.path, '/rest/v1/rpc/submit_answer');
          expect(jsonDecode(request.body), {
            'p_stack_word_id': 'word-id',
            'p_correct': correct,
          });
          return http.Response('', 204, request: request);
        }),
      );
      addTearDown(client.dispose);

      await ExerciseRepository(client).submitAnswer('word-id', correct);
      expect(calls, 1);
    });
  }
}
