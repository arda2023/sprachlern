import 'package:flutter/material.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Text('Lernen', style: AppTextStyles.display.copyWith(color: AppColors.text)),
      ),
    );
  }
}
