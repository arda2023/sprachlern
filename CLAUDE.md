# CLAUDE.md – Richtlinien für dieses Projekt

## Projekt

Klon einer Englisch-Lern-App für **deutsche Muttersprachler** (Vokabel-Karteikarten mit Lückentext, Grammatik-Übungen, Texte, Statistiken). Die Vorlage sind die Screenshots in `./Screenshots/`. Die gesamte visuelle Spezifikation steht in **`design.md`**.

Der Tech-Stack ist noch **nicht festgelegt**. Vor dem ersten Code kurz mit dem Nutzer abstimmen, welcher Stack verwendet wird (z. B. Web-App/PWA mit React oder Flutter/React Native), und die Entscheidung hier unter "Tech-Stack" eintragen.

## Oberste Regel: design.md ist verbindlich

**Jede Code-Generierung, die UI betrifft, muss sich strikt an `design.md` halten.** Vor jeder UI-Änderung die relevanten Abschnitte in `design.md` lesen. Bei Abweichung gewinnt `design.md`, nicht die Gewohnheit oder ein Framework-Default.

### Farben
- Es dürfen **nur** die Farb-Tokens aus `design.md` (Abschnitt 1) verwendet werden. Sie sind einmal zentral zu definieren (CSS-Variablen bzw. Theme-Datei, Vorlage in 1.6) und ausschließlich darüber zu referenzieren.
- **Keine Hex-, RGB- oder Framework-Farben** direkt in Komponenten (kein `#fff`, `white`, `gray-500`, `bg-slate-800` usw.).
- Neue Farbe nötig? Nicht selbst erfinden. Stattdessen nachfragen und zuerst `design.md` ergänzen, danach den Token verwenden.
- Rollen einhalten: Cyan nur für englischen Inhalt und Cyan-Fortschritt, Lila `--lilac` als einzige Interaktionsfarbe, Weiß für Primär-Buttons, Orange nur für "Neues Wort"-Status, Grün/Rot nur für Erfolg/Fehler.
- Fortschrittsbalken-Track immer eine Stufe heller als der Untergrund (`--surface` auf `--bg`, `--surface-2` auf `--surface`).
- **Dark-first**: Dunkles Theme ist Standard. Das helle Theme existiert nur für die Grammatik-Erklärungsseite (Abschnitt 9).
- Keine Verläufe, keine Schatten, kein Blur, keine Transparenz außer dem `--scrim`.

### Komponenten
- Für alles, was in `design.md` Abschnitt 5 beschrieben ist (Bottom-Navigation, Lückentext-Karte, Stat-Karten, Listenzeilen, Bottom Sheet, Buttons, Toggle, Tabs, Cover-Karte, Suchfeld usw.), gibt es **genau eine wiederverwendbare Komponente**. Nicht pro Screen neu bauen.
- Maße, Abstände, Radien und Typografie kommen aus den Tokens von `design.md` (Abschnitte 2 und 3). Keine Magic Numbers in Komponenten.
- Erlaubte Abstandsskala: `4 · 8 · 12 · 16 · 24 · 32 · 40`. Seitenrand immer 16, Karten-Innenpadding 16.
- Englischer Lerninhalt immer Serif + Cyan, deutscher UI-Text immer Sans + Weiß bzw. `--text-muted`.
- Neue Komponente nötig, die nicht in `design.md` steht? Erst die Spezifikation dort ergänzen (an die bestehenden Regeln angelehnt), dann bauen.
- Bei Widerspruch zwischen `design.md` und einem Screenshot: Screenshot prüfen, `design.md` korrigieren und dem Nutzer kurz mitteilen. Nicht stillschweigend abweichen.

### Selbstprüfung vor Abschluss jeder UI-Aufgabe
1. Kommt im Diff eine Farbe vor, die kein Token ist? Dann korrigieren.
2. Wurde für ein vorhandenes Muster eine bestehende Komponente verwendet?
3. Stimmen Radien, Abstände und Schriftstile mit `design.md` überein?
4. Sind die Zustände umgesetzt (aktiv, inaktiv, gedrückt, deaktiviert, Fehler, leer)?
5. Sieht es bei 375 px Breite aus wie im Screenshot? UI wenn möglich im Browser bzw. Simulator ansehen und die Vorlage daneben halten. Wenn das nicht testbar war, ausdrücklich sagen.

## Allgemeine Richtlinien

### Sprache
- Mit dem Nutzer auf **Deutsch** kommunizieren.
- **UI-Texte auf Deutsch** in der Anrede "du" (wie in den Screenshots). Englisch nur für den Lerninhalt.
- Code, Bezeichner, Commit-Messages und technische Kommentare auf **Englisch**.

### Arbeitsweise
- Kleine, überprüfbare Schritte. Ein Screen oder eine Komponente pro Aufgabe. Nichts bauen, was nicht verlangt wurde.
- Vor größeren Entscheidungen (Stack, Datenmodell, Backend) kurz eine Empfehlung mit dem wichtigsten Trade-off nennen und bestätigen lassen.
- Bestehenden Code bevorzugt ändern statt neue Dateien anzulegen. Keine spekulativen Abstraktionen, kein toter Code.
- Kommentare nur, wenn das *Warum* nicht offensichtlich ist.
- Commits nur auf ausdrückliche Anfrage.

### Lernlogik (Domäne)
- Karten folgen einem Wiederholungs-Algorithmus (Spaced Repetition). Wort-Status ("Neues Wort" → gelernt) wird über die 5 Status-Striche dargestellt.
- Die **Stapel-Revue** ist eine reine Wiederholung ohne Einfluss auf den Algorithmus. Sie darf keinen Lernstatus ändern und zeigt keine neuen Wörter.
- Tagesziel (z. B. 50 Karten) und Wochenleiste basieren auf der Zahl erledigter Karten pro Tag.

### Qualität
- Barrierefreiheit gemäß `design.md` Abschnitt 8: Kontraste, Fokus-Ring, `aria-label` für Icon-Buttons, Status nie nur über Farbe.
- Deutsche Zahlenformate (`1.456`, `93 %`) und Umlaute/`ß` korrekt darstellen (UTF-8, Schrift mit vollem Latin-Support).
- Mobile-first, Basisbreite 375 px. Auf größeren Bildschirmen den Inhalt zentrieren (max. 480 px), nicht strecken.

### Rechtliches und Datenschutz
- Die Screenshots stammen aus einer bestehenden kommerziellen App. **Keinen Markennamen, kein Logo, keine Illustrationen, Icons, Texte oder Lerninhalte aus den Screenshots übernehmen.** Name, Icons, Cover-Grafiken, Illustrationen und Inhalte werden eigenständig erstellt.
- Die Screenshots enthalten persönliche Daten (Name, E-Mail). Diese nie in Code, Tests oder Seed-Daten übernehmen. Für Beispieldaten Platzhalter verwenden.
- Den Ordner `Screenshots/` nicht veröffentlichen (nicht in ein öffentliches Repo committen), solange der Nutzer nichts anderes sagt.

## Tech-Stack

_Noch offen. Nach der Abstimmung hier eintragen (Framework, Sprache, Styling-Ansatz, Build- und Test-Befehle)._

## Dateien

- `design.md` – verbindliche visuelle Spezifikation (Farben, Typografie, Abstände, Radien, Komponenten, Screens)
- `Screenshots/` – Referenzbilder (nur lokal, nicht veröffentlichen)
