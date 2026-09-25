import 'package:flutter/material.dart';
import 'package:sprachlern/models/home_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Horizontal carousel of [PromoCard]s, design.md 5.5.
class PromoCarousel extends StatelessWidget {
  const PromoCarousel({super.key, required this.promos});

  final List<PromoContent> promos;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PromoCard.height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
        itemCount: promos.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s16),
        itemBuilder: (_, i) => PromoCard(content: promos[i]),
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  const PromoCard({super.key, required this.content});

  final PromoContent content;

  static const double width = 317.0;
  static const double height = 141.0;
  static const double _buttonHeight = 30.0;
  static const double _closeSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  content.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: AppColors.text),
                ),
              ),
              Semantics(
                label: 'Schließen',
                child: const Icon(
                  Icons.close,
                  size: _closeSize,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            content.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(color: AppColors.text),
          ),
          const Spacer(),
          Container(
            height: _buttonHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text(
              'Übung starten',
              style: AppTextStyles.title.copyWith(color: AppColors.textOnLight),
            ),
          ),
        ],
      ),
    );
  }
}
