import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/exercise_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/diff_input_field.dart';

class FillInCard extends StatelessWidget {
  const FillInCard({
    super.key,
    required this.exercise,
    required this.isWrong,
    required this.attemptCount,
    required this.solutionRevealed,
    required this.isCorrect,
    required this.onAnswerChanged,
    required this.onAnswerSubmitted,
    required this.onGrammarHintTap,
  });

  final ExerciseData exercise;

  // Feedback state of the gap, see [DiffInputField].
  final bool isWrong;
  final int attemptCount;
  final bool solutionRevealed;
  final bool isCorrect;
  final ValueChanged<String> onAnswerChanged;
  final ValueChanged<String> onAnswerSubmitted;
  final VoidCallback onGrammarHintTap;

  static const _statusWidth = 16.0;
  static const _statusHeight = 4.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusIndicator(status: exercise.wordStatus),
          const SizedBox(height: AppSpacing.s16),
          Wrap(
            spacing: AppSpacing.s4,
            runSpacing: AppSpacing.s8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: exercise.tokens
                .map(
                  (token) => token.isBlank
                      ? DiffInputField(
                          key: ValueKey('diff_input_${exercise.stackWordId}'),
                          targetAnswer: exercise.targetAnswer,
                          isWrong: isWrong,
                          attemptCount: attemptCount,
                          solutionRevealed: solutionRevealed,
                          isCorrect: isCorrect,
                          onChanged: onAnswerChanged,
                          onSubmitted: onAnswerSubmitted,
                        )
                      : _TranslatableToken(token: token),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.s24),
          InkWell(
            key: const ValueKey('grammar_hint_row'),
            onTap: onGrammarHintTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Grammatikhinweis anzeigen',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    FLucideIcons.chevronRight,
                    size: 16,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    final filledStrokes = status.clamp(0, 5);
    final isNewWord = status <= 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(right: index == 4 ? 0 : AppSpacing.s4),
            child: Container(
              width: FillInCard._statusWidth,
              height: FillInCard._statusHeight,
              decoration: BoxDecoration(
                color: index < filledStrokes
                    ? AppColors.orange
                    : AppColors.surface2,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
            ),
          ),
        ),
        if (isNewWord) ...[
          const SizedBox(width: AppSpacing.s8),
          Text(
            'Neues Wort',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.orange),
          ),
        ],
      ],
    );
  }
}

class _TranslatableToken extends StatelessWidget {
  const _TranslatableToken({required this.token});

  final ExerciseToken token;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.sentence.copyWith(
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dotted,
      decorationColor: AppColors.surface2,
      decorationThickness: 2,
    );

    return Tooltip(
      message: token.germanTranslation ?? '',
      triggerMode: TooltipTriggerMode.tap,
      child: Semantics(
        button: true,
        label: '${token.text}: Übersetzung anzeigen',
        child: Text(token.text, style: textStyle),
      ),
    );
  }
}
