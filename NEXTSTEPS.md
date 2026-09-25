# NEXTSTEPS – Vokabelübung

## Erledigt
- Übungs-Top-Bar, Lückentext, Übersetzungs-Karte, Grammatik-Sheet und Eingabezeile umgesetzt.
- Mock-Daten liegen im Riverpod-Provider; `/exercise` ist als eigenständige Route verfügbar.
- Widget-Test deckt leere und gefüllte Lücke sowie Öffnen/Schließen des Sheets ab.

## Geänderte Dateien
- `lib/models/exercise_data.dart`, `lib/providers/exercise_provider.dart`, `lib/screens/exercise_screen.dart`
- `lib/widgets/exercise_top_bar.dart`, `fill_in_card.dart`, `translation_card.dart`
- `lib/widgets/exercise_input_bar.dart`, `grammar_hint_sheet.dart`, `lib/router/app_router.dart`
- `test/exercise_screen_test.dart`, `NEXTSTEPS.md`

## Testergebnis
- `flutter analyze`: No issues found.
- `flutter test`: 13/13 bestanden.

## Abweichungen
- „Neues Wort" wird bei Status kleiner oder gleich 1 angezeigt.
- Wortübersetzungen öffnen als Tap-Tooltip; die Übersetzungs-Karte startet eingeklappt.
- Die Lücke füllt beim Tap direkt mit der Mock-Antwort; keine Antwortprüfung oder Tastatureingabe.

## Offene Probleme
- Keine bekannt.
