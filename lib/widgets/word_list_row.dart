import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/word_list_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Wortlisten-Zeile, design.md 5.10. A tap opens the word info sheet.
class WordListRow extends StatelessWidget {
  const WordListRow({super.key, required this.entry, this.onTap});

  final WordListEntry entry;
  final VoidCallback? onTap;

  static const double _iconSize = 24.0;
  static const double _chevronSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _Texts(entry: entry)),
              const SizedBox(width: AppSpacing.s8),
              const _ActionIcons(),
              const SizedBox(width: AppSpacing.s8),
              const SizedBox(
                width: _iconSize,
                child: Icon(
                  FLucideIcons.chevronRight,
                  size: _chevronSize,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({required this.entry});

  final WordListEntry entry;

  @override
  Widget build(BuildContext context) {
    final example = Text(entry.exampleSentence, style: AppTextStyles.enLine);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _indented(
          Row(
            children: [
              Flexible(
                child: Text(entry.headword, style: AppTextStyles.enHeadword),
              ),
              const SizedBox(width: AppSpacing.s8),
              const Icon(
                FLucideIcons.volume2,
                size: WordListRow._iconSize,
                color: AppColors.white,
                semanticLabel: 'Aussprache',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        // The pill starts one indent further left, so the sentence keeps the
        // same left edge as in the unselected rows.
        if (entry.isCurrentlySelected)
          DecoratedBox(
            key: const ValueKey('word_row_selected_pill'),
            decoration: BoxDecoration(
              color: AppColors.tealPill,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8),
              child: example,
            ),
          )
        else
          _indented(example),
        const SizedBox(height: AppSpacing.s4),
        _indented(
          Text(
            'Zuletzt gesehen: ${entry.lastSeen} | '
            'Wiederholt: ${entry.repeatCount} Mal',
            style: AppTextStyles.meta.copyWith(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _indented(Widget child) => Padding(
    padding: const EdgeInsets.only(left: AppSpacing.s8),
    child: child,
  );
}

/// Three dimmed actions, stacked. Inert for now and purely decorative
/// (design.md 8: dimmed icons carry no meaning on their own).
class _ActionIcons extends StatelessWidget {
  const _ActionIcons();

  static const _icons = [
    FLucideIcons.listX,
    FLucideIcons.music,
    FLucideIcons.heart,
  ];

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (index, icon) in _icons.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.s16),
            Icon(icon, size: WordListRow._iconSize, color: AppColors.iconDim),
          ],
        ],
      ),
    );
  }
}
