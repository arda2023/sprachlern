import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/knowledge_center_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Row of a "Statistik-Zeilenkarte" per design.md 5.6: 46 px tall, icon 28 on
/// the left, label `title`, then a coloured dot Ø 14, the value (`title`,
/// `--text-muted`) and a chevron.
class KnowledgeStatRow extends StatelessWidget {
  const KnowledgeStatRow({super.key, required this.entry, this.onTap});

  final KnowledgeStatEntry entry;
  final VoidCallback? onTap;

  /// Row height per design.md 5.6. It is a minimum: a label that needs two
  /// lines grows the row rather than being clipped.
  static const double minHeight = 46.0;
  static const double _iconSize = 28.0;
  static const double _dotSize = 14.0;
  static const double _chevronSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        key: ValueKey('knowledge_stat_${entry.id}'),
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: minHeight),
          child: Row(
            children: [
              const SizedBox(height: minHeight),
              Icon(entry.icon, size: _iconSize, color: AppColors.white),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  entry.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Container(
                key: ValueKey('knowledge_dot_${entry.id}'),
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: entry.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Text(
                entry.value,
                style: AppTextStyles.title.copyWith(color: AppColors.textMuted),
              ),
              if (entry.hasChevron) ...[
                const SizedBox(width: AppSpacing.s4),
                const Icon(
                  FLucideIcons.chevronRight,
                  size: _chevronSize,
                  color: AppColors.white,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Info sheet without a button per design.md 5.11. Unlike the word info sheet
/// this one is a stats popup, so it sits on `--bg`; it closes via ✕ or by
/// swiping down.
Future<void> showKnowledgeStatSheet(
  BuildContext context,
  KnowledgeStatEntry entry,
) {
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
    builder: (sheetContext) => _KnowledgeStatSheet(entry: entry),
  );
}

class _KnowledgeStatSheet extends StatelessWidget {
  const _KnowledgeStatSheet({required this.entry});

  final KnowledgeStatEntry entry;

  static const double _valueRowHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sheetMargin,
          21,
          AppSpacing.sheetMargin,
          AppSpacing.s32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                key: const ValueKey('knowledge_stat_close'),
                tooltip: 'Statistik schließen',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  FLucideIcons.x,
                  size: 24,
                  color: AppColors.white,
                ),
              ),
            ),
            Row(
              children: [
                Icon(entry.icon, size: 24, color: AppColors.white),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: Text(
                    entry.label,
                    key: const ValueKey('knowledge_stat_sheet_title'),
                    style: AppTextStyles.display.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              entry.description,
              style: AppTextStyles.body.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.s16),
            const _SheetDivider(),
            // Value row between two rules, design.md 5.11: label `title` on the
            // left, value `stat-lg` `--text-muted` on the right.
            SizedBox(
              height: _valueRowHeight,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Text(
                    entry.value,
                    style: AppTextStyles.statLg.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const _SheetDivider(),
          ],
        ),
      ),
    );
  }
}

/// 1 px rule around a sheet value row (design.md 5.11 / 3.4): white on `--bg`.
class _SheetDivider extends StatelessWidget {
  const _SheetDivider();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.white,
      child: SizedBox(height: 1, width: double.infinity),
    );
  }
}
