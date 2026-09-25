import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/exercise_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class FillInCard extends StatelessWidget {
  const FillInCard({
    super.key,
    required this.exercise,
    required this.answer,
    required this.onBlankTap,
    required this.onGrammarHintTap,
  });

  final ExerciseData exercise;
  final String? answer;
  final VoidCallback onBlankTap;
  final VoidCallback onGrammarHintTap;

  static const _blankMinWidth = 100.0;
  static const _blankHeight = 32.0;
  static const _cursorWidth = 2.0;
  static const _cursorHeight = 24.0;
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
                      ? _Blank(answer: answer, onTap: onBlankTap)
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

class _Blank extends StatelessWidget {
  const _Blank({required this.answer, required this.onTap});

  final String? answer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFilled = answer != null && answer!.isNotEmpty;

    return Semantics(
      button: true,
      label: isFilled ? 'Ausgefüllte Lücke: $answer' : 'Lücke ausfüllen',
      child: GestureDetector(
        key: const ValueKey('exercise_blank'),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: FillInCard._blankMinWidth,
          ),
          height: FillInCard._blankHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
          ),
          child: isFilled
              ? Text(answer!, style: AppTextStyles.sentence)
              : Container(
                  key: const ValueKey('exercise_blank_cursor'),
                  width: FillInCard._cursorWidth,
                  height: FillInCard._cursorHeight,
                  color: AppColors.cyan,
                ),
        ),
      ),
    );
  }
}
