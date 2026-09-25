import 'package:flutter/material.dart';
import 'package:sprachlern/models/home_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Stapel-Listenkarte, design.md 5.10 (ohne Level-Blitze und Fortschrittsbalken).
class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.entry});

  final ActivityEntry entry;

  static const double _tileSize = 40.0;
  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Row(
        children: [
          Container(
            width: _tileSize,
            height: _tileSize,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(entry.icon, size: _iconSize, color: AppColors.white),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              entry.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.title.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
