# NEXTSTEPS

## Erledigt
- Erster Versuch: ausschließlich cyan, ohne rote Zeichen oder Lösung.
- Nach Fehlbewertung: optimales Levenshtein-Alignment mit Einfügung, Löschung und Substitution.
- Exakte Eingabe und einzelne reine Einfügung: ausschließlich cyan, ohne Lösung.
- Leeres Feld zeigt in beiden Zuständen nur den Cursor.
- ExerciseScreen hält attemptFailed pro Karte; neue Karten starten mit false.

## Geänderte Dateien
- `lib/widgets/diff_input_field.dart`, `lib/widgets/fill_in_card.dart`, `lib/screens/exercise_screen.dart`
- `test/diff_input_field_test.dart`, `test/exercise_screen_test.dart`
- `NEXTSTEPS.md`

## Testergebnis
- `flutter analyze`: No issues found! (ran in 1.8s).
- Beide Testdateien mit --reporter expanded --concurrency=1: 00:02 +22: All tests passed!
- 15 Feldtests und 7 Screen-Tests; alle vier Akzeptanzfälle einzeln im Output sichtbar.
- Screen-Tests bestätigen Reset pro Karte und submitAnswer(false) trotz tolerierter Einfügung.

## Abweichungen und offene Probleme
- Schritt 6 erfordert zusätzlich FillInCard-/ExerciseScreen-Anpassungen und Screen-Tests.
- Bei Konflikten erscheint die volle Lösung gemäß Akzeptanzfall understandd; bei reinen Lücken der fehlende Teil.
- Bestehender Ablauf wechselt nach 700 ms und Speicherung auch bei falscher Antwort zur nächsten Karte.
- Es wurde kein zusätzlicher Wiederholungsablauf eingeführt; submit_answer und SM-2 bleiben unverändert.
