# NEXTSTEPS – Einfaches Feedback in der Vokabel-Übung
## Erledigt
- Levenshtein-Alignment aus `DiffInputField` entfernt. Kein Vergleich beim Tippen; nach falscher Bestätigung 2-px-Rahmen `--error` + Teilhinweis rechts neben der Eingabe (`--error`, 40 %): 1. Fehlversuch zwei Zeichen + "..." (unter 3 Zeichen eins), ab dem 2. die ganze Lösung. „Wort erfahren": Lösung in `--cyan` 40 % im leeren Feld, ohne Wertung, Feld bleibt leer. Richtig: Rahmen `--success`, Feld gesperrt.
- Ein Button, drei Zustände: „Wort erfahren" (`--surface-2`) / „Eingeben" (weiße Pill) / grüner Häkchen-Kreis Ø 22 + „Weiter" (weiße Pill). Die Eingabetaste löst dieselbe Aktion aus.
- Pro Karte `attemptCount`, `firstAttemptWasWrong`, `solutionRevealed` (+ `isWrong`/`isCorrect`), Reset bei jedem Kartenwechsel. `submitAnswer(false)` beim ersten Fehlversuch, `submitAnswer(true)` bei „Weiter" nur ohne vorherigen Fehlversuch → höchstens ein Aufruf pro Karte.
- Provider: `submitAnswer` speichert nur, `nextCard()` schaltet weiter; 700-ms-Timer und automatische Weiterschaltung entfernt, ebenso das ungenutzte `isSubmitting`/`submitError`.
- design.md 5.7: Zustände der Lücke und des Buttons ergänzt.
## Geänderte Dateien
- `lib/widgets/diff_input_field.dart`, `lib/widgets/exercise_input_bar.dart`, `lib/screens/exercise_screen.dart`, `lib/providers/exercise_provider.dart`, `lib/widgets/fill_in_card.dart`, `design.md`, `test/diff_input_field_test.dart`, `test/exercise_screen_test.dart`.
## Testergebnis
- `flutter analyze`: No issues found. Beide Testdateien mit `--concurrency=1`: +22 All tests passed (9 Feld-, 13 Screen-Tests; Fälle 1–8 als „Fall N" benannt). Gesamte Suite: 85/85.
- Gegenprobe: Mit „false bei jedem Fehlversuch", „true trotz Fehlversuch", „true schon bei Eingeben" oder ohne Reset schlagen Fall 4, 7, 6 bzw. 8 fehl.
- Nicht auf Gerät/Simulator geprüft; die Sandbox erreicht Supabase nicht.
## Abweichungen
- `submitAnswer(true)` erst bei „Weiter" (Akzeptanzkriterium); die Schrittbeschreibung sagte „jetzt" beim richtigen „Eingeben".
- Rand und Hinweis verschwinden, sobald die Eingabe nach einem Fehlversuch geändert wird („Nutzer tippt: normaler Rand, keine Lösung"); der Zähler läuft weiter.
- Häkchen als grüner Kreis neben der Pill wie in IMG_7681; IMG_7679 zeigt Cyan, laut CLAUDE.md nur für englischen Inhalt.
- 40 % Deckkraft ist Transparenz (CLAUDE.md: nur Scrim); auf ausdrücklichen Wunsch, in design.md 5.7 festgehalten. `fill_in_card.dart` zusätzlich geändert (reicht Parameter durch); `custom_stack_exercise_screen.dart` existiert auf `main` nicht.
## Offene Probleme
- Die Eingabezeile ist `bottomNavigationBar` und liegt bei offener Tastatur verdeckt (Probe: Button y 773–803, Tastatur ab 512); design.md 5.7 verlangt „direkt über der Tastatur". Bis dahin bestätigt die Eingabetaste und schließt die Tastatur.
- „Wort erfahren" und danach richtig getippt zählt als `true` (Reveal ist laut Vorgabe kein Versuch) – für SM-2 vermutlich zu gut; Entscheidung nötig.
- Speicherfehler werden gemeldet, nicht wiederholt (höchstens ein Aufruf); die Karte bleibt dann serverseitig ungewertet.
- Erneutes „Eingeben" mit unverändertem falschem Text zählt als weiterer Fehlversuch und zeigt sofort die ganze Lösung.
