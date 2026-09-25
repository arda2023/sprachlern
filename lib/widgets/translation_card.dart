import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

class TranslationCard extends StatefulWidget {
  const TranslationCard({
    super.key,
    required this.headword,
    required this.exampleSentence,
  });

  final String headword;
  final String exampleSentence;

  @override
  State<TranslationCard> createState() => _TranslationCardState();
}

class _TranslationCardState extends State<TranslationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                  widget.headword,
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
              ),
              IconButton(
                key: const ValueKey('translation_toggle'),
                tooltip: _isExpanded
                    ? 'Übersetzung einklappen'
                    : 'Übersetzung aufklappen',
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(
                  _isExpanded
                      ? FLucideIcons.chevronUp
                      : FLucideIcons.chevronDown,
                  size: 16,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          if (_isExpanded) ...[
            const SizedBox(height: AppSpacing.s8),
            Text(
              widget.exampleSentence,
              style: AppTextStyles.body.copyWith(color: AppColors.white),
            ),
          ],
        ],
      ),
    );
  }
}
