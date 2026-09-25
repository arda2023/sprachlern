import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Startseiten-Kopf, design.md 5.2.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const double _height = 44.0;
  static const double _flagWidth = 41.0;
  static const double _flagHeight = 26.0;
  static const double _flagRadius = 2.0;
  static const double _iconSize = 32.0;
  static const double _badgeSize = 8.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Row(
        children: [
          const _FlagPlaceholder(),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              'Sprache wechseln',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.title.copyWith(color: AppColors.text),
            ),
          ),
          Semantics(
            label: 'Benachrichtigungen',
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  size: _iconSize,
                  color: AppColors.white,
                ),
                Positioned(
                  top: AppSpacing.s4,
                  right: AppSpacing.s4,
                  child: Container(
                    width: _badgeSize,
                    height: _badgeSize,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Semantics(
            label: 'Einstellungen',
            child: const Icon(
              Icons.settings_outlined,
              size: _iconSize,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlagPlaceholder extends StatelessWidget {
  const _FlagPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HomeHeader._flagWidth,
      height: HomeHeader._flagHeight,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.flagBorder),
        borderRadius: BorderRadius.circular(HomeHeader._flagRadius),
      ),
    );
  }
}
