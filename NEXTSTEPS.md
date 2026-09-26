# NEXTSTEPS – Texte, Text-Übung, Wortlisten
## Erledigt
- Texte: Cover-Karussell (4 Texte, beide Paletten) → Vorschau-Sheet mit 2 Übungszeilen → Text-Übung (Inline-Lücken 128×28 als echte `TextField`s, Tastatur-Zusatzleiste; „Antwort anzeigen" füllt die zuletzt fokussierte, sonst die erste offene Lücke).
- Wortlisten: Suche (Teilstring, ohne Groß/Klein), Teal-Pill, A–Z-Leiste (nur vorhandene Buchstaben, Sprung per GlobalKey), Wort-Info-Sheet mit Notiz-Zähler „N / 1000" (Notiz nicht persistiert).
- Kacheln „Texte" → `/texts`, „Vokabeln" → `/word-list`: Wortlisten ist der nächstliegende Ersatz für „Vokabeln durchsehen", bis ein eigener Vokabeln-Lernfluss existiert.
## Geänderte / neue Dateien
- Neu: die 12 Dateien aus dem Auftrag, dazu `widgets/round_play_button.dart` und `widgets/search_field.dart` (je eine Komponente nach CLAUDE.md) und `test/texts_word_list_test.dart`.
- Geändert: `router/app_router.dart`, `providers/content_provider.dart`, `widgets/revue_stack_row.dart` (nutzt `RoundPlayButton`, Verhalten unverändert).
## Testergebnis
- `flutter analyze`: No issues found. `flutter test`: 29/29 (22 vorher + 7 neu, keine bestehende Assertion angepasst).
- Zusätzlich auf Android-Emulator bei 375×812 dp mit Referenz-Screenshots verglichen. Bildschirmtastatur ließ sich dort nicht einblenden: „Leiste über Tastatur" nur per Test mit simulierten `viewInsets` geprüft.
## Abweichungen / Annahmen
- **Offen:** `#252938` (Dark-Cover) ist kein Token → `--surface` (#2C3143) als nächster, Streifen `--surface-3`. Vorschlag: `--cover-dark` in design.md 1.1 ergänzen. Cover-Geometrie ist eigener Entwurf.
- **Offen:** Cover-Badge nennt in 5.15 nur „halbtransparent": dark `--surface-3`, purple `--purple`, je 80 % Deckkraft (Weiß auf `--lilac-soft` wäre unlesbar).
- design.md widerspricht sich bzw. dem Screenshot (design.md war schreibgeschützt, nicht korrigiert): Sheet-Badge 5.11 `--surface-2` vs 5.15 `--surface` (Screenshot: `--surface`, verwendet); Info-Sheet-Trenner 3.4 „weiß" vs Screenshot `--surface-2` (verwendet); Kopf 5.8 (✕/Titel mittig/Glühbirne) vs Screenshot (←/Titel links über Balken/⋮) → 5.8 befolgt; Beschreibung im Vorschau-Sheet über statt unter den Zeilen (5.11).
- Lücken-Cursor `--blue-link` (5.8: „blauer System-Cursor", einziger Blau-Token). Lesetext `read` (Sans/Weiß) statt Serif/Cyan nach 5.8. Zähler ohne Tausenderpunkt wie in design.md.
- Beide Übungszeilen öffnen denselben Mock-Text; Fortschrittsbalken statisch aus `currentCard/totalCards`. Zeilen-Kachel im Sheet für beide `--surface-3` (Screenshot: zweite teal, kein Token).
- Nicht gebaut (nicht verlangt): Quadrat-Button am Suchfeld (5.16), Filter-Icon (Wortlisten), „+" und „Alle anzeigen" (Texte). Top-Bars bleiben pro Screen privat wie bei den 4 bestehenden; gemeinsame Extraktion ist nur sinnvoll, wenn `grammar_exercise_screen.dart` angefasst werden darf.
## Offene Probleme
- Bestehender Bug, nicht angefasst: Die lila Fortschrittsfüllung in `ExerciseTopBar` und `_GrammarExerciseTopBar` hat Höhe 0 (Test-Probe: Rect 28→28 bzw. 44→44), im Grammatik-Screen zusätzlich mittig. Fix wie in `text_exercise_screen.dart`: `heightFactor: 1` und `SizedBox(width: double.infinity)`.
- A–Z-Sprung baut die ganze Liste ohne Lazy-Loading (für Mock ok, für echte Wortzahlen ersetzen). Übersetzen/Wechseln/Tipp/Aktions-Icons inert, keine Persistenz.
