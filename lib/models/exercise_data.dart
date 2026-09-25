/// Immutable mock data for one vocabulary fill-in-the-blank exercise.
class ExerciseToken {
  const ExerciseToken({
    required this.text,
    this.germanTranslation,
    this.isBlank = false,
  });

  final String text;
  final String? germanTranslation;
  final bool isBlank;
}

class ExerciseData {
  const ExerciseData({
    required this.tokens,
    required this.wordStatus,
    required this.targetAnswer,
    required this.germanHeadword,
    required this.germanExampleSentence,
    required this.currentCard,
    required this.totalCards,
    required this.grammarHintTitle,
    required this.grammarHintDescription,
  });

  final List<ExerciseToken> tokens;
  final int wordStatus;
  final String targetAnswer;
  final String germanHeadword;
  final String germanExampleSentence;
  final int currentCard;
  final int totalCards;
  final String grammarHintTitle;
  final String grammarHintDescription;
}
