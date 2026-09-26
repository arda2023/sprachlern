import 'package:flutter/widgets.dart';

/// Profile row on the account screen: icon plus value (design.md 6, "Konto").
class AccountProfileEntry {
  const AccountProfileEntry({
    required this.icon,
    required this.value,
    required this.semanticLabel,
  });

  final IconData icon;

  /// Placeholder data only — never a real name or address.
  final String value;

  /// German label for the icon (design.md 8).
  final String semanticLabel;
}

/// Row of the account list (design.md 5.10, "Konto / Einstellungen" variant).
class AccountListEntry {
  const AccountListEntry({
    required this.id,
    required this.title,
    this.value,
    this.dotColor,
    this.route,
  });

  final String id;
  final String title;

  /// Optional muted value left of the chevron, e.g. "Testabo".
  final String? value;

  /// Optional status dot left of the value, e.g. `--error` for "Abonnement".
  final Color? dotColor;

  /// Target route, or `null` while the row has no screen yet.
  final String? route;
}

class AccountData {
  const AccountData({
    required this.profileEntries,
    required this.listEntries,
    required this.versionLabel,
  });

  final List<AccountProfileEntry> profileEntries;
  final List<AccountListEntry> listEntries;
  final String versionLabel;
}
