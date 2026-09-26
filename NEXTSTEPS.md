# NEXTSTEPS – Grammatik, Wissenszentrum, Konto, Einstellungen

## Erledigt
- Grammatik-Liste (`/grammar-list`, aus der Inhalte-Kachel „Grammatik"): Tabs „Meine Übungen / Fertig" filtern **eine** Mock-Liste über `isCompleted` (3 + 3 Zeilen), flache Zeilen auf `--bg` nach 5.10.
- Grammatikhinweise (`/grammar-topics`): Niveau-Tabs (2 Themen je Niveau, ohne Chevron) → helle Erklärungsseite als eigene Route `/grammar-topics/:id` (Tabelle 18/26, zweite Spalte ab 63 px, „Achtung!"-Box 1 px `--light-border`, ohne Radius).
- Wissenszentrum (`/knowledge-center`), Konto (Placeholder ersetzt), Einstellungen (`/settings`, 5 Toggles + „Motiv"/„Audiogeschwindigkeit" + „Grammatiktabellen").
- Interaktiv: Grammatik-Übung zyklet über 3 Mock-Karten. Bei richtiger Antwort und aktivem „Nächste Karte automatisch" nach 600 ms automatisch weiter, sonst Text-Link „Weiter" (5.12). Toggle-Zustände bleiben die Sitzung über erhalten.
- Fortschrittsbalken-Bug (Höhe 0) in `ExerciseTopBar` **und** `_GrammarExerciseTopBar` behoben (`heightFactor: 1` + feste Breite, wie in `text_exercise_screen.dart`).

## Geänderte / neue Dateien
- Neu: die 20 Dateien aus dem Auftrag, dazu `widgets/app_toggle.dart` (Extraktion, s. u.) und die 2 Testdateien.
- Geändert: `screens/account_screen.dart`, `screens/grammar_exercise_screen.dart`, `models/grammar_exercise_data.dart`, `providers/grammar_exercise_provider.dart`, `providers/content_provider.dart`, `router/app_router.dart`, `widgets/exercise_top_bar.dart`, `screens/stack_detail_screen.dart` (nur Toggle-Extraktion).
- Kein neues Package, keine Netzwerk-/Supabase-/API-Anbindung. Theme-Dateien unverändert — 1.5 war bereits vollständig in `app_colors.dart`.

## Testergebnis
- `flutter analyze`: No issues found. `flutter test`: 38/38 (29 vorher + 9 neu), keine bestehende Assertion angepasst.
- `GrammarExerciseState` wurde auf eine Kartenliste erweitert; der bestehende `grammar_exercise_screen_test.dart` bleibt unverändert grün, weil Auto-Weiter per Default **aus** ist.
- Visuell bei 375 px geprüft: Web-Build, Screenshots aus dem mitgelieferten Chromium, gegen die Referenzbilder gehalten. Dabei gefunden und behoben: abgeschnittene Konto-Titel und schwebende Chevrons (Flex-Fehler), „Abmelden" unter dem Lernen-Kreis, Sheet-Reihenfolge (Beschreibung vor der Wertzeile), Statistik-Zeile klemmte zweizeilige Labels.

## Entscheidungen
- **Wissenszentrum-Routing:** design.md 6 zählt die 7 ÜBUNGSAUFGABEN-Kacheln abschließend auf, keine passt. Daher als erste Zeile in der Konto-Liste (Meta-Hub) statt als neue Inhalte-Kachel.
- **Grammatikhinweise-Einstieg:** über die Einstellungs-Zeile „Grammatiktabellen" (design.md 6 nennt sie dort), sonst wäre der Screen unerreichbar. Im Screenshot ist das ein Toggle — bewusste Abweichung zugunsten der Erreichbarkeit.
- **Toggle:** extrahiert nach `app_toggle.dart` statt dupliziert. `test/stack_detail_revue_test.dart` prüft nur `recent_words_toggle`, der Key `stack_learn_toggle` bleibt erhalten.
- **Auto-Weiter:** 600 ms, Default **aus** (design.md nennt keinen Default; aus hält den Bestandstest ohne offenen Timer grün).
- **„Fertig"-Zeilen** öffnen dieselbe Übung — eine fertige Aufgabe nochmals anzusehen ist die naheliegende Aktion.
- **Illustration** ist ein flacher geometrischer Platzhalter (300 × 300, `--surface` + 3 Token-Balken); Screenshot-Grafiken dürfen nicht übernommen werden.
- **„Abmelden"** und die Rechts-Links sind inert (kein Backend). „Motiv" / „Audiogeschwindigkeit" sind Anzeige-Zeilen; das Picker-Sheet ist in design.md nicht spezifiziert → out of scope.

## Offene Probleme / Widersprüche (design.md war schreibgeschützt)
- **5.6 vs. `Mein_Wissen_Statistiken.PNG`:** Der Punkt „Bekannte Wörter" ist im Screenshot **lila**, design.md 5.6 sagt Cyan. Auftrag und design.md befolgt (Cyan). Vorschlag: 5.6 auf Lila korrigieren.
- **`IMG_7636.PNG` vs. Auftrag:** Dort ist „Lern-Benachrichtigungen" eine Chevron-Zeile und „Grammatiktabellen" ein Toggle; umgesetzt ist die Aufteilung aus dem Auftrag (5 Toggles).
- Englische Wörter in den „Achtung!"-Punkten werden nur ab dem ersten `": "` in Serif/`--light-en` gesetzt; inline eingestreute Wörter (Screenshot: „He und she werden …") erkennt die Heuristik nicht. Braucht ausgezeichnete Textsegmente im Modell.
- Tabs sind laut Auftrag gleich breit (`Expanded`); im Screenshot richtet sich die Breite nach dem Label.
- Im Screenshot-Vergleich brechen lange Wissenszentrum-Labels („Gesamtzahl zu lernender Wörter") auf zwei Zeilen um; die Zeile wächst dann über die 46 px aus 5.6 hinaus, statt zu kürzen.
- Die Screenshots liefen mit Roboto als Ersatz, weil `fonts.gstatic.com` aus dem Container nicht erreichbar ist. Layout, Abstände und Farben sind damit belegt, die Typografie (Figtree / Source Serif 4) **nicht**.
- Profilzeilen und die Wissenszentrum-Top-Bar haben im Screenshot Chevron bzw. „?"-Icon, design.md 6 nennt beides nicht → weggelassen.
