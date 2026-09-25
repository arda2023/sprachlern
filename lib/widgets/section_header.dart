import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Uppercase section header ("MEINE FORTSCHRITTE"), design.md section 2 `section`.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.section.copyWith(color: AppColors.text),
    );
  }
}
