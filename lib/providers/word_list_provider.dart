import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/word_list_data.dart';

const _mockWords = [
  WordListEntry(
    headword: 'umbrella',
    translation: 'Regenschirm',
    exampleSentence: 'Take an umbrella, it might rain.',
    lastSeen: 'vor 2 Tagen',
    repeatCount: 3,
  ),
  WordListEntry(
    headword: 'bridge',
    translation: 'Brücke',
    exampleSentence: 'The bridge is closed today.',
    lastSeen: 'vor 5 Tagen',
    repeatCount: 1,
  ),
  WordListEntry(
    headword: 'cheerful',
    translation: 'fröhlich',
    exampleSentence: 'She is a cheerful girl.',
    lastSeen: 'vor 1 Woche',
    repeatCount: 2,
    isCurrentlySelected: true,
  ),
  WordListEntry(
    headword: 'borrow',
    translation: 'ausleihen',
    exampleSentence: 'Can I borrow your pen?',
    lastSeen: 'vor 3 Tagen',
    repeatCount: 4,
  ),
  WordListEntry(
    headword: 'delay',
    translation: 'Verspätung',
    exampleSentence: 'The train has a short delay.',
    lastSeen: 'gestern',
    repeatCount: 2,
  ),
  WordListEntry(
    headword: 'harbor',
    translation: 'Hafen',
    exampleSentence: 'We walked along the harbor.',
    lastSeen: 'vor 2 Wochen',
    repeatCount: 1,
  ),
  WordListEntry(
    headword: 'journey',
    translation: 'Reise',
    exampleSentence: 'It was a long journey.',
    lastSeen: 'vor 4 Tagen',
    repeatCount: 3,
  ),
  WordListEntry(
    headword: 'knowledge',
    translation: 'Wissen',
    exampleSentence: 'Knowledge is power.',
    lastSeen: 'vor 6 Tagen',
    repeatCount: 1,
  ),
  WordListEntry(
    headword: 'lantern',
    translation: 'Laterne',
    exampleSentence: 'He lit the lantern at dusk.',
    lastSeen: 'vor 3 Wochen',
    repeatCount: 1,
  ),
  WordListEntry(
    headword: 'meadow',
    translation: 'Wiese',
    exampleSentence: 'Cows were grazing in the meadow.',
    lastSeen: 'vor 9 Tagen',
    repeatCount: 2,
  ),
  WordListEntry(
    headword: 'neighbor',
    translation: 'Nachbar',
    exampleSentence: 'My neighbor plays the piano.',
    lastSeen: 'vor 2 Tagen',
    repeatCount: 5,
  ),
  WordListEntry(
    headword: 'quiet',
    translation: 'leise',
    exampleSentence: 'Please be quiet in the library.',
    lastSeen: 'vor 1 Woche',
    repeatCount: 2,
  ),
  WordListEntry(
    headword: 'reliable',
    translation: 'zuverlässig',
    exampleSentence: 'He is a reliable friend.',
    lastSeen: 'vor 12 Tagen',
    repeatCount: 1,
  ),
  WordListEntry(
    headword: 'sunrise',
    translation: 'Sonnenaufgang',
    exampleSentence: 'We watched the sunrise together.',
    lastSeen: 'gestern',
    repeatCount: 3,
  ),
];

/// Sorted alphabetically (case-insensitive) — the A–Z bar relies on it.
final wordListProvider = Provider<List<WordListEntry>>(
  (ref) => [..._mockWords]
    ..sort(
      (a, b) => a.headword.toLowerCase().compareTo(b.headword.toLowerCase()),
    ),
);

/// `null` for a headword that is not in the list.
final wordInfoProvider = Provider.family<WordInfoData?, String>((
  ref,
  headword,
) {
  for (final entry in ref.watch(wordListProvider)) {
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
