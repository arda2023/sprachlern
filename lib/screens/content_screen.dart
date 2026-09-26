import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/content_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/content_tile.dart';
import 'package:sprachlern/widgets/section_header.dart';

class ContentScreen extends ConsumerWidget {
  const ContentScreen({super.key});

  /// Routes for tiles whose target lives outside the content provider's own
  /// data. Belongs in `content_provider.dart` once that file is in scope again.
  static const _fallbackRoutes = {'Eigene Stapel': '/custom-stack'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = ref.watch(contentSectionsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageMargin,
            AppSpacing.s16,
            AppSpacing.pageMargin,
            AppSpacing.s24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inhalte',
                style: AppTextStyles.display.copyWith(color: AppColors.text),
              ),
              const SizedBox(height: AppSpacing.s24),
              ...sections.expand(
                (section) => [
                  SectionHeader(section.title),
                  const SizedBox(height: AppSpacing.s8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: section.tiles.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.s16,
                          mainAxisSpacing: AppSpacing.s16,
                          mainAxisExtent: 100,
                        ),
                    itemBuilder: (context, index) {
                      final tile = section.tiles[index];
                      final route =
                          tile.route ?? _fallbackRoutes[tile.label];
                      return ContentTile(
                        tile: tile,
                        onTap: route == null ? null : () => context.go(route),
                      );
                    },
                  ),
                  if (section != sections.last)
                    const SizedBox(height: AppSpacing.s32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
