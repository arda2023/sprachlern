import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const double _barHeight = 49.0;

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: _barHeight + safePadding,
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

  static const double _barHeight = 49.0;
  static const double _ringDiameter = 73.0;
  static const double _ringRadius = _ringDiameter / 2;
  static const double _circleDiameter = 48.0;
  static const double _ringStroke = 4.0;
  static const double _iconSize = 28.0;
  static const double _iconLabelGap = AppSpacing.s4;

  @override
  Widget build(BuildContext context) {
    final double totalHeight = _ringRadius + _barHeight + safePadding;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bar background with top divider and 5-slot row
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: _barHeight + safePadding,
            child: ColoredBox(
              color: AppColors.bg,
              child: Column(
                children: [
                  Container(height: 1, color: AppColors.surface),
                  Expanded(
                    child: Row(
                      children: [
                        _buildRegularSlot(Icons.home_outlined, 'Hauptseite', 0),
                        _buildRegularSlot(Icons.grid_view_outlined, 'Inhalte', 1),
                        _buildLernenLabelSlot(),
                        _buildRegularSlot(Icons.bar_chart_outlined, 'Fortschritte', 3),
                        _buildKontoSlot(),
                      ],
                    ),
                  ),
                  SizedBox(height: safePadding),
                ],
              ),
            ),
          ),
          // Ring + circle visual only — IgnorePointer so taps fall through to the Row slot
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _ringDiameter,
            child: Center(
              child: IgnorePointer(
                child: SizedBox(
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
                          Icons.play_arrow,
                          size: 20,
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

  Widget _buildRegularSlot(IconData icon, String label, int index) {
    final active = currentIndex == index;
    final color = active ? AppColors.lilac : AppColors.white;

    return Expanded(
      child: GestureDetector(
        key: ValueKey('nav_$index'),
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: _iconSize, color: color),
            const SizedBox(height: _iconLabelGap),
            Text(label, style: AppTextStyles.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildLernenLabelSlot() {
    final color = currentIndex == 2 ? AppColors.lilac : AppColors.white;

    return Expanded(
      child: GestureDetector(
        key: const ValueKey('nav_2'),
        onTap: () => onTap(2),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Lernen', style: AppTextStyles.caption.copyWith(color: color)),
            const SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
  }

  Widget _buildKontoSlot() {
    final active = currentIndex == 4;
    final color = active ? AppColors.lilac : AppColors.white;

    return Expanded(
      child: GestureDetector(
        key: const ValueKey('nav_4'),
        onTap: () => onTap(4),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.person_outlined, size: _iconSize, color: color),
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
            ),
            const SizedBox(height: _iconLabelGap),
            Text('Konto', style: AppTextStyles.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
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
