import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/grammar_topic_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/grammar_topic_row.dart';
import 'package:sprachlern/widgets/tab_bar.dart';

/// "Grammatik" per design.md 6: tabs "Meine Übungen / Fertig" over a flat list
/// of rows directly on `--bg` (design.md 5.10).
class GrammarListScreen extends ConsumerStatefulWidget {
  const GrammarListScreen({super.key});

  @override
  ConsumerState<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends ConsumerState<GrammarListScreen> {
  static const _tabs = ['Meine Übungen', 'Fertig'];

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final showCompleted = _selectedTab == 1;
    final topics = ref
        .watch(grammarTopicsProvider)
        .where((topic) => topic.isCompleted == showCompleted)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _GrammarListTopBar(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/content');
                }
              },
            ),
            AppTabBar(
              keyPrefix: 'grammar_tab',
              labels: _tabs,
              selectedIndex: _selectedTab,
              onSelected: (index) => setState(() => _selectedTab = index),
            ),
            Expanded(
              child: topics.isEmpty
                  ? Center(
                      child: Text(
                        showCompleted
                            ? 'Noch keine Übung abgeschlossen.'
                            : 'Alle Übungen sind erledigt.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageMargin,
                        vertical: AppSpacing.s8,
                      ),
                      itemCount: topics.length,
                      separatorBuilder: (_, _) => const _RowDivider(),
                      itemBuilder: (context, index) => GrammarTopicRow(
                        topic: topics[index],
                        // Both tabs open the same exercise screen: reviewing a
                        // finished exercise is the natural action for "Fertig".
                        onTap: () => context.push('/grammar-exercise'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 1 px rule between list rows (design.md 3.4). The 16 px inset comes from the
/// list padding, so the rule spans the content width.
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

/// Top bar per design.md 5.2 with a back arrow and no trailing icon
/// ("oder keines").
class _GrammarListTopBar extends StatelessWidget {
  const _GrammarListTopBar({required this.onBack});

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
              constraints: const BoxConstraints.tightFor(
                width: _height,
                height: _height,
              ),
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
                'Grammatik',
                style: AppTextStyles.navTitle.copyWith(color: AppColors.white),
              ),
            ),
          ),
          // Balances the back arrow so the title stays centred.
          const SizedBox(width: _height),
        ],
      ),
    );
  }
}
