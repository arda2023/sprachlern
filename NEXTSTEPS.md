# NEXTSTEPS – Supabase Auth, Custom-Stapel, englische Karten (PR #2)
## Erledigt
- Auth: `/login` + `/register` mit Ladezustand und Fehlertext, Redirect über `routerProvider` (GoRouter einmal gebaut, `ValueNotifier` als `refreshListenable` — Neubau würde den Navigations-Stack verwerfen), „Abmelden" meldet echt ab.
- Custom-Stapel liest/schreibt `custom_stacks` / `custom_stack_cards`, ein Stapel pro Nutzer.
- **Option (b) umgesetzt:** `CustomStackCard` = `targetWord` (englisches Lückenwort) + `englishSentence` + `germanSentence`. `GeminiSentenceService` ist fertig und aktiv: Wörter → lokaler deutscher Vorlagensatz → `generate-sentence`; Text → eingegebener Satz unverändert → `generate-sentence`. Ein Aufruf pro Eintrag, nacheinander; `gapWord` wird ohne Randsatzzeichen zum Zielwort und muss im englischen Satz vorkommen, sonst scheitert der ganze Batch (es wird nichts gespeichert).
- Kartenzeile dreizeilig wie 5.17: Zielwort `en-headword` Cyan/Serif, deutscher Satz `body-sm` muted, englischer Satz `en-line` Cyan/Serif. **design.md 6 entsprechend angepasst** (vorher: „kein Cyan/Serif, da deutscher Inhalt").
- `MockSentenceGenerationService` samt Längstes-Wort-Heuristik entfernt; die Vorlagensätze leben als `germanTemplateSentence()` weiter.
## Migration — vor dem Testen ausführen
- Datei: `supabase/migrations/20260926120000_add_english_sentence_to_custom_stack_cards.sql` (SQL-Editor oder `supabase db push`):
  `alter table public.custom_stack_cards add column english_sentence text not null default '';`
  `alter table public.custom_stack_cards alter column english_sentence drop default;`
- Optional, löscht Daten: Karten von vor der Migration haben ein deutsches `target_word` und keinen englischen Satz → `delete from public.custom_stack_cards where english_sentence = '';`
- Es gibt keine Basis-Migration für die Tabellen; `supabase db reset` lokal scheitert daher an dieser Datei.
## Testergebnis
- `flutter analyze`: No issues found. `flutter test`: 48/48.
- `custom_stack_test.dart`: läuft jetzt über den echten `GeminiSentenceService` mit gefakter Function (`test/helpers/fake_functions_client.dart`). Geändert: Wörter-Test prüft statt „deutscher Satz enthält Zielwort" die gesendeten Vorlagensätze, deutsches Eingabewort im deutschen Satz, englisches Zielwort im englischen Satz; Text-Test erwartet die Lückenwörter der Function (`doing`, `time`) statt der Heuristik (`machst`, `keine`); Persistenz-Test mit englischer Beispielkarte, prüft zusätzlich Cyan/Serif. Leerzustand-Test unverändert.
- Weiterhin: `widget_test.dart` läuft mit angemeldetem Fake, weil der Redirect die App ohne Session auf `/login` schickt.
- Neu: `gemini_sentence_service_test.dart` (3 Tests: Vorlagensatz + Mapping, Satzzeichen, unbrauchbare Antwort / Function-Fehler).
- Nichts gegen echtes Supabase/Gemini geprüft: die Sandbox blockiert `rojvuhvsnxeezzqrrcya.supabase.co`.
## Lokal gegen echtes Supabase zu prüfen
- Migration → Registrieren/Login → Wörter und Text hinzufügen → englischer Satz + Lückenwort plausibel → App-Neustart, Karten noch da.
- Ob die Function mit Login-Token aufgerufen werden darf (JWT-Prüfung) und ob `gemini-3.8-flash` antwortet; Fehler landen derzeit nur im Log.
## Offene Probleme
- „Hinzufügen" zeigt keinen Ladezustand und lässt sich während der (jetzt echten, langsamen) Gemini-Aufrufe erneut antippen → doppelte Karten möglich. Fehler erscheinen nicht in der UI. Beides betrifft `add_words_screen.dart` (nicht Teil dieses Auftrags).
- Batch-Inserts haben dasselbe `created_at`; `id` bricht den Gleichstand, bei UUIDs nicht in Einfügereihenfolge.
- Supabase-Fehlertexte kommen englisch; ein deutsches Mapping steht aus. CLAUDE.md (Tech-Stack) beschreibt Supabase und Edge Function noch als „nicht angebunden" — nicht geändert.
