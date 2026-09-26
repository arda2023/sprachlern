import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/theme/app_colors.dart';

/// "Runder Play" button, design.md 5.12: Ø 44, `--surface`, white play icon.
class RoundPlayButton extends StatelessWidget {
  const RoundPlayButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
  });

  final String tooltip;
  final VoidCallback? onPressed;

  static const double size = 44.0;
  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surface,
          shape: const CircleBorder(),
        ),
        icon: const Icon(
          FLucideIcons.play,
          size: _iconSize,
          color: AppColors.white,
        ),
      ),
    );
  }
}
