import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forui/assets.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sprachlern/services/stack_repository.dart';
import 'package:sprachlern/utils/icon_mapping.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'helpers/stack_fixtures.dart';

void main() {
  late SupabaseClient client;
  late StackRepository repository;
  late List<Uri> requests;

  setUp(() {
    requests = [];
    client = SupabaseClient(
      'https://example.invalid',
      'test-key',
      httpClient: MockClient((request) async {
        requests.add(request.url);
        final query = request.url.queryParameters;
        final isWords = request.url.path.endsWith('/stack_words');
        final id = (query[isWords ? 'stack_id' : 'id'] ?? '').replaceFirst(
          'eq.',
          '',
        );
        final rows = isWords
            ? [
                for (final word in fixtureDetails[id]!.recentWords)
                  {
                    'german_word': word.germanWord,
                    'german_example': word.germanExample,
                    'english_example': word.englishExample,
                  },
              ]
            : [
                for (final detail in fixtureDetails.values)
                  if (id.isEmpty || id == detail.stack.id)
                    {
                      'id': detail.stack.id,
                      'title': detail.stack.title,
                      'icon_name': switch (detail.stack.id) {
                        'reisen-und-alltag' => 'bookOpen',
                        'nuetzliche-gespraeche' => 'messagesSquare',
                        _ => 'folderOpen',
                      },
                      'difficulty_level': detail.stack.difficultyLevel,
                      'description': detail.description,
                      'difficulty_label': detail.difficultyLabel,
                      'new_words_seen': detail.newWordsSeen,
                      'new_words_total': detail.newWordsTotal,
                      'learned_words': detail.learnedWords,
                      'total_words': detail.totalWords,
                    },
              ];
        return http.Response(
          jsonEncode(rows),
          200,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      }),
    );
    repository = StackRepository(client);
  });
  tearDown(() async => client.dispose());

  test(
    'fetchStacks preserves all catalog fields and order without progress',
    () async {
      final stacks = await repository.fetchStacks();
      expect(stacks, hasLength(3));
      for (var i = 0; i < stacks.length; i++) {
        expect(stacks[i].id, fixtureStacks[i].id);
        expect(stacks[i].title, fixtureStacks[i].title);
        expect(stacks[i].icon, fixtureStacks[i].icon);
        expect(stacks[i].difficultyLevel, fixtureStacks[i].difficultyLevel);
        expect(stacks[i].progress, isNull);
      }
      expect(
        requests.single.queryParameters['order'],
        'sort_order.asc.nullslast',
      );
    },
  );

  test(
    'fetchStackDetail returns null for unknown id without querying words',
    () async {
      expect(await repository.fetchStackDetail('unknown'), isNull);
      expect(requests, hasLength(1));
      expect(requests.single.queryParameters['id'], 'eq.unknown');
    },
  );

  test(
    'fetchStackDetail preserves all descriptions, counts and word sentences',
    () async {
      for (final expected in fixtureDetails.values) {
        final actual = (await repository.fetchStackDetail(expected.stack.id))!;
        expect(actual.stack.id, expected.stack.id);
        expect(actual.stack.progress, isNull);
        expect(actual.description, expected.description);
        expect(actual.difficultyLabel, expected.difficultyLabel);
        expect(actual.newWordsSeen, expected.newWordsSeen);
        expect(actual.newWordsTotal, expected.newWordsTotal);
        expect(actual.learnedWords, expected.learnedWords);
        expect(actual.totalWords, expected.totalWords);
        expect(actual.recentWords, hasLength(expected.recentWords.length));
        for (var i = 0; i < actual.recentWords.length; i++) {
          expect(
            actual.recentWords[i].germanWord,
            expected.recentWords[i].germanWord,
          );
          expect(
            actual.recentWords[i].germanExample,
            expected.recentWords[i].germanExample,
          );
          expect(
            actual.recentWords[i].englishExample,
            expected.recentWords[i].englishExample,
          );
        }
        expect(
          requests.last.queryParameters['stack_id'],
          'eq.${expected.stack.id}',
        );
        expect(
          requests.last.queryParameters['order'],
          'sort_order.asc.nullslast',
        );
      }
    },
  );

  test('unknown icon names fall back to bookOpen', () {
    expect(iconForName('unknown'), FLucideIcons.bookOpen);
  });
}
