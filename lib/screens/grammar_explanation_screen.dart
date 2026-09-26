import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sprachlern/models/grammar_topic_data.dart';
import 'package:sprachlern/providers/grammar_topic_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/tab_bar.dart';

/// "Grammatikhinweise" per design.md 6: level tabs over a topic list without
/// chevrons (design.md 5.10). A tap opens the light explanation page, which is
/// a separate route (`/grammar-topics/:id`) because design.md's screen
/// inventory lists it as its own screen.
class GrammarExplanationScreen extends ConsumerStatefulWidget {
  const GrammarExplanationScreen({super.key});

  @override
  ConsumerState<GrammarExplanationScreen> createState() =>
      _GrammarExplanationScreenState();
}

class _GrammarExplanationScreenState
    extends ConsumerState<GrammarExplanationScreen> {
  int _selectedLevel = 0;

  @override
  Widget build(BuildContext context) {
    final level = grammarExplanationLevels[_selectedLevel];
    final topics = ref.watch(grammarExplanationTopicsByLevelProvider(level));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _DarkTopBar(
              title: 'Grammatikhinweise',
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/content');
                }
              },
            ),
            AppTabBar(
              keyPrefix: 'grammar_level_tab',
              labels: grammarExplanationLevels,
              selectedIndex: _selectedLevel,
              onSelected: (index) => setState(() => _selectedLevel = index),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageMargin,
                  vertical: AppSpacing.s8,
                ),
                itemCount: topics.length,
                separatorBuilder: (_, _) => const _RowDivider(),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return Semantics(
                    button: true,
                    child: GestureDetector(
                      key: ValueKey('grammar_hint_${topic.id}'),
                      onTap: () => context.push('/grammar-topics/${topic.id}'),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        // 60 px rows, no chevron (design.md 5.10).
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            topic.title,
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The light explanation page, design.md 9: the only screen in the light theme.
class GrammarExplanationDetailScreen extends ConsumerWidget {
  const GrammarExplanationDetailScreen({super.key, required this.topicId});

  final String topicId;

  /// Column 2 starts at 63 px (design.md 9).
  static const double _germanColumnStart = 63.0;

  /// "Achtung!" heading: 24 px, weight 700, centred (design.md 2 and 9).
  static const double _warningHeadingSize = 24.0;

  /// Table type scale: 18 / 26 in both columns (design.md 9).
  static const double _tableFontSize = 18.0;
  static const double _tableLineHeight = 26.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topic = ref.watch(grammarExplanationTopicProvider(topicId));

    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            _LightTopBar(
              title: topic?.title ?? 'Grammatikhinweis',
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/grammar-topics');
                }
              },
            ),
            Expanded(
              child: topic == null
                  ? Center(
                      child: Text(
                        'Dieser Hinweis ist nicht verfügbar.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.lightText,
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.pageMargin,
                        AppSpacing.s16,
                        AppSpacing.pageMargin,
                        AppSpacing.s32,
                      ),
                      children: [
                        for (final pair in topic.wordPairs)
                          _TableRow(pair: pair),
                        const SizedBox(height: AppSpacing.s32),
                        Text(
                          'Achtung!',
                          key: const ValueKey('grammar_warning_heading'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.figtree(
                            fontSize: _warningHeadingSize,
                            height: 28 / _warningHeadingSize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightText,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        _WarningBox(warnings: topic.warnings),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One row of the two-column table (design.md 9): English serif on the left,
/// German sans on the right, starting at 63 px.
class _TableRow extends StatelessWidget {
  const _TableRow({required this.pair});

  final GrammarWordPair pair;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: GrammarExplanationDetailScreen._germanColumnStart,
            child: Text(pair.english, style: _lightEnglishStyle),
          ),
          Expanded(child: Text(pair.german, style: _lightGermanStyle)),
        ],
      ),
    );
  }
}

/// "Achtung!" box (design.md 9): 1 px `--light-border`, no radius, padding 16,
/// bullet points with English words in serif `--light-en`.
class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.warnings});

  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('grammar_warning_box'),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < warnings.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == warnings.length - 1 ? 0 : AppSpacing.s12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•', style: _lightGermanStyle),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: Text.rich(
                      _warningSpan(warnings[i]),
                      style: _lightGermanStyle,
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

/// Splits a bullet at the ", " that separates the German explanation from its
/// English example, so the example renders in serif `--light-en` (design.md 9).
/// Keeps the German part in sans; a bullet without such a marker stays German.
InlineSpan _warningSpan(String text) {
  const marker = ': ';
  final index = text.indexOf(marker);
  if (index < 0) return TextSpan(text: text);

  return TextSpan(
    children: [
      TextSpan(text: text.substring(0, index + marker.length)),
      TextSpan(
        text: text.substring(index + marker.length),
        style: _lightEnglishStyle,
      ),
    ],
  );
}

/// English on the light page: serif 18 / 26 in `--light-en` (design.md 9).
final TextStyle _lightEnglishStyle = GoogleFonts.sourceSerif4(
  fontSize: GrammarExplanationDetailScreen._tableFontSize,
  height:
      GrammarExplanationDetailScreen._tableLineHeight /
      GrammarExplanationDetailScreen._tableFontSize,
  fontWeight: FontWeight.w400,
  color: AppColors.lightEn,
);

/// German on the light page: sans 18 / 26 in `--light-text` (design.md 9).
final TextStyle _lightGermanStyle = GoogleFonts.figtree(
  fontSize: GrammarExplanationDetailScreen._tableFontSize,
  height:
      GrammarExplanationDetailScreen._tableLineHeight /
      GrammarExplanationDetailScreen._tableFontSize,
  fontWeight: FontWeight.w400,
  color: AppColors.lightText,
);

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surface,
      child: SizedBox(height: 1, width: double.infinity),
    );
  }
}

class _DarkTopBar extends StatelessWidget {
  const _DarkTopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => _TopBar(
    title: title,
    onBack: onBack,
    foreground: AppColors.white,
    backTooltip: 'Zurück zu Inhalte',
  );
}

/// Top bar of the light page: back arrow and centred title in `--light-text`
/// (design.md 9).
class _LightTopBar extends StatelessWidget {
  const _LightTopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => _TopBar(
    title: title,
    onBack: onBack,
    foreground: AppColors.lightText,
    backTooltip: 'Zurück zu den Grammatikhinweisen',
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onBack,
    required this.foreground,
    required this.backTooltip,
  });

  final String title;
  final VoidCallback onBack;
  final Color foreground;
  final String backTooltip;

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
              tooltip: backTooltip,
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: _height,
                height: _height,
              ),
              icon: Icon(
                FLucideIcons.arrowLeft,
                size: _iconSize,
                color: foreground,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.navTitle.copyWith(color: foreground),
              ),
            ),
          ),
          const SizedBox(width: _height),
        ],
      ),
    );
  }
}
