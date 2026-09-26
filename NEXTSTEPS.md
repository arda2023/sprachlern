# NEXTSTEPS – Supabase Auth + Custom-Stapel
## Erledigt
- `Supabase.initialize` in `main.dart` (supabase_flutter 2.17.2, keine Konflikte mit riverpod 3.4.3 / go_router 18.0.1). `/login` + `/register` mit Ladezustand und Fehlertext, Auth-Redirect, „Abmelden" meldet wirklich ab.
- Custom-Stapel liest/schreibt `custom_stacks` / `custom_stack_cards` (ein Stapel pro Nutzer, beim ersten Zugriff angelegt). Satzgenerierung bleibt der Mock.
## Geänderte / neue Dateien
- Neu: `config/supabase_config.dart`, `services/{supabase_client,auth_service,custom_stack_repository,gemini_sentence_service}.dart`, `providers/auth_provider.dart`, `screens/{login,register}_screen.dart`, `widgets/auth_form.dart`, `test/auth_flow_test.dart`, `test/helpers/fake_auth_service.dart`.
- Geändert: `main.dart`, `router/app_router.dart` (`appRouter` → `routerProvider`), `providers/custom_stack_provider.dart`, `screens/account_screen.dart`, `pubspec.yaml/.lock`, generierte Plugin-Registrants (linux/macos/windows).
## Testergebnis
- `flutter analyze`: No issues found. `flutter test`: 45/45 (38 vorher + 6 Auth + 1 Persistenz).
- Angepasst, Assertions unverändert: `custom_stack_test.dart` (Overrides für User-ID + In-Memory-Repository, sonst greift der Provider auf das uninitialisierte Supabase zu). **Nicht vorgesehen, aber zwingend:** `widget_test.dart` pumpt die ganze App ohne Session — die geforderte Umleitung schickt sie auf `/login` statt zur Bottom-Nav. Läuft jetzt mit angemeldetem Fake.
- Nicht gegen das echte Supabase getestet: der Publishable Key fehlt (s. u.).
## Entscheidungen
- **Redirect:** `routerProvider` baut den GoRouter einmal; ein `ValueNotifier<bool>` spiegelt `isAuthenticatedProvider` und ist `refreshListenable`. Den Router bei jedem Auth-Wechsel neu zu bauen würde den Navigations-Stack verwerfen. `isAuthenticated` = synchrone `currentSession != null`, bei jedem Auth-Event neu berechnet — sonst würde eine gespeicherte Session beim Start kurz auf `/login` umgeleitet, bevor das erste Stream-Event kommt.
- Ein Formular (`auth_form.dart`) für beide Screens. Feld-Deko aus `add_words_screen.dart` dupliziert (gesperrt), Primär-Button privat (es gibt kein geteiltes Widget).
- Custom-Stapel-State bleibt synchrones `CustomStack` und lädt im Hintergrund, weil beide gesperrten Screens ihn synchron lesen. Nach dem Insert werden die von der DB zurückgegebenen Zeilen angehängt (kein Refetch). Ein Nutzerwechsel lädt neu.
- `publishableKey:` statt `anonKey:` (in 2.17.2 deprecated). Registrierung ohne Session (E-Mail-Bestätigung an) zeigt einen Hinweis statt nichts.
## BLOCKED — Edge-Function-Contract (Schritt 9, Entscheidung nötig)
- `generate-sentence` übersetzt DE→EN und liefert `{englishSentence, gapWord}`; `CustomStackCard` speichert deutsches Zielwort + deutschen Satz. `GeminiSentenceService` wirft `UnimplementedError`, der Provider bleibt beim Mock.
- (a) Function-Contract ändern: deutscher Beispielsatz + deutsches Zielwort, wie der Mock. Kein Modell-/Schema-Umbau, deckt Wort- und Text-Eingabe ab.
- (b) Function behalten, Karte um `english_sentence` + `gap_word` erweitern (Migration + Modell). Passt zur Lückentext-Übung einer Englisch-App — die jetzigen Karten üben gar kein Englisch. Offen: Wort-Eingabe braucht zuerst einen deutschen Satz, die Function erwartet `germanSentence`.
- (c) Mischform: deutscher Satz bleibt Quelle, die Übersetzung kommt als Zusatzspalten dazu; Satz für Wort-Eingabe per zweitem Function-Modus.
## Offene Probleme
- **Publishable Key fehlt:** `supabase_config.dart` enthält einen Platzhalter; jeder Aufruf scheitert mit „Invalid API key".
- Schema nicht live geprüft (Spaltennamen laut Auftrag). Batch-Inserts haben dasselbe `created_at`; `id` bricht den Gleichstand, bei UUIDs aber nicht in Einfügereihenfolge → Positionsspalte.
- Lade-/Speicherfehler des Custom-Stapels erscheinen nur im Log, und vor dem Laden steht kurz der Leerzustand. Behebung: AsyncNotifier + Änderung der zwei gesperrten Screens.
- Supabase-Fehlertexte sind englisch („Invalid login credentials"); ein deutsches Mapping steht aus (design.md: deutsche UI).
- Veraltet, nicht geändert (gesperrt): CLAUDE.md „Flutter-Client-Anbindung noch nicht implementiert"; Kommentar „In-memory only" in `models/custom_stack_data.dart`.
