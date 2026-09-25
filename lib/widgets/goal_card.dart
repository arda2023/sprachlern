import 'package:flutter/material.dart';
import 'package:sprachlern/models/home_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/section_header.dart';

/// Tagesziel mit Wochenleiste, design.md 5.4.
class GoalCard extends StatelessWidget {
  const GoalCard({super.key, required this.goal});

  final DailyGoal goal;

  static const double _dotSize = 8.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader('Heutiges Ziel'),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    '${goal.current} / ${goal.target} Karten',
                    style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: const BoxDecoration(
                    color: AppColors.blueLink,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Text(
                  'Ziel ändern',
                  style: AppTextStyles.body.copyWith(color: AppColors.lilac),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final day in goal.week) Expanded(child: _DayColumn(day: day)),
          ],
        ),
      ],
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({required this.day});

  final WeekDay day;

  static const double _boxSize = 24.0;
  static const double _borderWidth = 2.0;
  static const double _checkSize = 16.0;

  String get _semanticsLabel => switch (day.status) {
        DayStatus.done => '${day.label}, erledigt',
        DayStatus.today => '${day.label}, heute',
        DayStatus.empty => '${day.label}, offen',
      };

  @override
  Widget build(BuildContext context) {
    final label = Text(
      day.label,
      style: AppTextStyles.body.copyWith(color: AppColors.text),
    );

    return Semantics(
      label: _semanticsLabel,
      child: ExcludeSemantics(
        child: Column(
          children: [
            _DayBox(status: day.status),
            const SizedBox(height: AppSpacing.s4),
            if (day.status == DayStatus.today)
              Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s8,
                  AppSpacing.s4,
                  AppSpacing.s8,
                  AppSpacing.s8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface3,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: label,
              )
            else
              label,
          ],
        ),
      ),
    );
  }
}

class _DayBox extends StatelessWidget {
  const _DayBox({required this.status});

  final DayStatus status;

  @override
  Widget build(BuildContext context) {
    final done = status == DayStatus.done;

    return Container(
      width: _DayColumn._boxSize,
      height: _DayColumn._boxSize,
      decoration: BoxDecoration(
        color: done ? AppColors.surface3 : null,
        border: done
            ? null
            : Border.all(
                color: AppColors.surface,
                width: _DayColumn._borderWidth,
              ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusBadge),
      ),
      child: done
          ? const Icon(
              Icons.check,
              size: _DayColumn._checkSize,
              color: AppColors.lilac,
            )
          : null,
    );
  }
}
