import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/providers/content_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/app_toggle.dart';
import 'package:sprachlern/widgets/recent_words_card.dart';
import 'package:sprachlern/widgets/section_header.dart';
import 'package:sprachlern/widgets/difficulty_indicator.dart';

class StackDetailScreen extends ConsumerWidget {
  const StackDetailScreen({super.key, required this.stackId});

  final String stackId;

  static const double _topBarHeight = 44.0;
  static const double _topBarIconSize = 24.0;
  static const double _stackIconSize = 33.0;
  static const double _primaryButtonHeight = 46.0;
  static const double _outlineButtonHeight = 46.0;
  static const double _outlineBorderWidth = 1.5;

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/stacks');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(stackDetailsProvider(stackId));

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onBack: () => _back(context)),
            Expanded(
              child: detail.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.lilac),
                ),
                error: (_, _) => Center(
                  child: Text(
                    'Stapel konnte nicht geladen werden.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                data: (detail) => detail == null
                    ? const _MissingStack()
                    : _StackDetailBody(detail: detail),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissingStack extends StatelessWidget {
  const _MissingStack();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dieser Stapel ist nicht verfügbar.',
        style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}

class _StackDetailBody extends StatelessWidget {
  const _StackDetailBody({required this.detail});

  final StackDetailData detail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageMargin,
        AppSpacing.s16,
        AppSpacing.pageMargin,
        AppSpacing.s32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              detail.stack.icon,
              size: StackDetailScreen._stackIconSize,
              color: AppColors.periwinkle,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            detail.stack.title,
            style: AppTextStyles.display.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            detail.description,
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.s24),
          // Global catalog counts are not per-user progress.
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  detail.difficultyLabel,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                DifficultyIndicator(level: detail.stack.difficultyLevel),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const _LearnToggleCard(),
          const SizedBox(height: AppSpacing.s16),
          _PrimaryButton(
            label: 'Lerne mit diesem Stapel',
            onPressed: () => context.push('/stacks/${detail.stack.id}/exercise'),
          ),
          const SizedBox(height: AppSpacing.s24),
          RecentWordsCard(entries: detail.recentWords),
          const SizedBox(height: AppSpacing.sectionGap),
          const SectionHeader('MEHR DAVON'),
          const SizedBox(height: AppSpacing.s8),
          _OutlineButton(
            label: 'Diesen Stapel durchsehen',
            onPressed: () => context.push('/stack-revue'),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const size = StackDetailScreen._topBarHeight;

    return SizedBox(
      height: size,
      child: Row(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: IconButton(
              tooltip: 'Zurück zur Stapelliste',
              onPressed: onBack,
              padding: EdgeInsets.zero,
              icon: const Icon(
                FLucideIcons.arrowLeft,
                size: StackDetailScreen._topBarIconSize,
                color: AppColors.white,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: size,
            height: size,
            child: IconButton(
              tooltip: 'Stapel teilen',
              onPressed: null,
              padding: EdgeInsets.zero,
              icon: const Icon(
                FLucideIcons.share2,
                size: StackDetailScreen._topBarIconSize,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Toggle-Karte "Stapel lernen" (design.md 5.13). Local state only — there is
/// no persistence layer in this increment.
class _LearnToggleCard extends StatefulWidget {
  const _LearnToggleCard();

  @override
  State<_LearnToggleCard> createState() => _LearnToggleCardState();
}

class _LearnToggleCardState extends State<_LearnToggleCard> {
  bool _isOn = true;

  static const double _cardHeight = 58.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Stapel lernen',
              style: AppTextStyles.title.copyWith(color: AppColors.white),
            ),
          ),
          AppToggle(
            key: const ValueKey('stack_learn_toggle'),
            value: _isOn,
            onChanged: (value) => setState(() => _isOn = value),
            semanticLabel: 'Stapel lernen',
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StackDetailScreen._primaryButtonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textOnLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.title.copyWith(color: AppColors.textOnLight),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StackDetailScreen._outlineButtonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          side: const BorderSide(
            color: AppColors.white,
            width: StackDetailScreen._outlineBorderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.title.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
