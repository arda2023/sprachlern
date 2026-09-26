import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/providers/account_provider.dart';
import 'package:sprachlern/providers/auth_provider.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/theme/app_spacing.dart';
import 'package:sprachlern/theme/app_text_styles.dart';
import 'package:sprachlern/widgets/account_list_row.dart';
import 'package:sprachlern/widgets/account_profile_row.dart';

/// "Konto" per design.md 6: centred title, profile rows, the account list
/// (design.md 5.10), version plus legal links and an outline button "Abmelden".
///
/// As a main bottom-nav tab it carries no back arrow (design.md 5.2).
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static const double _topBarHeight = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: _topBarHeight,
              child: Center(
                child: Text(
                  'Konto',
                  style: AppTextStyles.navTitle.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageMargin,
                  AppSpacing.s16,
                  AppSpacing.pageMargin,
                  AppSpacing.s24,
                ),
                children: [
                  for (final entry in account.profileEntries)
                    AccountProfileRow(entry: entry),
                  const SizedBox(height: AppSpacing.s16),
                  for (var i = 0; i < account.listEntries.length; i++) ...[
                    if (i > 0) const _RowDivider(),
                    AccountListRow(
                      entry: account.listEntries[i],
                      onTap: () {
                        final route = account.listEntries[i].route;
                        if (route != null) context.push(route);
                      },
                    ),
                  ],
                  const _RowDivider(),
                ],
              ),
            ),
            // Version, links and "Abmelden" sit at the bottom of the screen.
            // The 40 px keep the button clear of the "Lernen" circle, which
            // overhangs the nav bar by about 35 px (design.md 5.1).
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageMargin,
                AppSpacing.s16,
                AppSpacing.pageMargin,
                AppSpacing.s40,
              ),
              child: Column(
                children: [
                  Text(
                    account.versionLabel,
                    key: const ValueKey('account_version'),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.meta.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  const _LegalLinks(),
                  const SizedBox(height: AppSpacing.s16),
                  const _SignOutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Legal links in `--blue-link` (design.md 1.2). Inert: there are no legal
/// pages in the app yet.
class _LegalLinks extends StatelessWidget {
  const _LegalLinks();

  static const _labels = ['Nutzungsbedingungen', 'Datenschutz', 'Impressum'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s8,
      children: [
        for (final label in _labels)
          Semantics(
            button: true,
            child: GestureDetector(
              key: ValueKey('account_legal_$label'),
              onTap: _doNothing,
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(color: AppColors.blueLink),
              ),
            ),
          ),
      ],
    );
  }
}

/// Outline button per design.md 5.12: 1.5 px white border, radius 12, 46 tall.
/// It only signs out; the router's auth redirect then shows /login.
class _SignOutButton extends ConsumerWidget {
  const _SignOutButton();

  static const double _height = 46.0;
  static const double _borderWidth = 1.5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: _height,
      child: OutlinedButton(
        key: const ValueKey('account_sign_out'),
        onPressed: () => ref.read(authServiceProvider).signOut(),
        style: OutlinedButton.styleFrom(
          // No backgroundColor: design.md 5.12 wants the outline button
          // transparent, which is OutlinedButton's default.
          side: const BorderSide(color: AppColors.white, width: _borderWidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
        child: Text(
          'Abmelden',
          style: AppTextStyles.title.copyWith(color: AppColors.white),
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

void _doNothing() {}
