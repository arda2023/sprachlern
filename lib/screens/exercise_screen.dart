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
  String _answer = '';
  bool _isSubmitting = false;
  bool _attemptFailed = false;
  ExerciseData? _attemptExercise;

  Future<void> _confirmAnswer(ExerciseData exercise, String input) async {
    if (_isSubmitting) return;
    final correct =
        input.trim().toLowerCase() ==
        exercise.targetAnswer.trim().toLowerCase();
    setState(() {
      _answer = input;
      _isSubmitting = true;
      if (!correct) _attemptFailed = true;
    });

    // Keep the per-character result visible before replacing the card.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    try {
      await ref
          .read(exerciseProvider(widget.stackId).notifier)
          .submitAnswer(correct);
      if (!mounted) return;
      setState(() {
        _answer = '';
        _isSubmitting = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
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
        if (!identical(exercise, _attemptExercise)) {
          _attemptExercise = exercise;
          _attemptFailed = false;
        }
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
      bottomNavigationBar: const ExerciseInputBar(),
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
                          attemptFailed: _attemptFailed,
                          onAnswerChanged: (value) {
                            if (_answer == value) {
                              return;
                            }
                            setState(() => _answer = value);
                          },
                          onAnswerSubmitted: (value) =>
                              _confirmAnswer(exercise, value),
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
