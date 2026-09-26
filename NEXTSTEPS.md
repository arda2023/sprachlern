# NEXTSTEPS

## Erledigt
- Nach jeder Auswahl ersetzt die als korrekt markierte Option das erste `___` im Satz.
- Falsche Antworten behalten ihr rotes Feedback, während der Satz die richtige Lösung zeigt.
- Der vorhandene Text-Link „Weiter“ erscheint nach richtiger und falscher Auswahl.
- `nextCard` wechselt zyklisch zur nächsten Karte und löscht die Auswahl, wodurch Optionen wieder reagieren.
- Zwei Regressionstests ergänzen falsche Auswahl/korrekte Lösung und den Weiter-Fluss samt Entsperren.

## Geänderte Dateien
- `lib/screens/grammar_exercise_screen.dart`
- `lib/providers/grammar_exercise_provider.dart` (Kommentar zum bestehenden Weiter-/Auto-Weiter-Fluss)
- `test/grammar_exercise_screen_test.dart`
- `test/grammar_screens_test.dart` (bestehende Erwartungen an neue Satz-/Weiter-Anzeige angepasst)
## Testergebnis, Abweichungen, offene Probleme
- `flutter analyze`: No issues found! (ran in 1.8s)
- `flutter test`: 00:03 +61: All tests passed!
- Die vorhandenen drei Mock-Karten und der Text-Link nach design.md 5.12 wurden wiederverwendet; keine neue Datenstruktur oder UI-Komponente nötig.
- `grammar_answer_option.dart` blieb unverändert, da der Auswahl-Guard laut vorigem Increment ausschließlich im Notifier liegt.
- Bekannte `google_fonts`-Asset-Hinweise erscheinen auf stderr; die Suite endet erfolgreich mit Exit-Code 0. Offene Probleme: keine.
