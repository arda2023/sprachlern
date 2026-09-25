import 'package:flutter/material.dart';
import 'package:sprachlern/models/home_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/utils/german_number.dart';

/// Breite Fortschrittskarte, design.md 5.6.
class ProgressStatCard extends StatelessWidget {
  const ProgressStatCard({super.key, required this.stats});

  final ProgressStats stats;

  static const double _barHeight = 8.0;
  static const double _purpleSegmentWidth = 8.0;
  static const double _chevronSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Stand aktivierter Wörter',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: AppColors.text),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: _chevronSize,
                color: AppColors.white,
              ),
            ],
          ),
          Text(
            '${stats.knownPercent} % von ${formatGermanInt(stats.wordsBase)}',
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.s8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            child: SizedBox(
              height: _barHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: AppColors.surface2),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: stats.knownPercent / 100,
                    child: const ColoredBox(color: AppColors.cyan),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: _purpleSegmentWidth,
                      child: ColoredBox(color: AppColors.purple),
                    ),
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
