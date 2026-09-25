import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/grammar_exercise_data.dart';

const _mockGrammarExercise = GrammarExerciseData(
  sentenceWithGap: 'We went through the ___ check together.',
  taskInstruction: 'Wähle das Wort, das am besten in die Lücke passt.',
  options: [
    GrammarAnswerOptionData(
      displayText: 'final',
      isCorrectAnswer: true,
      isEnglishWord: true,
    ),
    GrammarAnswerOptionData(
      displayText: 'finally',
      isCorrectAnswer: false,
      isEnglishWord: true,
    ),
    GrammarAnswerOptionData(
      displayText: 'finalize',
      isCorrectAnswer: false,
      isEnglishWord: true,
    ),
  ],
  currentCard: 7,
  totalCards: 20,
);

class GrammarExerciseNotifier extends Notifier<GrammarExerciseState> {
  @override
  GrammarExerciseState build() =>
      const GrammarExerciseState(exercise: _mockGrammarExercise);

  void selectOption(int index) {
    if (index < 0 || index >= state.exercise.options.length) {
      return;
    }

    state = state.copyWith(selectedOptionIndex: index);
  }
}

final grammarExerciseProvider =
    NotifierProvider<GrammarExerciseNotifier, GrammarExerciseState>(
      GrammarExerciseNotifier.new,
    );
