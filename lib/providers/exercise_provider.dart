import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/exercise_data.dart';

const _mockExercise = ExerciseData(
  tokens: [
    ExerciseToken(text: 'I', germanTranslation: 'Ich'),
    ExerciseToken(text: 'could', germanTranslation: 'könnte'),
    ExerciseToken(text: '', isBlank: true),
    ExerciseToken(text: 'you', germanTranslation: 'dich'),
    ExerciseToken(text: 'tomorrow.', germanTranslation: 'morgen.'),
  ],
  wordStatus: 1,
  targetAnswer: 'call',
  germanHeadword: 'anrufen',
  germanExampleSentence: 'Ich könnte dich morgen anrufen.',
  currentCard: 24,
  totalCards: 50,
  grammarHintTitle: 'Modalverb „could“',
  grammarHintDescription: 'Nach „could“ steht das Verb immer in der Grundform. Deshalb heißt es „could call“ und nicht „could called“.',
);

final exerciseProvider = Provider<ExerciseData>((ref) => _mockExercise);
