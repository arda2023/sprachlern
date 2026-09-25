import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class ExerciseTopBar extends StatelessWidget {
  const ExerciseTopBar({
    super.key,
    required this.currentCard,
    required this.totalCards,
    required this.onHome,
  });

  final int currentCard;
  final int totalCards;
  final VoidCallback onHome;

  static const _barHeight = 44.0;
  static const _progressWidth = 243.0;
  static const _progressHeight = 8.0;
  static const _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final progress = totalCards == 0 ? 0.0 : currentCard / totalCards;

    return SizedBox(
      height: _barHeight,
      child: Row(
        children: [
          _TopBarIconButton(
            key: const ValueKey('exercise_home'),
            icon: FLucideIcons.house,
            tooltip: 'Zur Hauptseite',
            onPressed: onHome,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$currentCard/$totalCards',
                    style: AppTextStyles.meta.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  SizedBox(
                    width: _progressWidth,
                    height: _progressHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: ColoredBox(color: AppColors.surface),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress.clamp(0.0, 1.0),
                            child: const ColoredBox(color: AppColors.lilac),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _TopBarIconButton(
            icon: FLucideIcons.ellipsisVertical,
            tooltip: 'Weitere Optionen',
            onPressed: _doNothing,
          ),
        ],
      ),
    );
  }
}

void _doNothing() {}

class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({
    super.key,
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
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        icon: Icon(
          icon,
          size: ExerciseTopBar._iconSize,
          color: AppColors.white,
        ),
      ),
    );
  }
}
