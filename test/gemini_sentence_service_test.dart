import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/services/gemini_sentence_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'helpers/fake_functions_client.dart';

void main() {
  test(
    'Wörter: lokaler deutscher Satz, Gemini liefert Englisch und Lücke',
    () async {
      final functions = FakeFunctionsClient({
        'Ich mag Essen sehr.': (
          englishSentence: 'I really like food.',
          gapWord: 'food.',
        ),
      });
      final cards = await GeminiSentenceService(functions).fromWords(['Essen']);

      // The German sentence comes from the local template, not from Gemini.
      expect(functions.requestedSentences, ['Ich mag Essen sehr.']);
      expect(cards.single.germanSentence, 'Ich mag Essen sehr.');
      expect(cards.single.englishSentence, 'I really like food.');
      // gapWord becomes the target word, edge punctuation stripped.
      expect(cards.single.targetWord, 'food');
    },
  );

  test('Sätze: Eingabe geht unverändert an die Function', () async {
    final functions = FakeFunctionsClient({
      'Ich habe keine Zeit.': (
        englishSentence: "I don't have time.",
        gapWord: "don't",
      ),
    });
    final cards = await GeminiSentenceService(functions)
        .fromSentences(['Ich habe keine Zeit.']);

    expect(functions.requestedSentences, ['Ich habe keine Zeit.']);
    expect(cards.single.germanSentence, 'Ich habe keine Zeit.');
    expect(cards.single.targetWord, "don't", reason: 'inner apostrophe kept');
  });

  test(
    'Unbrauchbare Antwort oder Function-Fehler lassen den Batch scheitern',
    () async {
      final functions = FakeFunctionsClient({})
        ..rawResponse = {
          'englishSentence': 'I really like food.',
          'gapWord': 'bread',
        };
      final service = GeminiSentenceService(functions);

      // A gap word missing from the sentence could never become a gap.
      await expectLater(
        service.fromSentences(['Ich mag Essen sehr.']),
        throwsA(isA<FormatException>()),
      );

      functions
        ..rawResponse = {'error': 'Gemini request failed'}
        ..failWith = null;
      await expectLater(
        service.fromSentences(['Ich mag Essen sehr.']),
        throwsA(isA<FormatException>()),
      );

      functions.failWith = const FunctionException(status: 502);
      await expectLater(
        service.fromSentences(['Ich mag Essen sehr.']),
        throwsA(isA<FunctionException>()),
      );
    },
  );
}
