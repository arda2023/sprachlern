import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/models/settings_data.dart';
import 'package:sprachlern/providers/settings_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/settings_toggle_row.dart';
import 'package:sprachlern/widgets/settings_value_row.dart';

/// "Einstellungen" per design.md 6: the rows in the order design.md lists them,
/// toggles per 5.13 and chevron-value rows per 5.10.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(settingsProvider).rows;
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _SettingsTopBar(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/account');
                }
              },
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageMargin,
                  vertical: AppSpacing.s8,
                ),
                itemCount: rows.length,
                separatorBuilder: (_, _) => const _RowDivider(),
                itemBuilder: (context, index) {
                  final row = rows[index];
                  return switch (row) {
                    SettingsToggleEntry() => SettingsToggleRow(
                      entry: row,
                      onChanged: (_) => notifier.toggle(row.key),
                    ),
                    // "Motiv" and "Audiogeschwindigkeit" stay display-only:
                    // their picker sheet is not specified in design.md yet.
                    SettingsValueEntry() => SettingsValueRow(
                      rowKey: row.key,
                      title: row.title,
                      value: row.currentValueLabel,
                    ),
                    SettingsNavEntry() => SettingsValueRow(
                      rowKey: row.key,
                      title: row.title,
                      onTap: () => context.push(row.route),
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class _SettingsTopBar extends StatelessWidget {
  const _SettingsTopBar({required this.onBack});

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
                'Einstellungen',
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
