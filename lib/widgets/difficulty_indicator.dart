import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';

/// Three bolts showing a stack's difficulty (design.md 4). Shared by the stack
/// list row (5.10) and the stack detail status area (5.17).
class DifficultyIndicator extends StatelessWidget {
  const DifficultyIndicator({super.key, required this.level});

  final int level;

  static const double boltSize = 14.0;

  @override
  Widget build(BuildContext context) {
    final filledBolts = level.clamp(0, 3);

    return Semantics(
      label: 'Schwierigkeit $filledBolts von 3',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(right: index == 2 ? 0 : AppSpacing.s16),
              child: Icon(
                FLucideIcons.bolt,
                size: boltSize,
                color: index < filledBolts
                    ? AppColors.iconBolt
                    : AppColors.iconBoltOff,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
