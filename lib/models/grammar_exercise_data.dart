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

/// State of the grammar exercise: a deck of cards plus the answer selected on
/// the current one.
class GrammarExerciseState {
  const GrammarExerciseState({
    required this.cards,
    this.cardIndex = 0,
    this.selectedOptionIndex,
  });

  final List<GrammarExerciseData> cards;

  /// Position in [cards]; it cycles once the deck runs out.
  final int cardIndex;

  final int? selectedOptionIndex;

  GrammarExerciseData get exercise => cards[cardIndex];

  /// `true` once the selected option is the correct one.
  bool get isAnsweredCorrectly {
    final index = selectedOptionIndex;
    return index != null && exercise.options[index].isCorrectAnswer;
  }

  GrammarExerciseState copyWith({
    int? cardIndex,
    int? selectedOptionIndex,
    bool clearSelection = false,
  }) {
    return GrammarExerciseState(
      cards: cards,
      cardIndex: cardIndex ?? this.cardIndex,
      selectedOptionIndex: clearSelection
          ? null
          : selectedOptionIndex ?? this.selectedOptionIndex,
    );
  }
}
