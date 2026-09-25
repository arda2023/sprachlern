# NEXTSTEPS – Inkrement: Bottom-Navigation-Shell

## Erledigt
- `lib/main.dart` auf `MaterialApp.router` umgestellt, dunkles Theme mit AppColors-Tokens.
- `lib/router/app_router.dart` – `GoRouter` mit `StatefulShellRoute.indexedStack`, 5 Branches (/home, /content, /learn, /progress, /account).
- `lib/navigation/bottom_nav_shell.dart` – Vollständige Custom-Bottom-Nav per design.md §5.1.
- 5 Placeholder-Screens in `lib/screens/` (HomeScreen, ContentScreen, LearnScreen, ProgressScreen, AccountScreen).
- `test/widget_test.dart` – 2 Widget-Tests; prüfen alle 5 Nav-Slots und dass Tab-Taps `IndexedStack.index` korrekt wechseln.

## Geänderte Dateien
`lib/main.dart`, `lib/router/app_router.dart`, `lib/navigation/bottom_nav_shell.dart`,
`lib/screens/home_screen.dart`, `lib/screens/content_screen.dart`, `lib/screens/learn_screen.dart`,
`lib/screens/progress_screen.dart`, `lib/screens/account_screen.dart`, `test/widget_test.dart`, `pubspec.yaml`

## Testergebnis
`flutter analyze`: No issues found.
`flutter test`: 10/10 passed (inkl. vorhandene theme_tokens_tests). Google-Fonts-Warnungen pre-existing.

## Abweichungen
- **Icon-Paket**: `lucide_icons 0.257.0` wurde hinzugefügt, ist aber mit dem installierten Flutter SDK inkompatibel (`IconData` ist jetzt `final`, kann nicht mehr subgeclasst werden). Stattdessen werden Material-Icons-Outlined-Varianten verwendet (`Icons.home_outlined`, `Icons.grid_view_outlined`, `Icons.bar_chart_outlined`, `Icons.person_outlined`, `Icons.play_arrow`). `lucide_icons` bleibt in pubspec.yaml, wird aber nicht importiert. → Im nächsten Inkrement klären, ob das Paket entfernt oder ersetzt wird.
- **Lernen-Label**: Aus Layout-Gründen (Overflow) ist das Label für den Lernen-Button im Row-Mittelslot platziert; der Ring+Kreis darüber ist `IgnorePointer`, sodass Taps durchfallen. Optisch korrekt.
- UI im echten Simulator nicht getestet (kein Emulator verfügbar in dieser Session).

## Offene Punkte
- `lucide_icons` aus pubspec.yaml entfernen oder durch kompatibles Paket ersetzen.
- Progressring ist statisch (0 % = voller `--surface`-Ring); live-Anbindung folgt in späterem Inkrement.
- Badge-Punkt auf Konto-Icon ist statisch (immer sichtbar); Logik folgt später.
