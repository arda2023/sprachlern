import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';

/// iOS-style toggle per design.md 5.13: 51 × 31, knob Ø 27, track `--lilac`
/// when on and `--track-off` when off.
///
/// Extracted from `stack_detail_screen.dart`'s private `_Toggle`, unchanged.
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  /// German label, since the toggle carries no visible text of its own
  /// (design.md 8).
  final String semanticLabel;

  static const double _width = 51.0;
  static const double _height = 31.0;
  static const double _knobSize = 27.0;
  static const double _inset = (_height - _knobSize) / 2;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          width: _width,
          height: _height,
          padding: const EdgeInsets.all(_inset),
          decoration: BoxDecoration(
            color: value ? AppColors.lilac : AppColors.trackOff,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          child: Align(
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: _knobSize,
              height: _knobSize,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
