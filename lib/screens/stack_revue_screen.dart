import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/content_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/revue_stack_row.dart';

class StackRevueScreen extends ConsumerStatefulWidget {
  const StackRevueScreen({super.key});

  @override
  ConsumerState<StackRevueScreen> createState() => _StackRevueScreenState();
}

class _StackRevueScreenState extends ConsumerState<StackRevueScreen> {
  bool _infoVisible = true;

  static const double _topBarHeight = 44.0;
  static const double _topBarIconSize = 24.0;

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/content');
    }
  }

  @override
  Widget build(BuildContext context) {
    final stacks = ref.watch(stackListProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onBack: _back),
            Expanded(
              child: stacks.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.lilac),
                ),
                error: (_, _) => Center(
                  child: Text(
                    'Stapel konnten nicht geladen werden.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                data: (stacks) => ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageMargin,
                    AppSpacing.s16,
                    AppSpacing.pageMargin,
                    AppSpacing.s24,
                  ),
                  itemCount: stacks.length + 1,
                  separatorBuilder: (_, index) => index == 0
                      ? const SizedBox(height: AppSpacing.s8)
                      : const ColoredBox(
                          color: AppColors.surface,
                          child: SizedBox(height: 1, width: double.infinity),
                        ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _infoVisible
                          ? _InfoCard(
                              onDismiss: () =>
                                  setState(() => _infoVisible = false),
                            )
                          : const SizedBox.shrink();
                    }
                    return RevueStackRow(
                      stack: stacks[index - 1],
                      onPlay: () => context.push(
                        '/stacks/${stacks[index - 1].id}/exercise',
                      ),
                    );
                  },
                ),
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

  @override
  Widget build(BuildContext context) {
    const size = _StackRevueScreenState._topBarHeight;

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
                size: _StackRevueScreenState._topBarIconSize,
                color: AppColors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Stapel-Revue',
                style: AppTextStyles.navTitle.copyWith(color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(width: size),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.onDismiss});

  final VoidCallback onDismiss;

  static const double _closeSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('revue_info_card'),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stapelinhalte wiederholen',
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'Sieh dir Wörter aus deinen Stapeln so oft an, wie du '
                  'möchtest. Die Revue zeigt keine neuen Wörter und verändert '
                  'deinen Lernfortschritt nicht.',
                  style: AppTextStyles.body.copyWith(color: AppColors.text),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          IconButton(
            key: const ValueKey('revue_info_dismiss'),
            tooltip: 'Hinweis schließen',
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: _closeSize,
              height: _closeSize,
            ),
            icon: const Icon(
              FLucideIcons.x,
              size: _closeSize,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
