import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/exercise_data.dart';
import 'package:sprachlern/providers/exercise_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/exercise_input_bar.dart';
import 'package:sprachlern/widgets/exercise_top_bar.dart';
import 'package:sprachlern/widgets/fill_in_card.dart';
import 'package:sprachlern/widgets/grammar_hint_sheet.dart';
import 'package:sprachlern/widgets/translation_card.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({super.key, required this.stackId});

  final String stackId;

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  // Per-card state; [_syncCard] resets it whenever the current card changes.
  ExerciseData? _card;
  String _answer = '';

  /// Wrong confirmations on this card.
  int _attemptCount = 0;

  /// submitAnswer(false) was sent for this card, by the first miss or by
  /// "Wort erfahren": the card is decided as not known.
  bool _firstAttemptWasWrong = false;

  /// "Wort erfahren" was tapped. Scored as not known, but not an attempt for
  /// the hint stages.
  bool _solutionRevealed = false;

  /// The last confirmation was wrong and the input is unchanged since.
  bool _isWrong = false;

  /// The answer was confirmed correct; the button now says "Weiter".
  bool _isCorrect = false;

  /// "Weiter" is saving the result.
  bool _advancing = false;

  void _syncCard(ExerciseData? card) {
    if (identical(card, _card)) return;
    _card = card;
    _answer = '';
    _attemptCount = 0;
    _firstAttemptWasWrong = false;
    _solutionRevealed = false;
    _isWrong = false;
    _isCorrect = false;
    _advancing = false;
  }

  ExerciseAction get _action => _isCorrect
      ? ExerciseAction.next
      : _answer.isEmpty
      ? ExerciseAction.revealWord
      : ExerciseAction.submit;

  ExerciseNotifier get _notifier =>
      ref.read(exerciseProvider(widget.stackId).notifier);

  /// Runs what the button currently shows; the keyboard's done key does the
  /// same.
  void _runAction(ExerciseData exercise) {
    switch (_action) {
      case ExerciseAction.revealWord:
        _reveal();
      case ExerciseAction.submit:
        _confirm(exercise);
      case ExerciseAction.next:
        _next();
    }
  }

  /// Shows the answer. It was not recalled from memory, so SM-2 gets false —
  /// once per card, like a first miss. No red, no card change.
  void _reveal() {
    final isFirstMiss = !_firstAttemptWasWrong;
    setState(() {
      _solutionRevealed = true;
      _firstAttemptWasWrong = true;
    });
    if (isFirstMiss) _submit(false);
  }

  void _confirm(ExerciseData exercise) {
    final correct =
        _answer.trim().toLowerCase() ==
        exercise.targetAnswer.trim().toLowerCase();
    if (correct) {
      // Scored on "Weiter", unless a miss already scored this card.
      setState(() {
        _isCorrect = true;
        _isWrong = false;
      });
      return;
    }

    final isFirstMiss = !_firstAttemptWasWrong;
    setState(() {
      _attemptCount++;
      _isWrong = true;
      _firstAttemptWasWrong = true;
    });
    // SM-2 gets the first attempt's result, once per card.
    if (isFirstMiss) _submit(false);
  }

  Future<void> _next() async {
    if (_advancing) return;
    setState(() => _advancing = true);
    if (!_firstAttemptWasWrong) await _submit(true);
    if (!mounted) return;
    _notifier.nextCard();
  }

  /// Sends the card's single result. A failure is reported, not retried, so
  /// the card is never scored twice; unscored, it comes up again later.
  Future<void> _submit(bool correct) async {
    try {
      await _notifier.submitAnswer(correct);
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deine Antwort konnte nicht gespeichert werden.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(exerciseProvider(widget.stackId));

    return session.when(
      loading: () =>
          _status(const CircularProgressIndicator(color: AppColors.lilac)),
      error: (_, _) => _status(
        Text(
          'Die Karten konnten nicht geladen werden.',
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      ),
      data: (session) {
        final exercise = session.currentExercise;
        _syncCard(exercise);
        if (exercise == null) {
          return _status(
            Text(
              session.cards.isEmpty
                  ? 'Keine Karten fällig.'
                  : 'Alle Karten erledigt.',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            currentCard: session.currentIndex,
            totalCards: session.cards.length,
          );
        }
        return _buildExercise(exercise);
      },
    );
  }

  Widget _status(Widget child, {int currentCard = 0, int totalCards = 0}) =>
      Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              ExerciseTopBar(
                currentCard: currentCard,
                totalCards: totalCards,
                onHome: () =>
                    context.canPop() ? context.pop() : context.go('/home'),
              ),
              Expanded(child: Center(child: child)),
            ],
          ),
        ),
      );

  Widget _buildExercise(ExerciseData exercise) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      // Lifted by the keyboard height, the bar sits directly above the
      // keyboard (5.7). As the bottom widget it also keeps snack bars above
      // itself; inside the body a snack bar would cover the button.
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ExerciseInputBar(
          action: _action,
          onAction: _advancing ? null : () => _runAction(exercise),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ExerciseTopBar(
              currentCard: exercise.currentCard,
              totalCards: exercise.totalCards,
              onHome: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
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
                          key: ValueKey(
                            'exercise_card_${exercise.stackWordId}',
                          ),
                          exercise: exercise,
                          isWrong: _isWrong,
                          attemptCount: _attemptCount,
                          solutionRevealed: _solutionRevealed,
                          isCorrect: _isCorrect,
                          onAnswerChanged: (value) {
                            if (_answer == value) return;
                            setState(() {
                              _answer = value;
                              // Feedback belongs to the confirmed input.
                              _isWrong = false;
                            });
                          },
                          onAnswerSubmitted: (_) => _runAction(exercise),
                          onGrammarHintTap: () =>
                              showGrammarHintSheet(context, exercise),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        TranslationCard(
                          headword: exercise.germanHeadword,
                          exampleSentence: exercise.germanExampleSentence,
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
}
