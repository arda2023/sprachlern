import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/account_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Row of the account list per design.md 5.10 ("Konto / Einstellungen"):
/// `title` in white, 60 px tall, chevron on the right, optional muted value —
/// and optionally a status dot left of the value ("Abonnement").
class AccountListRow extends StatelessWidget {
  const AccountListRow({super.key, required this.entry, this.onTap});

  final AccountListEntry entry;
  final VoidCallback? onTap;

  static const double height = 60.0;
  static const double _dotSize = 8.0;
  static const double _chevronSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        key: ValueKey('account_row_${entry.id}'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    // The status dot sits directly behind the title, not next
                    // to the value ("Abonnement", design.md 6).
                    if (entry.dotColor != null) ...[
                      const SizedBox(width: AppSpacing.s8),
                      Container(
                        key: ValueKey('account_dot_${entry.id}'),
                        width: _dotSize,
                        height: _dotSize,
                        decoration: BoxDecoration(
                          color: entry.dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              if (entry.value != null) ...[
                Text(
                  entry.value!,
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
