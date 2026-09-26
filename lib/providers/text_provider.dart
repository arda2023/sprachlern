import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/text_data.dart';

const _mockCovers = [
  TextCoverData(
    id: 'rainy-morning',
    title: 'The Rainy Morning',
    levelLabel: 'A1',
    palette: TextCoverPalette.dark,
  ),
  TextCoverData(
    id: 'market-trip',
    title: 'A Trip to the Market',
    levelLabel: 'A1',
    palette: TextCoverPalette.purple,
  ),
  TextCoverData(
    id: 'new-bike',
    title: 'Lena’s New Bike',
    levelLabel: 'A2',
    palette: TextCoverPalette.dark,
  ),
  TextCoverData(
    id: 'old-library',
    title: 'The Old Library',
    levelLabel: 'B1',
    palette: TextCoverPalette.purple,
  ),
];

// Gaps ask for the third-person form of a verb; the base form is the
// placeholder (design.md 5.8).
const _mockExercises = <String, TextExerciseData>{
  'rainy-morning': TextExerciseData(
    title: 'The Rainy Morning',
    currentCard: 1,
    totalCards: 3,
    segments: [
      PlainTextSegment('Tom '),
      GapSegment(baseWord: 'wake', answer: 'wakes'),
      PlainTextSegment(
        " up at seven o'clock. Outside, the sky is grey and the streets are "
        'wet.\n\nHe ',
      ),
      GapSegment(baseWord: 'take', answer: 'takes'),
      PlainTextSegment(' his umbrella from the hall and '),
      GapSegment(baseWord: 'walk', answer: 'walks'),
      PlainTextSegment(
        ' to the bus stop. The bus is late, so he reads a short story on his '
        'phone.',
      ),
    ],
  ),
  'market-trip': TextExerciseData(
    title: 'A Trip to the Market',
    currentCard: 1,
    totalCards: 3,
    segments: [
      PlainTextSegment('On Saturday, Maria '),
      GapSegment(baseWord: 'go', answer: 'goes'),
      PlainTextSegment(' to the market with her brother. He '),
      GapSegment(baseWord: 'carry', answer: 'carries'),
      PlainTextSegment(' the heavy bags.\n\nAt the fruit stall, Maria '),
      GapSegment(baseWord: 'choose', answer: 'chooses'),
      PlainTextSegment(
        ' five red apples. The seller smiles and says thank you.',
      ),
    ],
  ),
  'new-bike': TextExerciseData(
    title: 'Lena’s New Bike',
    currentCard: 1,
    totalCards: 3,
    segments: [
      PlainTextSegment('Lena '),
      GapSegment(baseWord: 'love', answer: 'loves'),
      PlainTextSegment(
        ' her new bike. It is bright yellow and very light.\n\nEvery '
        'afternoon, she ',
      ),
      GapSegment(baseWord: 'ride', answer: 'rides'),
      PlainTextSegment(' along the river and '),
      GapSegment(baseWord: 'wave', answer: 'waves'),
      PlainTextSegment(' at the boats on the water.'),
    ],
  ),
  'old-library': TextExerciseData(
    title: 'The Old Library',
    currentCard: 1,
    totalCards: 3,
    segments: [
      PlainTextSegment(
        'The library in our town is more than a hundred years old. A '
        'friendly woman ',
      ),
      GapSegment(baseWord: 'run', answer: 'runs'),
      PlainTextSegment(
        ' it, and she knows every book on the shelves.\n\nOn quiet '
        'evenings, a student ',
      ),
      GapSegment(baseWord: 'sit', answer: 'sits'),
      PlainTextSegment(' by the window and '),
      GapSegment(baseWord: 'read', answer: 'reads'),
      PlainTextSegment(' until closing time.'),
    ],
  ),
};

final textCoversProvider = Provider<List<TextCoverData>>((ref) => _mockCovers);

/// `null` for an unknown text id.
final textExerciseProvider = Provider.family<TextExerciseData?, String>(
  (ref, id) => _mockExercises[id],
);
