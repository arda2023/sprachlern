import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/grammar_exercise_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/grammar_answer_option.dart';

class GrammarExerciseScreen extends ConsumerWidget {
  const GrammarExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(grammarExerciseProvider);
    final exercise = state.exercise;
    final selectedOptionIndex = state.selectedOptionIndex;
    final correctAnswer = exercise.options.firstWhere(
      (option) => option.isCorrectAnswer,
    );
    final displayedSentence = selectedOptionIndex == null
        ? exercise.sentenceWithGap
        : exercise.sentenceWithGap.replaceFirst(
            '___',
            correctAnswer.displayText,
          );

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _GrammarExerciseTopBar(
              currentCard: exercise.currentCard,
              totalCards: exercise.totalCards,
              onClose: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.s32,
                  AppSpacing.pageMargin,
                  AppSpacing.s16,
                ),
                child: Column(
                  children: [
                    Text(
                      displayedSentence,
                      key: const ValueKey('grammar_sentence'),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sentence,
                    ),
                    const Spacer(),
                    Text(
                      exercise.taskInstruction,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    ...List.generate(exercise.options.length, (index) {
                      final option = exercise.options[index];
                      final feedback = state.selectedOptionIndex == index
                          ? option.isCorrectAnswer
                                ? GrammarAnswerFeedback.correct
                                : GrammarAnswerFeedback.incorrect
                          : null;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == exercise.options.length - 1
                              ? 0
                              : AppSpacing.s8,
                        ),
                        child: GrammarAnswerOption(
                          option: option,
                          index: index,
                          feedback: feedback,
                          onTap: () => ref
                              .read(grammarExerciseProvider.notifier)
                              .selectOption(index),
                        ),
                      );
                    }),
                    if (selectedOptionIndex != null) ...[
                      const SizedBox(height: AppSpacing.s16),
                      _NextCardLink(
                        onTap: () => ref
                            .read(grammarExerciseProvider.notifier)
                            .nextCard(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrammarExerciseTopBar extends StatelessWidget {
  const _GrammarExerciseTopBar({
    required this.currentCard,
    required this.totalCards,
    required this.onClose,
  });

  final int currentCard;
  final int totalCards;
  final VoidCallback onClose;

  static const _topBarHeight = 44.0;
  static const _progressHeight = 2.0;
  static const _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final progress = totalCards == 0
        ? 0.0
        : (currentCard / totalCards).clamp(0.0, 1.0).toDouble();

    return SizedBox(
      height: _topBarHeight + _progressHeight,
      child: Column(
        children: [
          SizedBox(
            height: _topBarHeight,
            child: Row(
              children: [
                _TopBarButton(
                  icon: FLucideIcons.x,
                  tooltip: 'Übung schließen',
                  onPressed: onClose,
                ),
                const Spacer(),
                _TopBarButton(
                  icon: FLucideIcons.lightbulb,
                  tooltip: 'Grammatikhinweis',
                  onPressed: _doNothing,
                ),
              ],
            ),
          ),
          // Full width: without it the bar shrinks to the width of its fill,
          // and without heightFactor the fill has no height at all.
          SizedBox(
            width: double.infinity,
            height: _progressHeight,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: AppColors.surface),
                ),
                FractionallySizedBox(
                  key: const ValueKey('grammar_progress_fill'),
                  widthFactor: progress,
                  heightFactor: 1,
                  child: const ColoredBox(color: AppColors.lilac),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        icon: Icon(
          icon,
          size: _GrammarExerciseTopBar._iconSize,
          color: AppColors.white,
        ),
      ),
    );
  }
}

/// Text link per design.md 5.12: `--lilac`, `title`, no surface of its own.
class _NextCardLink extends StatelessWidget {
  const _NextCardLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        key: const ValueKey('grammar_next_card'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 44,
          child: Center(
            child: Text(
              'Weiter',
              style: AppTextStyles.title.copyWith(color: AppColors.lilac),
            ),
          ),
        ),
      ),
    );
  }
}

void _doNothing() {}
