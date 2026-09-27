# NEXTSTEPS

## Erledigt
- `setFavorite` und `fetchFavorites` persistieren bzw. laden Favoriten über RLS.
- Herz-Tap toggelt `is_favorite`, invalidiert beide Wortlisten und färbt aktiv lilac.
- Stapelliste zeigt `Favoriten` nur bei mindestens einem aktiven Favoriten.
- Der synthetische Eintrag navigiert zu `/favorites/exercise`.
- Neuer Favorites-Screen nutzt lokale FillInCard-/DiffInputField-Logik ohne RPC/SM-2.
- Favoriten werden nacheinander geprüft; Übersetzung und Leerzustand sind enthalten.
- Tests decken Toggle, leere Liste, Stapel-Navigation und lokale Übung ab.

## Geänderte Dateien
- Repository/Provider, Wortlisten-Screen/-Row, StackListScreen, Router
- `lib/screens/favorites_exercise_screen.dart`, `test/favorites_exercise_screen_test.dart`
- `test/texts_word_list_test.dart`

## Testergebnis
- `flutter analyze`: `No issues found! (ran in 1.9s)`.
- `flutter test test/texts_word_list_test.dart test/favorites_exercise_screen_test.dart`: `All tests passed!`.
- `flutter test`: `00:05 +116: All tests passed!`.

## Abweichungen und offene Probleme
- Favoritenübung endet nach dem letzten Wort mit Navigation zu `/stacks`.
- SQL-Migration nicht gegen eine Live-Supabase-Instanz ausgeführt.
