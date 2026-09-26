# NEXTSTEPS – Einfaches Feedback in der Vokabel-Übung
## Erledigt
- Levenshtein-Alignment aus `DiffInputField` entfernt. Kein Vergleich beim Tippen; nach falscher Bestätigung 2-px-Rahmen `--error` + Teilhinweis rechts neben der Eingabe (`--error`, 40 %): 1. Fehlversuch zwei Zeichen + "..." (unter 3 Zeichen eins), ab dem 2. die ganze Lösung. Richtig: Rahmen `--success`, Feld gesperrt.
- Ein Button, drei Zustände: „Wort erfahren" (`--surface-2`) / „Eingeben" (weiße Pill) / grüner Häkchen-Kreis Ø 22 + „Weiter" (weiße Pill). Die Eingabetaste löst dieselbe Aktion aus.
- SM-2, höchstens ein Aufruf pro Karte: `false` beim ersten Fehlversuch **oder** beim Tippen auf „Wort erfahren" (nicht aus dem Gedächtnis abgerufen), sonst `true` bei „Weiter". Aufdecken zeigt die Lösung in `--cyan` 40 %, ohne Rot und ohne Hinweisstufe.
- Pro Karte `attemptCount`, `firstAttemptWasWrong`, `solutionRevealed` (+ `isWrong`/`isCorrect`), Reset bei jedem Kartenwechsel. Provider: `submitAnswer` speichert nur, `nextCard()` schaltet weiter; 700-ms-Timer und automatische Weiterschaltung entfernt.
- Eingabezeile sitzt direkt über der Tastatur: bleibt `bottomNavigationBar`, um die Tastaturhöhe angehoben. Im Body würde die Fehler-SnackBar den Button verdecken (vom Test „Speicherfehler" aufgedeckt).
- design.md 5.7: Zustände der Lücke und des Buttons ergänzt.
## Geänderte Dateien
- `lib/widgets/diff_input_field.dart`, `lib/widgets/exercise_input_bar.dart`, `lib/screens/exercise_screen.dart`, `lib/providers/exercise_provider.dart`, `lib/widgets/fill_in_card.dart`, `design.md`, `test/diff_input_field_test.dart`, `test/exercise_screen_test.dart`.
## Testergebnis
- `flutter analyze`: No issues found. Beide Testdateien mit `--concurrency=1`: +24 All tests passed (9 Feld-, 15 Screen-Tests; Fälle 1–8 als „Fall N" benannt). Gesamte Suite: 87/87.
- Gegenprobe: Jede absichtlich kaputt gemachte Regel (false/true-Aufrufe, Reset, Wertung beim Aufdecken, Tastatur-Anhebung) lässt den zugehörigen Test fehlschlagen.
- Nicht auf Gerät/Simulator geprüft; die Sandbox erreicht Supabase nicht.
## Abweichungen
- `submitAnswer(true)` erst bei „Weiter" (Akzeptanzkriterium); die Schrittbeschreibung sagte „jetzt" beim richtigen „Eingeben".
- „Wort erfahren" wertet jetzt `false` (Entscheidung nach der ersten Version; ursprünglich „kein Versuch, kein Aufruf").
- Rand und Hinweis verschwinden, sobald die Eingabe nach einem Fehlversuch geändert wird; der Zähler läuft weiter.
- Häkchen grün wie in IMG_7681; IMG_7679 zeigt Cyan, laut CLAUDE.md nur für englischen Inhalt. 40 % Deckkraft ist Transparenz (CLAUDE.md: nur Scrim) – auf ausdrücklichen Wunsch, in design.md 5.7 festgehalten.
## Offene Probleme
- Speicherfehler werden gemeldet, nicht wiederholt (höchstens ein Aufruf); die Karte bleibt dann serverseitig ungewertet.
- Erneutes „Eingeben" mit unverändertem falschem Text zählt als weiterer Fehlversuch und zeigt sofort die ganze Lösung.
