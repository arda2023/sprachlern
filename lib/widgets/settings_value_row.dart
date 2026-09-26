import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Chevron row of the settings screen per design.md 5.10 ("Konto /
/// Einstellungen"): `title` in white, 60 px tall, optional muted value left of
/// the chevron.
class SettingsValueRow extends StatelessWidget {
  const SettingsValueRow({
    super.key,
    required this.rowKey,
    required this.title,
    this.value,
    this.onTap,
  });

  /// Key of the underlying settings row, used for the widget key.
  final String rowKey;

  final String title;
  final String? value;
  final VoidCallback? onTap;

  static const double height = 60.0;
  static const double _chevronSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        key: ValueKey('settings_value_$rowKey'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
              ),
              if (value != null) ...[
                Text(
                  value!,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
              ],
              const Icon(
                FLucideIcons.chevronRight,
                size: _chevronSize,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
