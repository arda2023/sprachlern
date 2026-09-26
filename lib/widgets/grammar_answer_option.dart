import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/grammar_exercise_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

enum GrammarAnswerFeedback { correct, incorrect }

class GrammarAnswerOption extends StatelessWidget {
  const GrammarAnswerOption({
    super.key,
    required this.option,
    required this.index,
    required this.feedback,
    required this.onTap,
  });

  final GrammarAnswerOptionData option;
  final int index;
  final GrammarAnswerFeedback? feedback;
  final VoidCallback onTap;

  static const _height = 56.0;
  static const _feedbackSize = 22.0;

  @override
  Widget build(BuildContext context) {
    final feedbackColor = switch (feedback) {
      GrammarAnswerFeedback.correct => AppColors.success,
      GrammarAnswerFeedback.incorrect => AppColors.error,
      null => null,
    };
    final isCorrect = feedback == GrammarAnswerFeedback.correct;

    return Semantics(
      button: true,
      selected: feedback != null,
      label: _semanticLabel(isCorrect),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          key: ValueKey('grammar_option_$index'),
          height: _height,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          alignment: Alignment.centerLeft,
          decoration: feedbackColor == null
              ? null
              : BoxDecoration(
                  border: Border.all(color: feedbackColor, width: 2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.displayText,
                  style: option.isEnglishWord
                      ? AppTextStyles.enLine
                      : AppTextStyles.title.copyWith(color: AppColors.white),
                ),
              ),
              if (feedbackColor != null)
                Container(
                  key: ValueKey(
                    isCorrect
                        ? 'grammar_feedback_correct'
                        : 'grammar_feedback_incorrect',
                  ),
                  width: _feedbackSize,
                  height: _feedbackSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: feedbackColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCorrect ? FLucideIcons.check : FLucideIcons.x,
                    size: 14,
                    color: AppColors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _semanticLabel(bool isCorrect) {
    if (feedback == null) {
      return 'Antwort: ${option.displayText}';
    }
    return isCorrect
        ? 'Richtige Antwort: ${option.displayText}'
        : 'Falsche Antwort: ${option.displayText}';
  }
}
