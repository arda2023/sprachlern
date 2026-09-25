import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/content_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/section_header.dart';
import 'package:sprachlern/widgets/stack_list_item.dart';

class StackListScreen extends ConsumerWidget {
  const StackListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stacks = ref.watch(stackListProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _StackListTopBar(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/content');
                }
              },
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.s16,
                  AppSpacing.pageMargin,
                  AppSpacing.s24,
                ),
                itemCount: stacks.length + 1,
                separatorBuilder: (_, index) => SizedBox(
                  height: index == 0 ? AppSpacing.s8 : AppSpacing.listGap,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SectionHeader('DEINE STAPEL');
                  }
                  return StackListItem(stack: stacks[index - 1]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StackListTopBar extends StatelessWidget {
  const _StackListTopBar({required this.onBack});

  final VoidCallback onBack;

  static const _height = 44.0;
  static const _iconSize = 24.0;

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
                'Stapel',
                style: AppTextStyles.navTitle.copyWith(color: AppColors.white),
              ),
            ),
          ),
          SizedBox(
            width: _height,
            height: _height,
            child: IconButton(
              tooltip: 'Hilfe zu Stapeln',
              onPressed: _doNothing,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: _height,
                height: _height,
              ),
              icon: const Icon(
                FLucideIcons.circleHelp,
                size: _iconSize,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _doNothing() {}
