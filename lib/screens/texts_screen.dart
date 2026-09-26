import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/text_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/section_header.dart';
import 'package:sprachlern/widgets/text_cover_card.dart';
import 'package:sprachlern/widgets/text_preview_sheet.dart';

class TextsScreen extends ConsumerWidget {
  const TextsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final covers = ref.watch(textCoversProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.pageMargin,
                AppSpacing.s16,
                AppSpacing.pageMargin,
                AppSpacing.s8,
              ),
              child: SectionHeader('DEINE TEXTE'),
            ),
            SizedBox(
              height: TextCoverCard.height,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageMargin,
                ),
                itemCount: covers.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.s16),
                itemBuilder: (_, index) {
                  final cover = covers[index];
                  return TextCoverCard(
                    key: ValueKey('text_cover_${cover.id}'),
                    cover: cover,
                    onTap: () => showTextPreviewSheet(context, cover),
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
                'Texte',
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
