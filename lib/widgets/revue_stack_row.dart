import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Stapel-Revue-Zeile (design.md 5.10). The bar shows the empty track only:
/// a revue is pure repetition and never changes learning progress.
class RevueStackRow extends StatelessWidget {
  const RevueStackRow({super.key, required this.stack, this.onPlay});

  final VocabularyStackData stack;
  final VoidCallback? onPlay;

  static const double _iconTileSize = 33.0;
  static const double _iconSize = 24.0;
  static const double _trackHeight = 8.0;
  static const double _playSize = 44.0;
  static const double _playIconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stack.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.s8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  child: SizedBox(
                    key: ValueKey('revue_track_${stack.id}'),
                    height: _trackHeight,
                    child: const ColoredBox(color: AppColors.surface2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          SizedBox(
            width: _playSize,
            height: _playSize,
            child: IconButton(
              key: ValueKey('revue_play_${stack.id}'),
              tooltip: '${stack.title} durchsehen',
              onPressed: onPlay,
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                shape: const CircleBorder(),
              ),
              icon: const Icon(
                FLucideIcons.play,
                size: _playIconSize,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
