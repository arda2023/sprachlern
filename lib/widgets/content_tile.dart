import 'package:flutter/material.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class ContentTile extends StatelessWidget {
  const ContentTile({super.key, required this.tile, this.onTap});

  final ContentTileData tile;
  final VoidCallback? onTap;

  static const _height = 100.0;
  static const _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: tile.label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          key: ValueKey('content_tile_${tile.label}'),
          width: double.infinity,
          height: _height,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tile.icon, size: _iconSize, color: AppColors.periwinkle),
              const SizedBox(height: AppSpacing.s8),
              Text(
                tile.label,
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
