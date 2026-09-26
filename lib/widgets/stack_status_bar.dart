import 'package:flutter/material.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/utils/german_number.dart';
import 'package:sprachlern/widgets/difficulty_indicator.dart';

/// Statusbereich of the stack detail screen (design.md 5.17).
class StackStatusBar extends StatelessWidget {
  const StackStatusBar({super.key, required this.detail});

  final StackDetailData detail;

  static const double _dotSize = 8.0;
  static const double _barHeight = 8.0;

  @override
  Widget build(BuildContext context) {
    final total = detail.totalWords;
    final learnedFraction = total == 0
        ? 0.0
        : (detail.learnedWords / total).clamp(0.0, 1.0).toDouble();
    final seenFraction = total == 0
        ? 0.0
        : (detail.newWordsSeen / total).clamp(0.0, 1.0).toDouble();
    final seenOnlyFraction = (seenFraction - learnedFraction)
        .clamp(0.0, 1.0)
        .toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatusLine(
                    color: AppColors.successDark,
                    text:
                        '${formatGermanInt(detail.newWordsSeen)} von '
                        '${formatGermanInt(detail.newWordsTotal)} neuen Wörtern',
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _StatusLine(
                    color: AppColors.success,
                    text:
                        '${formatGermanInt(detail.learnedWords)} Wörter gelernt',
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  detail.difficultyLabel,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                DifficultyIndicator(level: detail.stack.difficultyLevel),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: SizedBox(
            key: const ValueKey('stack_detail_progress'),
            height: _barHeight,
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: AppColors.surface),
                  ),
                  FractionallySizedBox(
                    widthFactor: learnedFraction,
                    child: const ColoredBox(color: AppColors.success),
                  ),
                  Positioned(
                    left: constraints.maxWidth * learnedFraction,
                    width: constraints.maxWidth * seenOnlyFraction,
                    top: 0,
                    bottom: 0,
                    child: const ColoredBox(color: AppColors.successDark),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s4),
          child: Container(
            width: StackStatusBar._dotSize,
            height: StackStatusBar._dotSize,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(color: AppColors.text),
          ),
        ),
      ],
    );
  }
}
