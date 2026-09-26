import 'package:flutter/material.dart';
import 'package:sprachlern/models/settings_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/app_toggle.dart';

/// Toggle row per design.md 5.13: title `title` on the left, toggle on the
/// right, description (`body-sm`, `--text-muted`) underneath.
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.entry,
    required this.onChanged,
  });

  final SettingsToggleEntry entry;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  entry.description,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s16),
          AppToggle(
            key: ValueKey('settings_toggle_${entry.key}'),
            value: entry.value,
            onChanged: onChanged,
            semanticLabel: entry.title,
          ),
        ],
      ),
    );
  }
}
