import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/grammar_exercise_data.dart';
import 'package:sprachlern/models/settings_data.dart';
import 'package:sprachlern/providers/settings_provider.dart';

const _mockGrammarCards = [
  GrammarExerciseData(
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
  ),
  GrammarExerciseData(
    sentenceWithGap: 'She ___ the report before the meeting.',
    taskInstruction: 'Wähle die richtige Vergangenheitsform.',
    options: [
      GrammarAnswerOptionData(
        displayText: 'finished',
        isCorrectAnswer: true,
        isEnglishWord: true,
      ),
      GrammarAnswerOptionData(
        displayText: 'finish',
        isCorrectAnswer: false,
        isEnglishWord: true,
      ),
      GrammarAnswerOptionData(
        displayText: 'finishing',
        isCorrectAnswer: false,
        isEnglishWord: true,
      ),
    ],
    currentCard: 8,
    totalCards: 20,
  ),
  GrammarExerciseData(
    sentenceWithGap: 'They have lived here ___ 2019.',
    taskInstruction: 'Wähle die passende Präposition.',
    options: [
      GrammarAnswerOptionData(
        displayText: 'since',
        isCorrectAnswer: true,
        isEnglishWord: true,
      ),
      GrammarAnswerOptionData(
        displayText: 'for',
        isCorrectAnswer: false,
        isEnglishWord: true,
      ),
      GrammarAnswerOptionData(
        displayText: 'from',
        isCorrectAnswer: false,
        isEnglishWord: true,
      ),
    ],
    currentCard: 9,
    totalCards: 20,
  ),
];

class GrammarExerciseNotifier extends Notifier<GrammarExerciseState> {
  /// Delay before the deck moves on by itself. Short enough that the green
  /// feedback of design.md 5.9 stays readable.
  static const Duration autoAdvanceDelay = Duration(milliseconds: 600);

  Timer? _autoAdvanceTimer;

  @override
  GrammarExerciseState build() {
    ref.onDispose(_cancelAutoAdvance);
    return const GrammarExerciseState(cards: _mockGrammarCards);
  }

  void selectOption(int index) {
    if (index < 0 || index >= state.exercise.options.length) {
      return;
    }

    _cancelAutoAdvance();
    state = state.copyWith(selectedOptionIndex: index);

    // design.md 7 ties "automatisch weiter" to the settings switch; with it off
    // the card waits for an explicit "Weiter".
    final autoAdvance = ref
        .read(settingsProvider)
        .isToggleOn(settingsAutoAdvanceKey);
    if (state.isAnsweredCorrectly && autoAdvance) {
      _autoAdvanceTimer = Timer(autoAdvanceDelay, nextCard);
    }
  }

  /// Moves to the next card, cycling back to the start of the mock deck.
  void nextCard() {
    _cancelAutoAdvance();
    state = state.copyWith(
      cardIndex: (state.cardIndex + 1) % state.cards.length,
      clearSelection: true,
    );
  }

  void _cancelAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
  }
}

final grammarExerciseProvider =
    NotifierProvider<GrammarExerciseNotifier, GrammarExerciseState>(
      GrammarExerciseNotifier.new,
    );
