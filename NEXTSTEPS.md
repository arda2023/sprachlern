# NEXTSTEPS – Custom-Stapel erstellen

## Erledigt
- `CustomStack` / `CustomStackCard` (in-memory), `SentenceGenerationService` (abstrakt) + `MockSentenceGenerationService`.
- `customStackProvider` (NotifierProvider) mit `addFromWords` / `addFromText`; Service über eigenen `sentenceGenerationServiceProvider` injiziert, damit die LLM-Implementierung später ohne Caller-Änderung getauscht werden kann.
- `CustomStackScreen` (Top-Bar, „Karten: N", +-Button, Kartenliste, Leerzustand ohne Grafik gemäß design.md 7).
- `AddWordsScreen` (✕, Titel, „Hinzufügen" als Text-Link, Modus-Umschalter, mehrzeiliges Textfeld) und `InputModeToggle`.
- Routen `/custom-stack` und `/custom-stack/add`; Kachel „Eigene Stapel" verdrahtet.
- 3 Widget-Tests: Leerzustand/deaktivierter Button, Wörter-Modus, Text-Modus.

## Geänderte / neue Dateien
- Neu: `lib/models/custom_stack_data.dart`, `lib/services/sentence_generation_service.dart`, `lib/providers/custom_stack_provider.dart`, `lib/screens/{custom_stack_screen,add_words_screen}.dart`, `lib/widgets/{custom_stack_card_row,input_mode_toggle}.dart`, `test/custom_stack_test.dart`
- Geändert: `lib/router/app_router.dart`, `lib/screens/content_screen.dart`

## Testergebnis
- `flutter analyze`: No issues found.
- `flutter test`: 22/22 bestanden (19 vorher + 3 neue), keine bestehende Assertion angepasst.

## Abweichungen / Annahmen
- **Zielwort-Heuristik (Text-Modus)**: längstes Wort des Satzes, bei Gleichstand das erste; führende/schließende Satzzeichen werden beim Messen ignoriert. Beispiel: „Was machst du gerade?" → `machst`, „Ich habe keine Zeit." → `keine`. Bewusster Platzhalter, den später die LLM-Auswahl ersetzt.
- **Route für „Eigene Stapel" liegt im Screen**, nicht im Provider: `content_provider.dart` stand auf „Nicht anfassen". `ContentScreen._fallbackRoutes` ist als Übergang markiert und gehört später in den Provider.
- **`InputModeToggle` ist ein neues Muster** (design.md kennt keinen Segmented Control): Farben aus 5.14 (aktiv Weiß, inaktiv `--text-muted`), Radius aus 3.3 (Pill), Track folgt der Flächenleiter (`--surface` auf `--bg`, gewähltes Segment `--surface-2`). Sollte bei Gelegenheit in design.md 5 nachgetragen werden.
- Karten-IDs erzeugt der Mock-Service über einen Instanzzähler (`card-0`, `card-1`, …) — ausreichend für In-Memory, nicht kollisionssicher über Sessions.
- Zusatzhinweis „Trenne mehrere Einträge mit einem Semikolon." unter dem Feld ergänzt, da das Trennzeichen sonst nirgends sichtbar ist.

## Offene Probleme
- „Fertigstellen" ist inert (nur visuell), Stapelname ist fix „Custom-Stapel" und nicht editierbar.
- Keine Persistenz: der Stapel geht beim Neustart verloren. Keine echte Übersetzung — die englische Seite der Karten fehlt noch vollständig.
- Keine visuelle Prüfung im Simulator oder Browser.
