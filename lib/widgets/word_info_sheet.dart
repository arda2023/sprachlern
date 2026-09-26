import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/word_list_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Info sheet without button, design.md 5.11: it sits on `--surface` and closes
/// via ✕ or by swiping down. The note lives only as long as the sheet — it is
/// not written back to any provider yet.
Future<void> showWordInfoSheet(BuildContext context, WordInfoData info) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    barrierColor: AppColors.scrim,
    isScrollControlled: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusSheet),
      ),
    ),
    builder: (sheetContext) => _WordInfoSheet(info: info),
  );
}

class _WordInfoSheet extends StatefulWidget {
  const _WordInfoSheet({required this.info});

  final WordInfoData info;

  @override
  State<_WordInfoSheet> createState() => _WordInfoSheetState();
}

class _WordInfoSheetState extends State<_WordInfoSheet> {
  late final TextEditingController _noteController = TextEditingController(
    text: widget.info.note,
  );

  static const int _noteLines = 4;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        // Keeps the notes field above the keyboard.
        padding: EdgeInsets.fromLTRB(
          24,
          21,
          24,
          32 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                key: const ValueKey('word_info_close'),
                tooltip: 'Wortinformationen schließen',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  FLucideIcons.x,
                  size: 24,
                  color: AppColors.white,
                ),
              ),
            ),
            Text(
              'Informationen zum Wort',
              style: AppTextStyles.display.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.s16),
            const _Divider(),
            const SizedBox(height: AppSpacing.s16),
            Row(
              children: [
                Flexible(
                  child: Text(info.headword, style: AppTextStyles.enHeadword),
                ),
                const SizedBox(width: AppSpacing.s8),
                const Icon(
                  FLucideIcons.volume2,
                  size: 24,
                  color: AppColors.white,
                  semanticLabel: 'Aussprache',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              info.translation,
              style: AppTextStyles.title.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppSpacing.s16),
            const _Divider(),
            const SizedBox(height: AppSpacing.s16),
            Text(info.exampleSentence, style: AppTextStyles.enLine),
            const SizedBox(height: AppSpacing.s16),
            const _Divider(),
            TextField(
              key: const ValueKey('word_note_field'),
              controller: _noteController,
              minLines: _noteLines,
              maxLines: null,
              maxLength: WordInfoData.maxNoteLength,
              keyboardType: TextInputType.multiline,
              cursorColor: AppColors.lilac,
              style: AppTextStyles.body.copyWith(color: AppColors.white),
              // The counter is drawn by the decoration, right under the field.
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) => Text(
                    '$currentLength / $maxLength',
                    key: const ValueKey('word_note_counter'),
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Füge eigene Notizen hinzu …',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.s16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 1 px rule between the sections of the sheet. The sheet sits on `--surface`,
/// so the rule is one step lighter (`--surface-2`), like the progress tracks.
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surface2,
      child: SizedBox(height: 1, width: double.infinity),
    );
  }
}
