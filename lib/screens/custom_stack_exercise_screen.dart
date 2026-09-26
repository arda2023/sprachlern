import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:sprachlern/models/exercise_data.dart';
import 'package:sprachlern/providers/custom_stack_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/exercise_input_bar.dart';
import 'package:sprachlern/widgets/exercise_top_bar.dart';
import 'package:sprachlern/widgets/fill_in_card.dart';
import 'package:sprachlern/widgets/grammar_hint_sheet.dart';
import 'package:sprachlern/widgets/translation_card.dart';

/// Linear practice of the loaded custom cards; feedback stays local.
class CustomStackExerciseScreen extends ConsumerStatefulWidget {
  const CustomStackExerciseScreen({super.key});

  @override
  ConsumerState<CustomStackExerciseScreen> createState() =>
      _CustomStackExerciseScreenState();
}

class _CustomStackExerciseScreenState
    extends ConsumerState<CustomStackExerciseScreen> {
  int _index = 0;
  CustomStackCard? _card;
  String _answer = '';
  int _attemptCount = 0;
  bool _solutionRevealed = false;
  bool _isWrong = false;
  bool _isCorrect = false;

  void _syncCard(CustomStackCard card) {
    if (identical(card, _card)) return;
    _card = card;
    _answer = '';
    _attemptCount = 0;
    _solutionRevealed = false;
    _isWrong = false;
    _isCorrect = false;
  }

  ExerciseAction get _action => _isCorrect
      ? ExerciseAction.next
      : _answer.isEmpty
      ? ExerciseAction.revealWord
      : ExerciseAction.submit;

  void _runAction(ExerciseData exercise) {
    switch (_action) {
      case ExerciseAction.revealWord:
        setState(() => _solutionRevealed = true);
      case ExerciseAction.submit:
        final correct =
            _answer.trim().toLowerCase() ==
            exercise.targetAnswer.trim().toLowerCase();
        setState(() {
          _isCorrect = correct;
          _isWrong = !correct;
          if (!correct) _attemptCount++;
        });
      case ExerciseAction.next:
        final cards = ref.read(customStackProvider).cards;
        if (_index + 1 >= cards.length) {
          context.go('/custom-stack');
        } else {
          setState(() => _index++);
        }
    }
  }

  void _back() => context.canPop() ? context.pop() : context.go('/home');

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(customStackProvider).cards;
    if (_index >= cards.length) {
      return _status('Noch keine Karten vorhanden.', totalCards: cards.length);
    }

    final card = cards[_index];
    _syncCard(card);
    final ExerciseData exercise;
    try {
      exercise = _exerciseFor(card, cards.length);
    } on FormatException {
      return _status(
        'Diese Karte hat keinen passenden englischen Lückensatz.',
        currentCard: _index + 1,
        totalCards: cards.length,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ExerciseInputBar(
          action: _action,
          onAction: () => _runAction(exercise),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ExerciseTopBar(
              currentCard: _index + 1,
              totalCards: cards.length,
              onHome: _back,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.s16,
                  AppSpacing.pageMargin,
                  AppSpacing.s24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSpacing.contentWidth,
                    ),
                    child: Column(
                      children: [
                        FillInCard(
                          key: ValueKey('custom_exercise_card_$_index'),
                          exercise: exercise,
                          showStatusIndicator: false,
                          isWrong: _isWrong,
                          attemptCount: _attemptCount,
                          solutionRevealed: _solutionRevealed,
                          isCorrect: _isCorrect,
                          onAnswerChanged: (value) {
                            if (_answer == value && !_isWrong) return;
                            setState(() {
                              _answer = value;
                              _isWrong = false;
                            });
                          },
                          onAnswerSubmitted: (_) => _runAction(exercise),
                          onGrammarHintTap: () =>
                              showGrammarHintSheet(context, exercise),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        TranslationCard(
                          key: ValueKey('custom_translation_$_index'),
                          headword: 'Übersetzung',
                          exampleSentence: card.germanSentence,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _status(String message, {int currentCard = 0, int totalCards = 0}) =>
      Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              ExerciseTopBar(
                currentCard: currentCard,
                totalCards: totalCards,
                onHome: _back,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    message,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  ExerciseData _exerciseFor(CustomStackCard card, int totalCards) {
    final sentence = card.englishSentence.trim();
    final target = card.targetWord.trim();
    if (target.isEmpty) throw const FormatException('Empty target word');
    // Keep whole-word/phrase boundaries and punctuation as in the vocabulary
    // exercise. Custom cards carry their solution directly.
    final match = RegExp(
      r'(^|[^\p{L}\p{N}])' + RegExp.escape(target) + r'(?=$|[^\p{L}\p{N}])',
      caseSensitive: false,
      unicode: true,
    ).firstMatch(sentence);
    if (match == null) {
      throw const FormatException('Target absent from sentence');
    }
    final start = match.start + match.group(1)!.length;
    List<ExerciseToken> tokensFor(String text) => [
      for (final word in text.trim().split(RegExp(r'\s+')))
        if (word.isNotEmpty) ExerciseToken(text: word),
    ];
    return ExerciseData(
      tokens: [
        ...tokensFor(sentence.substring(0, start)),
        const ExerciseToken(text: '', isBlank: true),
        ...tokensFor(sentence.substring(start + target.length)),
      ],
      // Required by the shared data shape, but never rendered for custom cards.
      wordStatus: 0,
      targetAnswer: sentence.substring(start, start + target.length),
      germanHeadword: '',
      germanExampleSentence: card.germanSentence,
      currentCard: _index + 1,
      totalCards: totalCards,
      grammarHintTitle: 'Grammatikhinweis',
      grammarHintDescription:
          'Für diese Karte ist kein Grammatikhinweis verfügbar.',
    );
  }
}
