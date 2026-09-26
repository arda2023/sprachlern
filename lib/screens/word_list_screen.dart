import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/word_list_data.dart';
import 'package:sprachlern/providers/word_list_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/search_field.dart';
import 'package:sprachlern/widgets/word_info_sheet.dart';
import 'package:sprachlern/widgets/word_list_row.dart';

class WordListScreen extends ConsumerStatefulWidget {
  const WordListScreen({super.key});

  @override
  ConsumerState<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends ConsumerState<WordListScreen> {
  final _searchController = TextEditingController();

  /// One key per letter, attached to the first row of that letter, so the
  /// A–Z bar can scroll there. The whole list is built at once (no lazy
  /// loading); fine for a mock list, to be revisited for real word counts.
  final _letterKeys = <String, GlobalKey>{};
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static String _letterOf(WordListEntry entry) =>
      entry.headword.substring(0, 1).toUpperCase();

  List<WordListEntry> _filter(List<WordListEntry> all) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return all;
    return all
        .where((entry) => entry.headword.toLowerCase().contains(query))
        .toList();
  }

  void _jumpTo(String letter) {
    final letterContext = _letterKeys[letter]?.currentContext;
    if (letterContext == null) return;
    Scrollable.ensureVisible(letterContext, duration: Duration.zero);
  }

  void _openInfo(WordListEntry entry) {
    final info = ref.read(wordInfoProvider(entry.headword));
    if (info != null) showWordInfoSheet(context, info);
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filter(ref.watch(wordListProvider));
    final letters = <String>[];
    final rows = <Widget>[];

    for (final (index, entry) in entries.indexed) {
      final letter = _letterOf(entry);
      Widget row = WordListRow(
        key: ValueKey('word_row_${entry.headword}'),
        entry: entry,
        onTap: () => _openInfo(entry),
      );

      if (!letters.contains(letter)) {
        letters.add(letter);
        row = KeyedSubtree(
          key: _letterKeys.putIfAbsent(letter, GlobalKey.new),
          child: row,
        );
      }

      if (index > 0) {
        rows.add(
          const ColoredBox(
            color: AppColors.surface,
            child: SizedBox(height: 1, width: double.infinity),
          ),
        );
      }
      rows.add(row);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/content');
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageMargin,
                AppSpacing.s16,
                AppSpacing.pageMargin,
                AppSpacing.s8,
              ),
              child: AppSearchField(
                key: const ValueKey('word_search_field'),
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: entries.isEmpty
                  ? const _EmptyState()
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.s8,
                              0,
                              AppSpacing.pageMargin,
                              AppSpacing.s24,
                            ),
                            child: Column(children: rows),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          width: AppSpacing.pageMargin,
                          child: Center(
                            child: _AzIndexBar(
                              letters: letters,
                              onSelect: _jumpTo,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A–Z jump bar on the right edge (design.md 5.10). It lists only the letters
/// that have entries; tapping or dragging over it scrolls to that letter.
class _AzIndexBar extends StatelessWidget {
  const _AzIndexBar({required this.letters, required this.onSelect});

  final List<String> letters;
  final ValueChanged<String> onSelect;

  /// Line height of `meta` (13 / 16).
  static const double _letterHeight = 16.0;

  void _select(double dy) {
    final index = (dy / _letterHeight).floor().clamp(0, letters.length - 1);
    onSelect(letters[index]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) => _select(details.localPosition.dy),
      onVerticalDragUpdate: (details) => _select(details.localPosition.dy),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final letter in letters)
            Semantics(
              button: true,
              excludeSemantics: true,
              label: 'Zu $letter springen',
              onTap: () => onSelect(letter),
              child: SizedBox(
                key: ValueKey('az_$letter'),
                height: _letterHeight,
                child: Center(
                  child: Text(
                    letter,
                    style: AppTextStyles.meta.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// design.md 7: empty states are plain text, no illustration.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sheetMargin),
        child: Text(
          'Keine Wörter gefunden.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  static const double _height = 44.0;
  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Row(
        children: [
          SizedBox(
            width: _height,
            height: _height,
            child: IconButton(
              tooltip: 'Zurück zu Inhalte',
              onPressed: onBack,
              padding: EdgeInsets.zero,
              icon: const Icon(
                FLucideIcons.arrowLeft,
                size: _iconSize,
                color: AppColors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Wortlisten',
                style: AppTextStyles.navTitle.copyWith(color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(width: _height),
        ],
      ),
    );
  }
}
