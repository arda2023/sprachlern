import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

enum InputMode { words, text }

/// Segmented control for the two input modes. design.md has no segmented
/// control, so this borrows 5.14's tab colours (active white, inactive muted)
/// and the pill radius from 3.3; the track follows the surface ladder from 1.6
/// (`--surface` on `--bg`, selected segment one step lighter at `--surface-2`).
class InputModeToggle extends StatelessWidget {
  const InputModeToggle({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final InputMode mode;
  final ValueChanged<InputMode> onChanged;

  static const double _height = 40.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        children: [
          _Segment(
            label: 'Wörter',
            selected: mode == InputMode.words,
            onTap: () => onChanged(InputMode.words),
          ),
          _Segment(
            label: 'Text',
            selected: mode == InputMode.text,
            onTap: () => onChanged(InputMode.text),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: GestureDetector(
          key: ValueKey('input_mode_$label'),
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.surface2 : null,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text(
              label,
              style: AppTextStyles.navTitle.copyWith(
                color: selected ? AppColors.white : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
