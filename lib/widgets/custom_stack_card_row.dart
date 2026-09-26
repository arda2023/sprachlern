import 'package:flutter/material.dart';
import 'package:sprachlern/models/custom_stack_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// One card of a custom stack, styled per design.md 5.3. Both lines are German
/// UI/learning input, so they stay Sans + white/muted — cyan serif is reserved
/// for English content (design.md 2).
class CustomStackCardRow extends StatelessWidget {
  const CustomStackCardRow({super.key, required this.card});

  final CustomStackCard card;

  static const double _dotSize = 8.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('custom_card_${card.id}'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s8),
            child: Container(
              width: _dotSize,
              height: _dotSize,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.targetWord,
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  card.germanSentence,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
