import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Kompakte Stat-Karte, design.md 5.6.
class CompactStatCard extends StatelessWidget {
  const CompactStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  static const double _height = 112.0;
  static const double _iconSize = 22.0;
  static const double _chevronSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: _iconSize, color: iconColor),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                size: _chevronSize,
                color: AppColors.white,
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.stat.copyWith(color: AppColors.text),
          ),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
