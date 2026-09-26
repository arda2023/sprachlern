import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Search field, design.md 5.16: height 46, `--surface`, radius 8, magnifier 24.
/// The focus border follows design.md 3.4 (2 px `--lilac`).
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  static const double height = 46.0;
  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppSpacing.radiusSmall);

    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        expands: true,
        minLines: null,
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: AppColors.lilac,
        style: AppTextStyles.body.copyWith(color: AppColors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          hintText: 'Suchen',
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.white),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8),
            child: Icon(
              FLucideIcons.search,
              size: _iconSize,
              color: AppColors.white,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(),
          border: OutlineInputBorder(
            borderRadius: shape,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: shape,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: shape,
            borderSide: const BorderSide(color: AppColors.lilac, width: 2),
          ),
        ),
      ),
    );
  }
}
