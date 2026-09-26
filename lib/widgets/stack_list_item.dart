import 'package:flutter/material.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/difficulty_indicator.dart';

class StackListItem extends StatelessWidget {
  const StackListItem({super.key, required this.stack, this.onTap});

  final VocabularyStackData stack;
  final VoidCallback? onTap;

  static const _height = 72.0;
  static const _iconTileSize = 40.0;
  static const _iconSize = 24.0;
  static const _progressWidth = 100.0;
  static const _progressHeight = 8.0;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: _height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Row(
        children: [
          Container(
            width: _iconTileSize,
            height: _iconTileSize,
            decoration: BoxDecoration(
              color: AppColors.periwinkle,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(stack.icon, size: _iconSize, color: AppColors.white),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stack.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.s4),
                DifficultyIndicator(level: stack.difficultyLevel),
                if (stack.progress case final progress?) ...[
                  const SizedBox(height: AppSpacing.s4),
                  _StackProgressBar(progress: progress, title: stack.title),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(
      key: ValueKey('stack_item_${stack.id}'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: card,
    );
  }
}

class _StackProgressBar extends StatelessWidget {
  const _StackProgressBar({required this.progress, required this.title});

  final StackProgressData progress;
  final String title;

  @override
  Widget build(BuildContext context) {
    final learnedFraction = progress.totalWords == 0
        ? 0.0
        : (progress.learnedWords / progress.totalWords)
              .clamp(0.0, 1.0)
              .toDouble();
    final seenFraction = progress.totalWords == 0
        ? 0.0
        : (progress.seenWords / progress.totalWords).clamp(0.0, 1.0).toDouble();
    final seenOnlyFraction = (seenFraction - learnedFraction)
        .clamp(0.0, 1.0)
        .toDouble();

    return SizedBox(
      key: ValueKey('stack_progress_$title'),
      width: StackListItem._progressWidth,
      height: StackListItem._progressHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              const Positioned.fill(
                child: ColoredBox(color: AppColors.surface2),
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
    );
  }
}
