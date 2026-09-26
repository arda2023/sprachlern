# NEXTSTEPS

## Erledigt
- Migration `20260929000000_word_actions_columns.sql` ergänzt vier Wortaktionsspalten.
- Bestehende RLS-Policy und Authenticated-Grants gelten automatisch für die neuen Spalten.
- `WordListEntry` um ID und drei Aktionszustände erweitert.
- `WordListRepository` lädt nur Progress-Zeilen mit innerem `stack_words`-Join.
- Relative deutsche `lastSeen`-Texte werden am Repository-Rand formatiert.
- Wortliste nutzt `FutureProvider` mit Lade-, Fehler- und Leerzustand.
- `/progress` zeigt direkt `WordListScreen`; `ProgressScreen` bleibt ungenutzt erhalten.
- Bestehende Wortlistentests verwenden ein Fake-Repository; Leer- und Zwei-Wort-Fälle ergänzt.

## Geänderte Dateien
- `supabase/migrations/20260929000000_word_actions_columns.sql`
- `lib/models/word_list_data.dart`, `lib/services/word_list_repository.dart`
- `lib/providers/word_list_provider.dart`, `lib/screens/word_list_screen.dart`
- `lib/router/app_router.dart`, `test/texts_word_list_test.dart`

## Testergebnis
- `flutter analyze`: `No issues found! (ran in 2.3s)`.
- `flutter test test/texts_word_list_test.dart`: `00:01 +9: All tests passed!`.
- `flutter test`: `00:05 +109: All tests passed!`.

## Abweichungen und offene Probleme
- Migration nicht gegen eine Live-Supabase-Instanz ausgeführt.
