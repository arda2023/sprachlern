import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/knowledge_center_data.dart';
import 'package:sprachlern/providers/knowledge_center_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/knowledge_stat_row.dart';

/// "Mein Wissenszentrum" per design.md 6: a large centred illustration over two
/// statistic cards (3 rows and 1 row, design.md 5.6). A tap on a row opens an
/// info sheet without a button (design.md 5.11).
class KnowledgeCenterScreen extends ConsumerWidget {
  const KnowledgeCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(knowledgeStatCardsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _KnowledgeTopBar(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/account');
                }
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.s16,
                  AppSpacing.pageMargin,
                  AppSpacing.s32,
                ),
                children: [
                  const Center(child: _IllustrationPlaceholder()),
                  const SizedBox(height: AppSpacing.s32),
                  for (var i = 0; i < cards.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: i == cards.length - 1 ? 0 : AppSpacing.s8,
                      ),
                      child: _StatCard(card: cards[i]),
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

/// Statistic row card per design.md 5.6: `--surface`, radius 8, rows separated
/// by a 1 px rule with an 8 px indent.
class _StatCard extends StatelessWidget {
  const _StatCard({required this.card});

  final KnowledgeStatCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.s8,
      ),
      child: Column(
        children: [
          for (var i = 0; i < card.entries.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8),
                child: ColoredBox(
                  // One step lighter than the card it sits on (design.md 1.6).
                  color: AppColors.surface2,
                  child: SizedBox(height: 1, width: double.infinity),
                ),
              ),
            KnowledgeStatRow(
              entry: card.entries[i],
              onTap: () => showKnowledgeStatSheet(context, card.entries[i]),
            ),
          ],
        ],
      ),
    );
  }
}

/// Placeholder for the ~300 px illustration design.md 6 asks for. The reference
/// artwork must not be reused (CLAUDE.md), so this is a flat geometric stand-in
/// built from existing tokens until a real asset exists.
class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder();

  static const double _size = 300.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Platzhalter für die Wissenszentrum-Illustration',
      image: true,
      child: Container(
        key: const ValueKey('knowledge_illustration'),
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Bar(width: 140, color: AppColors.cyanIcon),
              const SizedBox(height: AppSpacing.s12),
              _Bar(width: 200, color: AppColors.lilac),
              const SizedBox(height: AppSpacing.s12),
              _Bar(width: 100, color: AppColors.orange),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: AppSpacing.s24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
    );
  }
}

class _KnowledgeTopBar extends StatelessWidget {
  const _KnowledgeTopBar({required this.onBack});

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
              tooltip: 'Zurück zum Konto',
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
                'Mein Wissenszentrum',
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
