import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/assets.dart';
import 'package:sprachlern/models/account_data.dart';
import 'package:sprachlern/theme/app_colors.dart';

/// Mock account data. All values are placeholders — no real name or address
/// from the reference screenshots ever enters the code (CLAUDE.md, privacy).
const _mockAccount = AccountData(
  profileEntries: [
    AccountProfileEntry(
      icon: FLucideIcons.user,
      value: 'nutzer@beispiel.de',
      semanticLabel: 'Angemeldetes Konto',
    ),
    AccountProfileEntry(
      icon: FLucideIcons.languages,
      value: 'Englisch aus dem Deutschen',
      semanticLabel: 'Lernsprache',
    ),
  ],
  listEntries: [
    // Not in design.md 6's Konto list; see NEXTSTEPS.md for why the knowledge
    // centre is reached from here rather than from an Inhalte tile.
    AccountListEntry(
      id: 'knowledge-center',
      title: 'Mein Wissenszentrum',
      route: '/knowledge-center',
    ),
    AccountListEntry(
      id: 'account-settings',
      title: 'Kontoeinstellungen',
      route: '/settings',
    ),
    AccountListEntry(
      id: 'subscription',
      title: 'Abonnement',
      value: 'Testabo',
      dotColor: AppColors.error,
    ),
    AccountListEntry(id: 'help', title: 'Hilfe'),
    AccountListEntry(id: 'rate-app', title: 'App bewerten'),
  ],
  versionLabel: 'Version 1.0.0 (1)',
);

final accountProvider = Provider<AccountData>((ref) => _mockAccount);
