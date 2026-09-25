import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class ExerciseInputBar extends StatelessWidget {
  const ExerciseInputBar({super.key});

  static const _height = 47.0;
  static const _buttonHeight = 30.0;
  static const _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: _height,
        child: ColoredBox(
          color: AppColors.surface,
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.s16),
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  tooltip: 'Spracheingabe',
                  onPressed: _doNothing,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 44,
                  ),
                  icon: const Icon(
                    FLucideIcons.mic,
                    size: _iconSize,
                    color: AppColors.white,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: _buttonHeight,
                child: TextButton(
                  onPressed: _doNothing,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.surface2,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                    ),
                    minimumSize: const Size(0, _buttonHeight),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Wort erfahren',
                    style: AppTextStyles.title.copyWith(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}

void _doNothing() {}
