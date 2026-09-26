import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprachlern/models/settings_data.dart';

/// Rows in the order design.md 6 lists them for "Einstellungen".
const _initialRows = <SettingsRow>[
  SettingsValueEntry(
    key: 'theme',
    title: 'Motiv',
    currentValueLabel: 'Automatisch',
  ),
  SettingsToggleEntry(
    key: 'notifications',
    title: 'Benachrichtigungen',
    description: 'Erinnere mich daran, mein Tagesziel zu erreichen.',
    value: true,
  ),
  SettingsToggleEntry(
    key: 'muted',
    title: 'Ton aus',
    description: 'Spiele keine Aussprache und keine Klänge ab.',
    value: false,
  ),
  SettingsValueEntry(
    key: 'audioSpeed',
    title: 'Audiogeschwindigkeit',
    currentValueLabel: 'Normal',
  ),
  SettingsToggleEntry(
    key: 'speechInput',
    title: 'Spracheingabe',
    description: 'Erlaube das Mikrofon in der Übung.',
    value: false,
  ),
  SettingsToggleEntry(
    key: 'diacritics',
    title: 'Diakritische Zeichen',
    description: 'Zeige die Zusatzzeichen über der Tastatur an.',
    value: true,
  ),
  SettingsToggleEntry(
    key: settingsAutoAdvanceKey,
    title: 'Nächste Karte automatisch',
    description:
        'Gehe nach einer richtigen Antwort von selbst zur nächsten Karte.',
    value: false,
  ),
  SettingsNavEntry(
    key: 'grammarTables',
    title: 'Grammatiktabellen',
    route: '/grammar-topics',
  ),
];

class SettingsState {
  const SettingsState({required this.rows});

  final List<SettingsRow> rows;

  /// `false` for an unknown key, so callers need no null handling.
  bool isToggleOn(String key) {
    for (final row in rows) {
      if (row is SettingsToggleEntry && row.key == key) return row.value;
    }
    return false;
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState(rows: _initialRows);

  /// Flips the toggle with [key]. In-memory only: the state lives as long as
  /// the app session, there is no persistence layer yet.
  void toggle(String key) {
    state = SettingsState(
      rows: [
        for (final row in state.rows)
          if (row is SettingsToggleEntry && row.key == key)
            row.copyWith(value: !row.value)
          else
            row,
      ],
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
