import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Tabs per design.md 5.14: `nav-title`, active white, inactive `--text-muted`,
/// 2 px `--lilac` indicator as wide as the tab at its bottom edge, no surface
/// behind it. Tabs share the width equally and the whole tab is the tap target
/// (44 px tall per design.md 7).
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.keyPrefix = 'tab',
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Prefix for the per-tab `ValueKey`s, so two tab bars on one screen stay
  /// addressable in tests.
  final String keyPrefix;

  static const double _labelHeight = 44.0;
  static const double _indicatorHeight = 2.0;
  static const double height = _labelHeight + _indicatorHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == selectedIndex;
          return Expanded(
            child: Semantics(
              button: true,
              selected: selected,
              child: GestureDetector(
                key: ValueKey('${keyPrefix}_$index'),
                onTap: () => onSelected(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          labels[index],
                          textAlign: TextAlign.center,
                          style: AppTextStyles.navTitle.copyWith(
                            color: selected
                                ? AppColors.white
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _indicatorHeight,
                      width: double.infinity,
                      child: selected
                          ? const ColoredBox(color: AppColors.lilac)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
