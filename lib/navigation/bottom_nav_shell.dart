import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: _BottomNavBar.barHeight + safePadding,
            child: navigationShell,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (i) => navigationShell.goBranch(
                i,
                initialLocation: i == navigationShell.currentIndex,
              ),
              safePadding: safePadding,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.safePadding,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final double safePadding;

  static const double _dividerHeight = 1.0;

  /// Breathing room between the divider and the icon row.
  static const double _topGap = AppSpacing.s8;

  /// design.md 5.1. 57 px = 1 divider + 8 gap + 48 content, corrected up from
  /// the 49 px originally specified: 49 px fits divider + 28 icon + 4 gap +
  /// 14 label exactly, leaving no room below the divider. Those 8 px are what
  /// let the ring's centre sit on the bar's top edge (as 5.1 requires) while
  /// its lower arc — 36.5 px down — still clears the "Lernen" label at 42 px.
  static const double barHeight = 57.0;

  static const double _ringDiameter = 73.0;
  static const double _ringRadius = _ringDiameter / 2;
  static const double _circleDiameter = 48.0;
  static const double _ringStroke = 4.0;
  static const double _iconSize = 28.0;
  static const double _centerIconSize = 28.0;
  static const double _iconLabelGap = AppSpacing.s4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // The ring is centred on the bar's top edge, so half of it overhangs.
      height: _ringRadius + barHeight + safePadding,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: barHeight + safePadding,
            child: ColoredBox(
              color: AppColors.bg,
              child: Column(
                children: [
                  Container(height: _dividerHeight, color: AppColors.surface),
                  const SizedBox(height: _topGap),
                  Expanded(
                    child: Row(
                      children: [
                        _buildSlot(FLucideIcons.house, 'Hauptseite', 0),
                        _buildSlot(FLucideIcons.layoutGrid, 'Inhalte', 1),
                        _buildLernenSlot(),
                        _buildSlot(FLucideIcons.chartNoAxesColumn, 'Fortschritte', 3),
                        _buildSlot(FLucideIcons.user, 'Konto', 4, badge: true),
                      ],
                    ),
                  ),
                  SizedBox(height: safePadding),
                ],
              ),
            ),
          ),
          // Ring + circle: centred on the bar's top edge, clearing the label row.
          // IgnorePointer so taps fall through to the "Lernen" slot below.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _ringDiameter,
            child: Center(
              child: IgnorePointer(
                child: SizedBox(
                  key: const ValueKey('nav_ring'),
                  width: _ringDiameter,
                  height: _ringDiameter,
                  child: CustomPaint(
                    painter: const _RingPainter(),
                    child: Center(
                      child: Container(
                        width: _circleDiameter,
                        height: _circleDiameter,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          FLucideIcons.arrowRight,
                          size: _centerIconSize,
                          color: AppColors.surface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlot(IconData icon, String label, int index, {bool badge = false}) {
    final color = currentIndex == index ? AppColors.lilac : AppColors.white;

    Widget iconWidget = Icon(icon, size: _iconSize, color: color);
    if (badge) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -2,
            right: -4,
            child: Container(
              width: AppSpacing.s8,
              height: AppSpacing.s8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }

    return _slot(
      index: index,
      children: [
        iconWidget,
        const SizedBox(height: _iconLabelGap),
        _label(label, color),
      ],
    );
  }

  /// Nav labels are always a single line; the 75 px slot is narrower than some
  /// labels render at 12 px, which would otherwise wrap and overflow the bar.
  Widget _label(String text, Color color) => Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(color: color),
      );

  /// The centre slot reserves the icon's space so its label shares the exact
  /// baseline of the other four; the ring + circle are painted above it.
  Widget _buildLernenSlot() {
    final color = currentIndex == 2 ? AppColors.lilac : AppColors.white;

    return _slot(
      index: 2,
      children: [
        const SizedBox(height: _iconSize),
        const SizedBox(height: _iconLabelGap),
        _label('Lernen', color),
      ],
    );
  }

  Widget _slot({required int index, required List<Widget> children}) => Expanded(
        child: GestureDetector(
          key: ValueKey('nav_$index'),
          onTap: () => onTap(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      );
}

class _RingPainter extends CustomPainter {
  const _RingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - _BottomNavBar._ringStroke / 2;

    final paint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = _BottomNavBar._ringStroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
