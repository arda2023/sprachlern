import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/text_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/round_play_button.dart';
import 'package:sprachlern/widgets/text_cover_card.dart';

const _exerciseRows = [
  (label: 'Verben', icon: FLucideIcons.messageSquareText),
  (label: 'Beliebige Wortart', icon: FLucideIcons.listChecks),
];

/// "Vorschau-Sheet mit Übungsliste", design.md 5.11: no primary button, an
/// exercise starts from the round play button of its row.
Future<void> showTextPreviewSheet(BuildContext context, TextCoverData cover) {
  final router = GoRouter.of(context);

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
    builder: (sheetContext) => SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 21, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                key: const ValueKey('text_preview_close'),
                tooltip: 'Vorschau schließen',
                onPressed: () => Navigator.of(sheetContext).pop(),
                icon: const Icon(
                  FLucideIcons.x,
                  size: 24,
                  color: AppColors.white,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCoverArt(palette: cover.palette),
                const SizedBox(width: AppSpacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cover.title,
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      TextLevelBadge(
                        label: cover.levelLabel,
                        color: AppColors.surface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              'Lerne beim Lesen: Ergänze die Lücken, während du einen kurzen '
              'Text liest.',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.s16),
            for (final (index, row) in _exerciseRows.indexed) ...[
              if (index > 0)
                const ColoredBox(
                  color: AppColors.surface,
                  child: SizedBox(height: 1, width: double.infinity),
                ),
              _ExerciseRow(
                label: row.label,
                icon: row.icon,
                onPlay: () {
                  Navigator.of(sheetContext).pop();
                  router.push('/texts/${cover.id}/exercise');
                },
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.label,
    required this.icon,
    required this.onPlay,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPlay;

  static const double _tileSize = 40.0;
  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      child: Row(
        children: [
          Container(
            width: _tileSize,
            height: _tileSize,
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(icon, size: _iconSize, color: AppColors.white),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.title.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          RoundPlayButton(
            key: ValueKey('text_preview_play_$label'),
            tooltip: '$label starten',
            onPressed: onPlay,
          ),
        ],
      ),
    );
  }
}
