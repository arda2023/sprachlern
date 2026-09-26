import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Inline gap of the text exercise, design.md 5.8: 128 × 28, `--surface`,
/// radius 8, the base word as `--text-muted` placeholder, 2 px `--lilac`
/// border while focused. Controller and focus node belong to the caller so the
/// screen can reveal the answer of the gap the learner is working on.
class TextGapField extends StatelessWidget {
  const TextGapField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.placeholder,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;

  static const double width = 128.0;
  static const double height = 28.0;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppSpacing.radiusSmall);

    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        expands: true,
        minLines: null,
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.next,
        // The keyboard must not suggest the solution.
        autocorrect: false,
        enableSuggestions: false,
        // design.md 5.8 asks for the blue system cursor; `--blue-link` is the
        // only blue token.
        cursorColor: AppColors.blueLink,
        style: AppTextStyles.body.copyWith(color: AppColors.white),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.surface,
          hintText: placeholder,
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s8,
            vertical: AppSpacing.s4,
          ),
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
