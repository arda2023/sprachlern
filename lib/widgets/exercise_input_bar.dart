import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// What the action button does; it follows the state of the gap
/// (design.md 5.7, item 5).
enum ExerciseAction {
  /// Empty gap: reveal the answer as help, without scoring an attempt.
  revealWord,

  /// Text entered: check it against the answer.
  submit,

  /// Answer confirmed correct: move on to the next card.
  next,
}

class ExerciseInputBar extends StatelessWidget {
  const ExerciseInputBar({
    super.key,
    required this.action,
    required this.onAction,
  });

  final ExerciseAction action;

  /// `null` disables the button, e.g. while "Weiter" saves the result.
  final VoidCallback? onAction;

  static const _height = 47.0;
  static const _buttonHeight = 30.0;
  static const _iconSize = 24.0;

  // The success circle of design.md 5.9.
  static const _checkSize = 22.0;
  static const _checkIconSize = 14.0;

  static const _disabledOpacity = 0.4;

  @override
  Widget build(BuildContext context) {
    final (label, background, foreground) = switch (action) {
      ExerciseAction.revealWord => (
        'Wort erfahren',
        AppColors.surface2,
        AppColors.white,
      ),
      ExerciseAction.submit => (
        'Eingeben',
        AppColors.white,
        AppColors.textOnLight,
      ),
      ExerciseAction.next => ('Weiter', AppColors.white, AppColors.textOnLight),
    };

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
              if (action == ExerciseAction.next) ...[
                Semantics(
                  label: 'Richtig',
                  child: Container(
                    key: const ValueKey('exercise_action_check'),
                    width: _checkSize,
                    height: _checkSize,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FLucideIcons.check,
                      size: _checkIconSize,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
              ],
              Opacity(
                opacity: onAction == null ? _disabledOpacity : 1,
                child: SizedBox(
                  height: _buttonHeight,
                  child: TextButton(
                    key: const ValueKey('exercise_action'),
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      backgroundColor: background,
                      disabledBackgroundColor: background,
                      foregroundColor: foreground,
                      disabledForegroundColor: foreground,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                      ),
                      minimumSize: const Size(0, _buttonHeight),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      label,
                      style: AppTextStyles.title.copyWith(color: foreground),
                    ),
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
