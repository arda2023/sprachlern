import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Collapsible "letzte 5 Wörter" card (design.md 5.17). Collapsed by default,
/// matching the translation card's pattern.
class RecentWordsCard extends StatefulWidget {
  const RecentWordsCard({super.key, required this.entries});

  final List<RecentWordEntry> entries;

  @override
  State<RecentWordsCard> createState() => _RecentWordsCardState();
}

class _RecentWordsCardState extends State<RecentWordsCard> {
  bool _isExpanded = false;

  static const double _chevronSize = 16.0;

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
                  'Deine letzten 5 gesehenen Wörter dieses Stapels:',
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
              ),
              IconButton(
                key: const ValueKey('recent_words_toggle'),
                tooltip: _isExpanded
                    ? 'Wortliste einklappen'
                    : 'Wortliste aufklappen',
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(
                  _isExpanded
                      ? FLucideIcons.chevronUp
                      : FLucideIcons.chevronDown,
                  size: _chevronSize,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          if (_isExpanded)
            for (final (index, entry) in widget.entries.indexed) ...[
              if (index > 0)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.s12),
                  child: ColoredBox(
                    color: AppColors.surface2,
                    child: SizedBox(height: 1, width: double.infinity),
                  ),
                )
              else
                const SizedBox(height: AppSpacing.s8),
              _RecentWordTile(entry: entry),
            ],
        ],
      ),
    );
  }
}

class _RecentWordTile extends StatelessWidget {
  const _RecentWordTile({required this.entry});

  final RecentWordEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.germanWord,
          style: AppTextStyles.title.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(
          entry.germanExample,
          style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(entry.englishExample, style: AppTextStyles.enLine),
      ],
    );
  }
}
