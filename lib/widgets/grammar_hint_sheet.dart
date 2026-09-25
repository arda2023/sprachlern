import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/exercise_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

Future<void> showGrammarHintSheet(BuildContext context, ExerciseData exercise) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.bg,
    barrierColor: AppColors.scrim,
    isScrollControlled: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusSheet),
      ),
    ),
    builder: (sheetContext) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 21, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                key: const ValueKey('grammar_hint_close'),
                tooltip: 'Grammatikhinweis schließen',
                onPressed: () => Navigator.of(sheetContext).pop(),
                icon: const Icon(
                  FLucideIcons.x,
                  size: 24,
                  color: AppColors.white,
                ),
              ),
            ),
            Text(
              exercise.grammarHintTitle,
              style: AppTextStyles.display.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              exercise.grammarHintDescription,
              style: AppTextStyles.body.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
