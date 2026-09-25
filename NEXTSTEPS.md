# NEXTSTEPS – Bottom-Nav Icons an Screenshot angepasst

## Erledigt
- Mitten-Icon im „Lernen"-Kreis: `FLucideIcons.circleArrowRight` -> `FLucideIcons.arrowRight` (einfacher Pfeil).
- „Fortschritte"-Icon: `FLucideIcons.barChart` -> `FLucideIcons.chartNoAxesColumn` (achsenlose Balken).
- Größen und Farben unverändert.

## Geänderte Dateien
- `lib/navigation/bottom_nav_shell.dart` (2 Zeilen)

## Testergebnis
- `flutter analyze`: No issues found.
- `flutter test`: 12/12 bestanden, Assertions unverändert.

## Abweichungen
- Keine. `arrowRight` existiert in forui_lucide 0.27.0, der `play`-Fallback war nicht nötig.

## Offene Probleme
- Nicht im Simulator/Browser gegen den Screenshot geprüft (nur Widget-Tests).
- Ring weiterhin statisch `--surface` (0 %); Tagesfortschritt-Bogen in `--lilac` fehlt noch.
- `FLocalizations`-Delegates noch nicht ergänzt (erst mit dem ersten `F*`-Widget nötig).
