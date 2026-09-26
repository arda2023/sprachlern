import 'package:flutter/material.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/round_play_button.dart';

/// Stapel-Revue-Zeile (design.md 5.10). The bar shows the empty track only:
/// a revue is pure repetition and never changes learning progress.
class RevueStackRow extends StatelessWidget {
  const RevueStackRow({super.key, required this.stack, this.onPlay});

  final VocabularyStackData stack;
  final VoidCallback? onPlay;

  static const double _iconTileSize = 33.0;
  static const double _iconSize = 24.0;
  static const double _trackHeight = 8.0;

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
          RoundPlayButton(
            key: ValueKey('revue_play_${stack.id}'),
            tooltip: '${stack.title} durchsehen',
            onPressed: onPlay,
          ),
        ],
      ),
    );
  }
}
