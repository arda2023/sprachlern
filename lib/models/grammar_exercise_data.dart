class GrammarAnswerOptionData {
  const GrammarAnswerOptionData({
    required this.displayText,
    required this.isCorrectAnswer,
    required this.isEnglishWord,
  });

  final String displayText;
  final bool isCorrectAnswer;
  final bool isEnglishWord;
}

class GrammarExerciseData {
  const GrammarExerciseData({
    required this.sentenceWithGap,
    required this.taskInstruction,
    required this.options,
    required this.currentCard,
    required this.totalCards,
  });

  final String sentenceWithGap;
  final String taskInstruction;
  final List<GrammarAnswerOptionData> options;
  final int currentCard;
  final int totalCards;
}

class GrammarExerciseState {
  const GrammarExerciseState({
    required this.exercise,
    this.selectedOptionIndex,
  });

  final GrammarExerciseData exercise;
  final int? selectedOptionIndex;

  GrammarExerciseState copyWith({int? selectedOptionIndex}) {
    return GrammarExerciseState(
      exercise: exercise,
      selectedOptionIndex: selectedOptionIndex,
    );
  }
}
