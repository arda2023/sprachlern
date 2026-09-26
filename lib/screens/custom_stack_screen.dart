import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/custom_stack_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/custom_stack_card_row.dart';

class CustomStackScreen extends ConsumerWidget {
  const CustomStackScreen({super.key});

  static const double _topBarHeight = 44.0;
  static const double _topBarIconSize = 24.0;

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/content');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stack = ref.watch(customStackProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: stack.name, onBack: () => _back(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageMargin,
                      AppSpacing.s16,
                      AppSpacing.s8,
                      AppSpacing.s8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Karten: ${stack.cards.length}',
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          key: const ValueKey('custom_stack_add'),
                          tooltip: 'Wörter hinzufügen',
                          onPressed: () => context.push('/custom-stack/add'),
                          icon: const Icon(
                            FLucideIcons.plus,
                            size: _topBarIconSize,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: stack.cards.isEmpty
                        ? const _EmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.pageMargin,
                              AppSpacing.s8,
                              AppSpacing.pageMargin,
                              AppSpacing.s24,
                            ),
                            itemCount: stack.cards.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.listGap),
                            itemBuilder: (_, index) =>
                                CustomStackCardRow(card: stack.cards[index]),
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

/// design.md 7: empty states are plain text, no illustration.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sheetMargin),
        child: Text(
          'Noch keine Karten. Füge Wörter hinzu, um zu starten.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const size = CustomStackScreen._topBarHeight;

    return SizedBox(
      height: size,
      child: Row(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: IconButton(
              tooltip: 'Zurück zu Inhalte',
              onPressed: onBack,
              padding: EdgeInsets.zero,
              icon: const Icon(
                FLucideIcons.arrowLeft,
                size: CustomStackScreen._topBarIconSize,
                color: AppColors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: AppTextStyles.navTitle.copyWith(color: AppColors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.pageMargin),
            child: Text(
              'Fertigstellen',
              style: AppTextStyles.title.copyWith(color: AppColors.lilac),
            ),
          ),
        ],
      ),
    );
  }
}
