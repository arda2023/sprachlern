import 'package:flutter/material.dart';
import 'package:sprachlern/models/account_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Profile row of the account screen (design.md 6, "Konto": Icon + Wert).
class AccountProfileRow extends StatelessWidget {
  const AccountProfileRow({super.key, required this.entry});

  final AccountProfileEntry entry;

  static const double height = 46.0;
  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Icon(
            entry.icon,
            size: _iconSize,
            color: AppColors.white,
            semanticLabel: entry.semanticLabel,
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              entry.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
