/// A row of the settings screen. design.md 6 lists the rows of "Einstellungen"
/// in a fixed order that mixes toggles, value rows and one navigation row, so
/// the provider keeps them in a single ordered list.
sealed class SettingsRow {
  const SettingsRow({required this.key, required this.title});

  /// Stable identifier, e.g. `autoAdvance`.
  final String key;

  final String title;
}

/// Toggle row (design.md 5.13): title left, toggle right, description below.
final class SettingsToggleEntry extends SettingsRow {
  const SettingsToggleEntry({
    required super.key,
    required super.title,
    required this.description,
    required this.value,
  });

  final String description;
  final bool value;

  SettingsToggleEntry copyWith({bool? value}) => SettingsToggleEntry(
    key: key,
    title: title,
    description: description,
    value: value ?? this.value,
  );
}

/// Chevron row with a muted value (design.md 5.10, "Konto / Einstellungen"
/// variant), e.g. "Motiv" → "Automatisch".
final class SettingsValueEntry extends SettingsRow {
  const SettingsValueEntry({
    required super.key,
    required super.title,
    required this.currentValueLabel,
  });

  final String currentValueLabel;
}

/// Chevron row without a value that opens another screen, e.g.
/// "Grammatiktabellen".
final class SettingsNavEntry extends SettingsRow {
  const SettingsNavEntry({
    required super.key,
    required super.title,
    required this.route,
  });

  final String route;
}

/// Key of the toggle that design.md 7 ties to the exercise flow
/// ("danach wahlweise automatisch weiter").
const String settingsAutoAdvanceKey = 'autoAdvance';
