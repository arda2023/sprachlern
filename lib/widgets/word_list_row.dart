import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/word_list_data.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';

/// Wortlisten-Zeile, design.md 5.10. A tap opens the word info sheet.
class WordListRow extends StatelessWidget {
  const WordListRow({
    super.key,
    required this.entry,
    this.onTap,
    this.onDeactivate,
    this.onSpeak,
    this.onPlaylistTap,
    this.onFavoriteTap,
  });

  final WordListEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onDeactivate;
  final ValueChanged<String>? onSpeak;
  final VoidCallback? onPlaylistTap;
  final VoidCallback? onFavoriteTap;

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
              Expanded(
                child: _Texts(entry: entry, onSpeak: onSpeak),
              ),
              const SizedBox(width: AppSpacing.s8),
              _ActionIcons(
                entry: entry,
                onDeactivate: onDeactivate,
                onPlaylistTap: onPlaylistTap,
                onFavoriteTap: onFavoriteTap,
              ),
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
  const _Texts({required this.entry, this.onSpeak});

  final WordListEntry entry;
  final ValueChanged<String>? onSpeak;

  @override
  Widget build(BuildContext context) {
    final example = GestureDetector(
      key: ValueKey('word_row_sentence_${entry.stackWordId}'),
      behavior: HitTestBehavior.opaque,
      onTap: () => onSpeak?.call(entry.exampleSentence),
      child: Text(entry.exampleSentence, style: AppTextStyles.enLine),
    );

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
              GestureDetector(
                key: ValueKey('word_row_speaker_${entry.stackWordId}'),
                behavior: HitTestBehavior.opaque,
                onTap: () => onSpeak?.call(entry.headword),
                child: Semantics(
                  button: true,
                  label: 'Wort aussprechen',
                  child: Icon(
                    FLucideIcons.volume2,
                    size: WordListRow._iconSize,
                    color: AppColors.white,
                  ),
                ),
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

class _ActionIcons extends StatelessWidget {
  const _ActionIcons({
    required this.entry,
    this.onDeactivate,
    this.onPlaylistTap,
    this.onFavoriteTap,
  });

  final WordListEntry entry;
  final VoidCallback? onDeactivate;
  final VoidCallback? onPlaylistTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionIcon(
          key: ValueKey('word_row_deactivate_${entry.stackWordId}'),
          icon: FLucideIcons.listX,
          label: 'Wort deaktivieren',
          onTap: onDeactivate,
        ),
        const SizedBox(height: AppSpacing.s16),
        _ActionIcon(
          key: ValueKey('word_row_playlist_${entry.stackWordId}'),
          icon: FLucideIcons.music,
          label: 'Zur Playlist hinzufügen',
          onTap: onPlaylistTap,
        ),
        const SizedBox(height: AppSpacing.s16),
        _ActionIcon(
          key: ValueKey('word_row_favorite_${entry.stackWordId}'),
          icon: FLucideIcons.heart,
          label: entry.isFavorite ? 'Favorit entfernen' : 'Favorit markieren',
          color: entry.isFavorite ? AppColors.lilac : AppColors.iconDim,
          onTap: onFavoriteTap,
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    super.key,
    required this.icon,
    required this.label,
    this.color = AppColors.iconDim,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ?? () {},
        child: Icon(icon, size: WordListRow._iconSize, color: color),
      ),
    );
  }
}
