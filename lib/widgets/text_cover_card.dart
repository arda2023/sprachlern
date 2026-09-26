import 'package:flutter/material.dart';
import 'package:sprachlern/models/text_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Text cover with title below, design.md 5.15. Tapping it opens the preview.
class TextCoverCard extends StatelessWidget {
  const TextCoverCard({super.key, required this.cover, this.onTap});

  final TextCoverData cover;
  final VoidCallback? onTap;

  static const int _titleLines = 2;

  /// Cover + gap + room for [_titleLines] title lines; the carousel needs a
  /// bounded height.
  static double get height =>
      TextCoverArt.height +
      AppSpacing.s8 +
      _titleLines *
          (AppTextStyles.title.fontSize! * AppTextStyles.title.height!)
              .roundToDouble();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '${cover.title}, Niveau ${cover.levelLabel}',
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: TextCoverArt.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextCoverArt(
                palette: cover.palette,
                levelLabel: cover.levelLabel,
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                cover.title,
                maxLines: _titleLines,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title.copyWith(color: AppColors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The 88 × 128 cover graphic. Without [levelLabel] the badge is left out
/// (the preview sheet puts it next to the cover instead).
class TextCoverArt extends StatelessWidget {
  const TextCoverArt({super.key, required this.palette, this.levelLabel});

  final TextCoverPalette palette;
  final String? levelLabel;

  static const double width = 88.0;
  static const double height = 128.0;

  /// design.md 5.15 only says "halbtransparente Fläche" and defines no token:
  /// the badge uses a palette colour at reduced opacity.
  static const double _badgeOpacity = 0.8;

  @override
  Widget build(BuildContext context) {
    final label = levelLabel;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _CoverPainter(palette)),
            ),
            if (label != null)
              Positioned(
                top: AppSpacing.s8,
                right: AppSpacing.s8,
                child: TextLevelBadge(
                  label: label,
                  color: _badgeColor.withValues(alpha: _badgeOpacity),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color get _badgeColor => switch (palette) {
    TextCoverPalette.dark => AppColors.surface3,
    TextCoverPalette.purple => AppColors.purple,
  };
}

/// Level badge ("A1"), 32 × 24, radius 6 (design.md 3.3 / 5.15).
class TextLevelBadge extends StatelessWidget {
  const TextLevelBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  static const double width = 32.0;
  static const double height = 24.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
      ),
      child: Text(
        label,
        style: AppTextStyles.title.copyWith(color: AppColors.white),
      ),
    );
  }
}

/// Flat stripes and triangles in the two cover palettes of design.md 5.15.
///
/// The dark palette's base should be `#252938`, which is no token; the nearest
/// one, `--surface`, stands in until design.md gets a token for it.
class _CoverPainter extends CustomPainter {
  const _CoverPainter(this.palette);

  final TextCoverPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final (base, stripe, accent) = switch (palette) {
      TextCoverPalette.dark => (
        AppColors.surface,
        AppColors.surface3,
        AppColors.cyanFillSoft,
      ),
      TextCoverPalette.purple => (
        AppColors.purpleCover,
        AppColors.lilacSoft,
        AppColors.lilacSoft,
      ),
    };

    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    // Points are fractions of the cover, so the art scales with its box.
    switch (palette) {
      case TextCoverPalette.dark:
        _fill(canvas, size, stripe, const [
          Offset(0, 0.70),
          Offset(1, 0.35),
          Offset(1, 0.62),
          Offset(0, 0.97),
        ]);
        _fill(canvas, size, accent, const [
          Offset(0, 0),
          Offset(0.6, 0),
          Offset(0, 0.32),
        ]);
      case TextCoverPalette.purple:
        _fill(canvas, size, stripe, const [
          Offset(0, 0.60),
          Offset(1, 0.32),
          Offset(1, 0.44),
          Offset(0, 0.72),
        ]);
        _fill(canvas, size, accent, const [
          Offset(1, 0.70),
          Offset(1, 1),
          Offset(0.45, 1),
        ]);
    }
  }

  void _fill(Canvas canvas, Size size, Color color, List<Offset> fractions) {
    final path = Path()
      ..addPolygon([
        for (final f in fractions)
          Offset(f.dx * size.width, f.dy * size.height),
      ], true);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CoverPainter oldDelegate) =>
      oldDelegate.palette != palette;
}
