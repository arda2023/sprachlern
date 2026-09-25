import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/providers/home_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/utils/german_number.dart';
import 'package:sprachlern/widgets/activity_card.dart';
import 'package:sprachlern/widgets/compact_stat_card.dart';
import 'package:sprachlern/widgets/goal_card.dart';
import 'package:sprachlern/widgets/home_header.dart';
import 'package:sprachlern/widgets/progress_stat_card.dart';
import 'package:sprachlern/widgets/promo_card.dart';
import 'package:sprachlern/widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Widget _margin(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
        child: child,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // Clears the protruding "Lernen" ring of the bottom nav.
          padding: const EdgeInsets.only(bottom: AppSpacing.s40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _margin(const HomeHeader()),
              const SizedBox(height: AppSpacing.s16),
              _margin(GoalCard(goal: data.goal)),
              const SizedBox(height: AppSpacing.s24),
              PromoCarousel(promos: data.promos),
              const SizedBox(height: AppSpacing.sectionGap),
              _margin(const SectionHeader('Meine Fortschritte')),
              const SizedBox(height: AppSpacing.s8),
              _margin(ProgressStatCard(stats: data.stats)),
              const SizedBox(height: AppSpacing.s16),
              _margin(
                Row(
                  children: [
                    Expanded(
                      child: CompactStatCard(
                        icon: Icons.bar_chart_outlined,
                        iconColor: AppColors.cyan,
                        value: formatGermanInt(data.stats.totalWords),
                        label: 'Gesamtzahl der Wörter',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s16),
                    Expanded(
                      child: CompactStatCard(
                        icon: Icons.grid_view_outlined,
                        iconColor: AppColors.orange,
                        value: formatGermanInt(data.stats.availableReviews),
                        label: 'Verfügbare Wiederholungen',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _margin(const SectionHeader('Derzeitige Lernaktivität')),
              const SizedBox(height: AppSpacing.s8),
              for (final entry in data.activities)
                _margin(
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.listGap),
                    child: ActivityCard(entry: entry),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
