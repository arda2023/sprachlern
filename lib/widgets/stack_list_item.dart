import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class StackListItem extends StatelessWidget {
  const StackListItem({super.key, required this.stack});

  final VocabularyStackData stack;

  static const _height = 72.0;
  static const _iconTileSize = 40.0;
  static const _iconSize = 24.0;
  static const _boltSize = 14.0;
  static const _progressWidth = 100.0;
  static const _progressHeight = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                _DifficultyIndicator(level: stack.difficultyLevel),
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
  }
}

class _DifficultyIndicator extends StatelessWidget {
  const _DifficultyIndicator({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final filledBolts = level.clamp(0, 3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.only(right: index == 2 ? 0 : AppSpacing.s16),
          child: Icon(
            FLucideIcons.bolt,
            size: StackListItem._boltSize,
            color: index < filledBolts
                ? AppColors.iconBolt
                : AppColors.iconBoltOff,
          ),
        ),
      ),
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
