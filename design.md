# design.md – Design-System der Englisch-Lern-App (für deutsche Muttersprachler)

Quelle: 25 iPhone-Screenshots in `./Screenshots/` (1125 × 2436 px = 375 × 812 pt @3x).

**Genauigkeit der Werte**
- **Farben**: per Pixel-Messung aus den Screenshots ermittelt und daher exakt (Hex).
- **Maße** (pt): am Pixelraster gemessen, Toleranz ca. ±1 pt. Eckenradien sind aus der Kantenkrümmung abgeleitet, also auf ca. ±2 pt genau.
- **Schriftgrößen**: aus Zeilenabstand und Versalhöhe geschätzt (Toleranz ±1–2 pt). Die Original-Schriften sind nicht identifizierbar, es gelten die Ersatzschriften aus Abschnitt 2.
- **1 pt = 1 CSS-px**. Alle Maße unten sind CSS-px auf einer Basisbreite von 375 px.

Die App ist **dark-first**. Es gibt ein einziges helles Element: die Grammatik-Erklärungsseite (Abschnitt 9).

---

## 1. Farb-Tokens

### 1.1 Basis (Dark Theme)

| Token | Hex | Verwendung |
|---|---|---|
| `--bg` | `#12222E` | Seitenhintergrund, Bottom Sheets (Info-Popups), Navigationsleiste |
| `--surface` | `#2C3143` | Karten, Listenkarten, Kacheln, Eingabefelder, Suchfeld, Tastatur-Zusatzleiste, Haarlinien-Trenner |
| `--surface-2` | `#424960` | Fortschrittsbalken-Track **auf** Karten, inaktive Segmente, Pill-Buttons auf `--surface`, gepunktete Wort-Unterstreichung, Info-Karte "Stapelinhalte wiederholen" |
| `--surface-3` | `#3B3F58` | "Aktiver Tag"-Kachel (Wochenleiste), Icon-Kachel "Verben" |
| `--field` | `#344557` | Lücke im Lückentext (leer und ausgefüllt) |
| `--flag-border` | `#3A475F` | Rand der Flaggen-Kachel im Header der Startseite |
| `--scrim` | `rgba(255,255,255,0.33)` | Abdunkelung hinter Bottom Sheets. Es ist ein **weißer** Schleier, die Seite dahinter wird dadurch heller und graublau. |
| `--white` | `#FFFFFF` | Primärtext, Icons (Outline), Primär-Button-Fläche |

### 1.2 Akzente

| Token | Hex | Verwendung |
|---|---|---|
| `--cyan` | `#6CD5E5` | **Englischer Text** (Serifenschrift), Fortschrittsbalken "Stand aktivierter Wörter", Cyan-Icon-Akzente, Cursor in der Lücke, Punkt "Gesamtzahl der Wörter" |
| `--cyan-dark` | `#5293A3` | Zweite (untere) Hälfte des Cyan-Icons "Gesamtzahl der Wörter" |
| `--cyan-icon` | `#63E1E7` | Cyan-Füllungen in Illustrations-Icons (Stapel-Icon, Sterne) |
| `--cyan-fill-soft` | `#84EBEE` | Helle Cyan-Fläche in Text-Covern |
| `--teal-pill` | `#037889` | Hintergrund des hervorgehobenen Beispielsatzes in der Wortliste (Text darauf: `--cyan`) |
| `--lilac` | `#E2B4FF` | **Primärer Akzent**: aktive Nav-Items, Links ("Ziel ändern", "Alle Statistiken", "Ändern", "Alle anzeigen"), aktive Toggles, Fortschrittsbalken der Übung, Tab-Unterstreichung, Fokusrahmen, Fortschrittsring des Lernen-Buttons, Checkboxen/Stift-Icons |
| `--lilac-soft` | `#DDC3F4` | Hellflächen in Text-Covern (Diagonalstreifen) |
| `--purple` | `#AC6ED1` | Kleines Startsegment im Fortschrittsbalken "Stand aktivierter Wörter", Gehirn-Illustration |
| `--purple-cover` | `#BC99D8` | Lila Flächen in Text-Covern |
| `--periwinkle` | `#8EA3EE` | Sekundäres Icon-Blau (Inhalte: Texte, Sprechen, Stapel erstellen) |
| `--orange` | `#FAAA5A` | Label "Neues Wort" + erstes Segment des Wort-Status-Indikators, Icon "Verfügbare Wiederholungen", Punkt "zu lernende Wörter" |
| `--blue-link` | `#00B8FF` | Rechtliche Links (Konto), Punkt neben "Ziel ändern" |

### 1.3 Semantik / Status

| Token | Hex | Verwendung |
|---|---|---|
| `--success` | `#43D281` | Gelernte Wörter (Balken, Punkt) |
| `--success-dark` | `#378262` | "Gesehen, noch nicht gelernt" (zweites Balken-Segment; Punkt `#2A7A57`) |
| `--error` | `#FE5C55` | Falsche Antwort (Rahmen + X-Kreis), Benachrichtigungs-Punkt (Glocke, Konto) |
| `--track-off` | `#323D48` | Track eines ausgeschalteten Toggles |

### 1.4 Text

| Token | Hex | Verwendung |
|---|---|---|
| `--text` | `#FFFFFF` | Titel, Fließtext, Labels |
| `--text-muted` | `#B2B8CB` | Sekundärtext: Untertitel, Meta-Zeilen ("Zuletzt gesehen …"), Beschreibungen, inaktive Tabs, Werte rechts in Listen, Zähler "24/50" |
| `--text-on-light` | `#2C3143` | Text auf weißen Buttons |
| `--text-en` | `#6CD5E5` (= `--cyan`) | Englische Wörter/Sätze, immer Serifenschrift |
| `--icon-dim` | `#565A68` | Inaktive/ausgegraute Icons (Blitz-Level, Wortlisten-Aktionen, ~approx.) |
| `--icon-bolt` | `#A0A6AB` | Gefüllter Blitz im Level-Indikator; leer: `#414E58` |

### 1.5 Helles Theme (nur Grammatik-Erklärung, siehe Abschnitt 9)

`--light-bg #FFFFFF` · `--light-text #333B44` · `--light-en #338C99` (Serif, Teal) · `--light-border #CECECE`

### 1.6 CSS-Vorlage

```css
:root {
  --bg:#12222E; --surface:#2C3143; --surface-2:#424960; --surface-3:#3B3F58; --field:#344557;
  --flag-border:#3A475F; --scrim:rgba(255,255,255,.33); --white:#FFFFFF;
  --cyan:#6CD5E5; --cyan-dark:#5293A3; --cyan-icon:#63E1E7; --cyan-fill-soft:#84EBEE; --teal-pill:#037889;
  --lilac:#E2B4FF; --lilac-soft:#DDC3F4; --purple:#AC6ED1; --purple-cover:#BC99D8;
  --periwinkle:#8EA3EE; --orange:#FAAA5A; --blue-link:#00B8FF;
  --success:#43D281; --success-dark:#378262; --error:#FE5C55; --track-off:#323D48;
  --text:#FFFFFF; --text-muted:#B2B8CB; --text-on-light:#2C3143; --text-en:var(--cyan);
  --icon-dim:#565A68; --icon-bolt:#A0A6AB; --icon-bolt-off:#414E58;
  --light-bg:#FFFFFF; --light-text:#333B44; --light-en:#338C99; --light-border:#CECECE;
}
```

**Regeln**
- Es gibt **keine Verläufe, keine Schatten und keine Transparenz-Effekte** außer dem `--scrim`. Alle Elemente sind flach. Tiefe entsteht nur durch die Stufen `--bg` → `--surface` → `--surface-2`.
- Ein Fortschrittsbalken-Track ist immer **eine Stufe heller als sein Untergrund**: auf `--bg` ist er `--surface`, auf `--surface` ist er `--surface-2`.
- Cyan ist **ausschließlich** für englischen Inhalt und Cyan-Fortschritt reserviert. Deutscher Text ist immer Weiß oder `--text-muted`.
- Lila (`--lilac`) ist die einzige Interaktionsfarbe (aktiv, Link, Fokus, an). Weiß ist die Farbe der primären Aktion (Button).

---

## 2. Typografie

Zwei Schriftfamilien mit klarer Rollentrennung:

| Rolle | Familie | Ersatzschrift (Google Fonts) |
|---|---|---|
| **UI / Deutsch** | Serifenlose, geometrische, leicht gerundete Grotesk. Das Regular ist ruhig, das `ß` deutlich ausgeprägt. | `"Figtree", system-ui, -apple-system, "Segoe UI", sans-serif` |
| **Englischer Lerninhalt** | Warme Serifenschrift mit mittlerem Kontrast (wirkt wie Source Serif oder Literata) | `"Source Serif 4", "Literata", Georgia, serif` |

Die Auszeichnung ist über **Familie und Farbe** geregelt: Englisch = Serif + Cyan, Deutsch = Sans + Weiß. Fett wird kaum verwendet. Standardgewicht ist **400**, Titel und Listentitel **500**. Nur "Achtung!" auf der hellen Seite ist **700**.

| Stil | Größe / Zeilenhöhe | Familie | Einsatz |
|---|---|---|---|
| `display` | 24 / 28 | Sans 500 | Seitentitel groß ("Inhalte", Stapel-Titel, Sheet-Titel) |
| `nav-title` | 17 / 22 | Sans 400 | Zentrierter Titel der Top-Bar ("Stapel", "Grammatik") |
| `section` | 15 / 20 | Sans 400, **UPPERCASE** | Sektionsköpfe ("HEUTIGES ZIEL", "MEINE FORTSCHRITTE") |
| `title` | 17 / 22 | Sans 500 | Kartentitel, Listentitel, Button-Label, Nav-Label groß |
| `body` | 16 / 20 | Sans 400 | Fließtext in Karten und Sheets |
| `body-sm` | 14 / 16 | Sans 400 | Beschreibungen (Einstellungen), Stat-Label, Untertitel |
| `meta` | 13 / 16 | Sans 400 | "Zuletzt gesehen …", "Grammatik | Level 1" |
| `caption` | 12 / 14 | Sans 400 | Labels der Bottom-Navigation |
| `stat` | 18 / 24 | Sans 400 | Zahlen in Stat-Karten |
| `stat-lg` | 24 / 28 | Sans 400 | Wert rechts in Sheet-Zeilen ("1.456") |
| `sentence` | 28 / 36 | **Serif** 400, `--cyan` | Lückentext-Satz auf der Übungskarte |
| `en-headword` | 24 / 28 | **Serif** 400, `--cyan` | Wort in der Wortliste, Wort im Info-Sheet |
| `en-line` | 20 / 22 | **Serif** 400, `--cyan` | Beispielsätze, Antwortoptionen |
| `read` | 20 / 36 | Sans 400 | Lesetext der Text-Übung (bewusst sehr luftig) |

Weitere Regeln:
- **Zeilenlänge**: Text läuft bis zum Kartenpadding. Die Sheet-Beschreibung nutzt 24 px Rand links und rechts.
- **Zahlen**: deutsches Format mit Tausenderpunkt (`1.456`), Prozent mit Leerzeichen (`93 % von 1.433` aktivierten Wörtern; unterscheidet sich von der Gesamtzahl `1.456`).
- **Sprache**: die gesamte UI ist auf Deutsch, Anrede **"du"**.

---

## 3. Abstände, Raster, Radien

### 3.1 Spacing-Skala (px)

`4 · 8 · 12 · 16 · 24 · 32 · 40`. Alles im Layout ist ein Vielfaches von 4.

| Wert | Verwendung |
|---|---|
| **16** | **Seitenrand** (überall), Innenpadding von Karten, Abstand zwischen Karten und Kacheln nebeneinander, Abstand zwischen Cover-Karten |
| **8** | Abstand zwischen gestapelten Listenkarten (Stapel-Liste, Aktivitäts-Karten), Lücke Suchfeld ↔ Musik-Button |
| **24** | Seitenrand von Text in Bottom Sheets, Abstand vor einem Sektionskopf |
| **32** | Abstand zwischen großen Sektionen |

### 3.2 Layout-Maße

- **Bildschirm**: 375 px breit. Inhaltsbreite = **343 px** (375 − 2 × 16).
- **Top-Bar**: 44 px hoch (unter der Statusleiste). Zurück-Pfeil links (24 px Icon, 16 px vom Rand), Titel zentriert, Aktions-Icon rechts (Menü ⋮, Hilfe ?, Plus, Filter).
- **Bottom-Navigation**: 57 px Leiste + 34 px Home-Indicator-Bereich. Trennlinie oben 1 px `--surface`. (Höhe korrigiert von 49 px, Begründung siehe 5.1.)
- **Zwei-Spalten-Raster**: 2 × **163 px**, Lücke **16 px** (Stat-Karten, Inhalte-Kacheln).
- **Vertikale Rhythmik** Startseite: Sektionskopf → 8 px → Karte; Karte → 16 px → nächste Karte; Ende Sektion → 24–32 px → nächster Kopf.

### 3.3 Eckenradien

| Element | Radius |
|---|---|
| Kleine Karten, Listenkarten, Kacheln, Suchfeld, Eingabefelder, Buttons (breit) | **8** |
| Große Inhaltskarten (Stapel-Revue-Karte, Lückentext-Karte, Übersetzungs-Karte, Info-Karte, Antwortfeld) | **12** |
| Bottom Sheet (nur obere Ecken) | **16** |
| Text-Cover | **12** |
| Lücke im Satz, Icon-Kachel, A1-Badge | **4–6** |
| Pills (Button "Übung starten", "Wort erfahren"), Fortschrittsbalken, Toggle, Status-Punkte, runde Play-Buttons | **9999** (voll rund) |

### 3.4 Linien & Flächen

- **Trennlinien** in Listen: 1 px `--surface`, mit 16 px Einzug links/rechts.
- **Trennlinien** in Sheets (Wertzeilen): 1 px `--white`, ebenfalls 16 px Einzug.
- **Outline-Buttons**: 1.5 px `--white`, transparent.
- **Fokus-Rahmen** Eingabe: 2 px `--lilac`.
- **Fehler-Rahmen**: 2 px `--error`, Radius 12.
- Keine Schatten. Kein Blur.

---

## 4. Icons

- **Stil**: Outline, Strichstärke ca. 2 px, abgerundete Enden, Weiß (`--white`). Jedes Icon hat einen kleinen **farbigen Füllakzent** (Standard: Cyan, Lila, Orange oder Periwinkle; in der Stapel-Übersicht auch themenspezifische Füllungen wie Pink, Türkis, Teal – siehe Abschnitt 10), der leicht versetzt hinter oder neben dem Strich liegt.
- **Größen**: Nav-Icons 28, Top-Bar-Icons 24–28, Karten-Icons 22–32, Stapel-Icons 33, Illustrations-Icons im Sheet-Titel 24.
- **Chevron** (`›`, `⌄`, `⌃`): 16 px, Weiß, Strichstärke 2.5.
- **Blitz-Level** (Schwierigkeit): 3 Blitze à ca. 14 px, Abstand 16, gefüllt `--icon-bolt`, leer `--icon-bolt-off`. Niveau 1 = 1 gefüllt, 2 = 2, 3 = 3.
- Eigene, neutrale Icon-Bibliothek verwenden (z. B. Lucide oder Phosphor im Outline-Stil) und die Akzentfüllungen selbst nachbauen. **Keine Icons oder Illustrationen aus den Screenshots wiederverwenden.**

---

## 5. Komponenten

### 5.1 Bottom-Navigation (fünf Slots, ohne Beschriftung der Mitte)

- Leiste: Höhe **57 px** + Safe Area, Hintergrund `--bg`, Trennlinie 1 px `--surface` am oberen Rand.
  - *Korrigiert von ursprünglich 49 px.* Die 49 px fassen Trennlinie 1 + Icon 28 + Abstand 4 + Label 14 exakt aus, lassen also keine Luft unter der Trennlinie. Die Leiste setzt sich jetzt zusammen aus 1 px Trennlinie + 8 px Abstand + 48 px Inhalt. Erst dieser Abstand erlaubt es, den Kreismittelpunkt wie unten gefordert auf die Leistenoberkante zu legen: Der Ringboden liegt dann 36,5 px unter der Oberkante, das Label „Lernen" beginnt bei 42 px und bleibt damit frei sichtbar.
- 5 gleich breite Slots à 75 px: **Hauptseite · Inhalte · [Lernen] · Fortschritte · Konto**.
- Icon 28 px über Label (`caption` 12/14), Abstand 4 px.
- **Aktiv**: Icon und Label `--lilac`. **Inaktiv**: `--white`.
- **Mitte "Lernen"** (Hauptaktion): weißer Kreis Ø 48 px (`--white`) mit dunklem "Pfeil-in-Kreis"-Icon (`--surface`), Label darunter.
  - Umgeben von einem **Fortschrittsring** Ø 73 px, Strichstärke 4 px: Bogen `--lilac`, Rest `--surface`. Der Ring zeigt den Tagesfortschritt.
  - Der Kreismittelpunkt liegt auf der Oberkante der Leiste, sodass der Button ca. 35 px über die Leiste hinausragt.
- **Badge-Punkt** (Konto, Glocke): Ø 8 px, `--error`, oben rechts am Icon.

### 5.2 Top-Bar

- Zurück-Pfeil links (`<`), zentrierter Titel (`nav-title`), Aktions-Icon rechts (je nach Screen: Menü `⋮`, Hilfe `?`, Plus `+`, Filter `Sliders`, oder keines). Hintergrund `--bg`, keine Linie. Haupttabs (Startseite, Mein Konto) haben keinen Zurück-Pfeil.
- **Übungs-Top-Bar**: Home-Icon links, in der Mitte Zähler ("24/50", `meta`, `--text-muted`) über einem **Fortschrittsbalken** (243 px breit, 8 px hoch, Track `--surface`, Füllung `--lilac`), Menü ⋮ rechts.
- **Startseiten-Kopf**: Flagge (41 × 26, Radius 2, Rand 1 px `--flag-border`) + Text "Sprache wechseln" (`title`, `--white`), rechts Glocke (mit rotem Badge-Punkt oben rechts) und Zahnrad, je 32 px.

### 5.3 Karte (Standard)

- Fläche `--surface`, Radius 8 (klein) bzw. 12 (groß), Padding 16, Breite 343.
- Kopf: Titel (`title`, Weiß). Optional Chevron `›` rechts oben (Navigation) oder `✕` (schließbar).
- Untertitel/Beschreibung: `body` bzw. `body-sm`, `--text-muted`.
- Tap-Fläche der ganzen Karte, wenn ein Chevron vorhanden ist.

### 5.4 Ziel-Karte / Wochenleiste ("HEUTIGES ZIEL")

- Sektionskopf links "HEUTIGES ZIEL" (`section`), darunter "24 / 50 Karten" (`body`, `--text-muted`). Rechts der Link "Ziel ändern" (`--lilac`) mit einem Cyan-Blau-Punkt `--blue-link` (Ø 8) davor.
- 7 Tages-Kästchen **Mo–So**, je 24 × 24, Radius 6, Abstand gleichmäßig verteilt (Pitch ca. 49).
  - Leer: transparent, Rahmen 2 px `--surface`.
  - Erledigt: Fläche `--surface-3` mit lila Stift/Häkchen-Icon (`--lilac`).
  - Label darunter (`body`, Weiß). **Heute** (Fr) hat hinter dem Label eine `--surface-3`-Kachel (Radius 6–8), die als vertikaler Reiter nach unten über die Zeile hinausragt.

### 5.5 Promo-/Feature-Karte (horizontaler Carousel, "Stapel-Revue")

- Breite 317 px, Höhe ca. 141 px, `--surface`, Radius 12, Padding 16. Die nächste Karte lugt 16 px rechts hervor (Snap-Scroll).
- Titel `title`, Text `body`, `✕` rechts oben. Unten ein **Pill-Button** "Übung starten": weiß, Höhe 30, Breite passend (Padding 0 16), Label `title` in `--text-on-light`.

### 5.6 Stat-Karten

- **Breite Fortschrittskarte** ("Stand aktivierter Wörter"): 343 × 104 (Höhe variabel je nach Inhalt, ca. 100–110 px; fasst Titel + Chevron, Untertitel, Fortschrittsbalken und 16 px Padding), Titel + Chevron, darunter `body` `--text-muted` "93 % von 1.433" (aktivierte Wörter; als eigene Kennzahl zur "1.456" Gesamtzahl der Wörter), darunter Balken (8 px hoch, Track `--surface-2`, Füllung `--cyan`, erstes Segment 8 px `--purple`).
- **Kompakte Stat-Karte** (2er-Raster, 163 × 112, Radius 8, Padding 16): Icon 22 px oben links, Chevron oben rechts, darunter Zahl (`stat`, Weiß) und Label (`body-sm`, `--text-muted`, bis zu 2 Zeilen). Ein Tap öffnet ein Info-Sheet (5.11). Links: Icon zwei Balken (Cyan-Akzent), "1.456", "Gesamtzahl der Wörter". Rechts: Icon vier Quadrate (Orange-Akzent), "0", "Verfügbare Wiederholungen".
- **Statistik-Zeilenkarte** ("Mein Wissenszentrum"): Zeilen à 46 px: Icon 28 (links), Label `title`, rechts farbiger Punkt Ø 14 (`--cyan`, `--orange`, `--lilac`) + Wert (`title`, `--text-muted`) + Chevron `›`. Trennlinie zwischen Zeilen 1 px, Einzug 8 px. Zwei separate Karten (`--surface`, Radius 8, Abstand 8): Karte 1 mit 3 Zeilen (Gesamtzahl der Wörter [Cyan-Punkt], Bekannte Wörter [Cyan-Punkt], Gesamtzahl zu lernender Wörter [Orange-Punkt]), Karte 2 mit 1 Zeile (Gesamtzahl gelernter Wörter [Lila-Punkt]).

### 5.7 Lückentext-Karte (Kern-Komponente)

Aufbau von oben nach unten, alles auf **einer** Karte (`--surface`, Radius 12, Padding 16, Breite 343):

1. **Status-Indikator**: 5 Striche à 16 × 4, Abstand 4, Radius voll. Erster Strich `--orange`, die übrigen `--surface-2`. Daneben Label (`body-sm`, `--orange`) "Neues Wort". Mit steigender Beherrschung füllen sich die Striche.
2. **Satz** (`sentence`, `--cyan`, Serif): englischer Satz mit einer **Lücke**.
   - Jedes Wort/Wortgruppe hat darunter eine **gepunktete Linie** (2 px, `--surface-2`), die auf Tipp die Übersetzung öffnet.
   - **Lücke leer**: Kasten `--field`, min. Breite 100, Höhe 32, Radius 6, vertikaler Cursor (2 × 24, `--cyan`) am linken Rand.
   - **Lücke gefüllt**: gleiche Fläche `--field`, das eingesetzte Wort in `--cyan` (Serif).
3. **Grammatik-Hinweis-Zeile**: Text `body` (Weiß), Chevron `›` rechts, Fläche transparent auf der Karte. Ein Tap öffnet ein Bottom Sheet mit der Erklärung.
4. Darunter eine **separate Übersetzungs-Karte** (`--surface`, Radius 12, Padding 16, Abstand 16): Kopf mit deutschem Wort (`title`) und Chevron `⌃/⌄` zum Auf-/Zuklappen, im Körper der deutsche Beispielsatz (`body`, Weiß).
5. **Eingabezeile** direkt über der Tastatur: Fläche `--surface`, Höhe 47, links Mikrofon-Icon 24, rechts Pill "Wort erfahren" (`--surface-2`, Höhe 30, Padding 0 16, `title`).

### 5.8 Text-Übung (Lückentext im Fließtext)

- Kopf: `✕` links, Titel des Textes (`meta`, Weiß) mittig, Glühbirnen-Icon rechts, darunter 2 px Fortschrittsbalken (wie 5.2).
- Text `read` (20/36, Weiß). Lücken sind **Inline-Eingabefelder**, 128 × 28, `--surface`, Radius 8. Als Platzhalter dient das Grundwort in `--text-muted` (z. B. "combine").
- **Fokus**: Rahmen 2 px `--lilac`, blauer System-Cursor.
- **Tastatur-Zusatzleiste**: Dunkle Leiste direkt über der Tastatur (Höhe ca. 44–48 px, `--bg` bzw. `--surface`). Links zwei Icons: `文A` (Übersetzen) und `⇄` (Wechseln/Zyklus) in Weiß (Tap-Ziel ca. 40 × 40). Rechts Text-Button "Antwort anzeigen" (`title`, Weiß, flach ohne Kasten/Pill).
- **Keine Sprungleiste**: In der Text-Übung gibt es keine A–Z-Sprungleiste (diese existiert ausschließlich in der Wortlisten-Übersicht).

### 5.9 Auswahl-Übung (Grammatik)

- Satz mit Lücke oben/mittig (`sentence`, `--cyan`, Serif), z. B. "We went through the ... check together.", darunter große freie Fläche.
- Kopf: `✕` links, 2 px Fortschrittsbalken, Glühbirnen-Icon rechts.
- Aufgabenzeile und Antwortoptionen sind **unten am Bildschirm** verankert:
  - Konkrete Aufgabenzeile direkt über den Optionen (`body` bzw. `body-sm`, `--text-muted` / Weiß), z. B. "Wähle das Wort, das am besten in die Lücke passt" oder "Wähle die richtige Antwort".
  - Drei Antwortzeilen: Höhe 52–56 px, Padding 0 16, Zeilenabstand / Pitch ca. 60–64 px.
  - Antwortoptionen können entweder englische Wörter in `--cyan` Serif (`en-line`) oder Sans-Serif Buchstaben ("C", "B", "A" in Weiß) sein.
  - **Standard-Zustand**: Die Optionen haben **keinen Rahmen** (flach auf `--bg`, kein Rand/Hintergrund).
  - **Fehler-Zustand (Falsch)**: Nur die angetippte falsche Option erhält einen Rahmen: 2 px `--error`, Radius 12, Höhe 52–56 px, Padding 0 16. Rechts am Zeilenende erscheint ein gefülltes Kreis-Icon (Ø 22, `--error`) mit zentriertem weißem `✕`. Die anderen beiden Optionen bleiben rahmenlos.
  - **Richtig**: Rahmen und Icon in `--success` (analog, nach dem Muster der Fehler-Antwort; siehe Abschnitt 10).
  - Betonte Buchstaben in englischen Wörtern werden mit einer 1.5 px Linie unterstrichen (z. B. Endung "-le").

### 5.10 Listenzeilen

- **Stapel-Listenkarte** (Auswahl, "Alle Stapel"): 343 × 72, `--surface`, Radius 8, Abstand 8. Links Kachel 40 × 40 (Radius 8) mit Icon (24 px, Weiß) auf individuellem farbigen Hintergrund (siehe Abschnitt 10). Rechts daneben Titel (`title`, Weiß), darunter Blitz-Level (3 × 14).
  - **Fortschrittsbalken** (100 × 8): Nur vorhanden bei bereits begonnenen Stapeln (`--surface-2` Track, `--success` Füllung für gelernte Wörter, optional `--success-dark` für gesehene Wörter). Unbegonnene Stapel zeigen **keinen** Fortschrittsbalken, nur die Blitze.
- **Aktivitäts-Karte** (Startseite, "DERZEITIGE LERNAKTIVITÄT"): `--surface`, Radius 8, Padding 16. Links Kachel 40 × 40 (`--surface-2`, Radius 8) mit Icon (24 px, Weiß/Akzent), rechts daneben Titel (`title`, Weiß), Untertitel (`body-sm`, `--text-muted`) und Chevron `›` rechts.
- **Stapel-Revue-Zeile**: Icon/Kachel 33, Titel (`title`, Weiß), Balken (nur Track `--surface-2`) und rechts ein runder Play-Button Ø 44 (`--surface`, weißes Play-Dreieck). Trennlinie 1 px `--surface`.
- **Grammatik-Zeile**: Flache Liste auf `--bg` (keine umschließenden Karten). Titel (`title`), Aufgabe (`body`), Meta "Grammatik | Level 1" (`meta`, `--text-muted`), Chevron `›` rechts, 1 px Trennlinie `--surface`.
- **Wortlisten-Zeile**: Wort (`en-headword`, `--cyan`) + Lautsprecher-Icon 24 (Weiß), darunter Beispielsatz (`en-line`, `--cyan`), darunter Meta (`meta`, `--text-muted`, "Zuletzt gesehen: … | Wiederholt: 2 Mal"). Rechts drei gedimmte Aktions-Icons (`--icon-dim`) vertikal angeordnet und Chevron `›`. Beim aktuell gewählten Wort liegt der Beispielsatz auf einer `--teal-pill`-Fläche (Radius 8). Am rechten Bildschirmrand steht eine A–Z-Sprungleiste (`meta`, `--text-muted`).
- **Hinweis-Liste** (Grammatikhinweise, Konto, Einstellungen):
  - In **Grammatikhinweise**: Zeilen mit `title` Weiß, 60 px hoch, 1 px Trennlinie `--surface`, **kein Chevron** rechts (reiner linksbündiger Text).
  - In **Konto / Einstellungen**: Zeilen mit `title` Weiß, 60 px hoch, 1 px Trennlinie `--surface`, Chevron `›` rechts, optionaler Wert links vom Chevron in `--text-muted`.

### 5.11 Bottom Sheet (Info-Popup)

- Von unten eingeblendet, Fläche `--bg` (bei Wort-Info `--surface`), obere Ecken 16, Seitenpadding 24, hinter dem Sheet `--scrim`.
- `✕` oben rechts (24 px, 24 px vom Rand, 21 px unter der Kante).
- Titel `display` (24/28) mit optionalem Icon 24 davor; Beschreibung `body`, Weiß bzw. `--text-muted`.
- **Wertzeile**: zwischen zwei Trennlinien (1 px, Einzug 16): Label `title` links, Wert `stat-lg` `--text-muted` rechts.
- **Varianten nach Fußbereich**:
  - **Info-Sheets ohne Button**: Wissenszentrum-Statistik-Popup oder Wort-Info besitzen **keinen** Primär-Button am unteren Rand; Schließen erfolgt ausschließlich über das `✕` oben rechts oder Herunterwischen.
  - **Aktions-Sheets mit Button**: Primär-Button (weiß, 343 × 46, Text `--text-on-light`, Radius 8) am unteren Rand, z. B. "Jetzt lernen", "Ziel festlegen".
  - **Vorschau-Sheet mit Übungsliste** (Texte-Vorschau): Cover 88 × 128 links, daneben Titel und Level-Badge ("A1", `--surface-2`), Beschreibung, darunter Übungszeilen ("Verben", "Beliebige Wortart") mit jeweils rundem Play-Button Ø 44 rechts.
- Optionaler Illustrationsblock (Icon 80 px) zentriert über dem Titel.

### 5.12 Buttons

| Typ | Aussehen |
|---|---|
| **Primär** | Fläche `--white`, Text `--text-on-light`, `title`, 343 × 46, Radius 8, zentriert (z. B. "Lerne mit diesem Stapel") |
| **Primär-Pill** | wie Primär, aber voll rund, Höhe 30, Padding 0 16 (Promo-Karten) |
| **Sekundär-Pill** | Fläche `--surface-2`, Text Weiß, voll rund, Höhe 30 (Tastaturleiste) |
| **Outline** | transparent, Rahmen 1.5 px Weiß, Text Weiß, Radius 12, Höhe 46 ("Stapel nochmals durchsehen", "Abmelden") |
| **Text-Link** | `--lilac`, `title` bzw. `body` ("Alle Statistiken", "Ändern", "Alle anzeigen") |
| **Runder Play** | Ø 44, `--surface`, weißes Play-Icon |

Gedrückt-Zustand: Fläche um ca. 8 % abdunkeln (Weiß → `#E6E6E6`, Karten → `--surface-2`). Deaktiviert: 40 % Deckkraft.

### 5.13 Toggle

- iOS-Stil: 51 × 31, Knopf Ø 27 in Weiß.
- **An**: Track `--lilac`. **Aus**: Track `--track-off`, Knopf links.
- Zeile: Titel `title` links, Toggle rechts, darunter Beschreibung (`body-sm`, `--text-muted`), Trennlinie 1 px `--surface`. Deaktivierte Titel in `--text-muted`.
- Toggle-Zeile auf einer Karte (z. B. "Stapel lernen"): Karte `--surface`, Höhe 58, Radius 12.

### 5.14 Tabs

- Zweiteilig oder scrollbar (`nav-title`, 17): aktiv Weiß, inaktiv `--text-muted`.
- Aktiv-Indikator: 2 px `--lilac`, so breit wie das Tab, am unteren Rand. Kein Hintergrund.

### 5.15 Text-Cover-Karte (Texte-Übersicht)

- Horizontaler Carousel, Karte **88 × 128**, Radius 12, Abstand 16. Darunter Titel (`title`, 88 px breit, umbrechend).
- **Cover-Grafik**: flache geometrische Streifen und Dreiecke (Diagonalen) in zwei Paletten: **dunkel** (`#252938` mit Streifen `#3B3F58`, Cyan-Dreieck `--cyan-fill-soft`) und **lila** (`--purple-cover` mit `--lilac-soft`).
- **Level-Badge** "A1" oben rechts: 32 × 24, Radius 4–6, halbtransparente Fläche, Text Weiß (`title`).
- Im Sheet zeigt die Vorschau Cover und Titel nebeneinander, daneben ein Badge in `--surface`.

### 5.16 Suchfeld

- 343-Zeile: Feld (Höhe 46, `--surface`, Radius 8, Lupe 24, Platzhalter "Suchen", Weiß) + Quadrat-Button 46 × 46 (`--surface`, Radius 8, Icon) mit 8 px Abstand.

### 5.17 Status-Bar-Kennzeichen & Detail-Karten (Stapel-Detail)

- **Top-Bar**: Zurück-Pfeil `‹` links, Teilen/Mehr-Icon rechts. Beim Hinunterscrollen schiebt sich der Stapeltitel zentriert in die Top-Bar.
- **Statusbereich**:
  - Zwei Zeilen mit Punkt Ø 8: `--success-dark` "41 von 126 neuen Wörtern" (`body`), `--success` "28 Wörter gelernt".
  - Darunter Balken 343 × 8: `--success` (gelernt) + `--success-dark` (gesehen) auf Track `--surface`.
  - Level-Angabe rechts oben: "Mittleres Niveau" (`body-sm`, `--text-muted`) + 3 Blitze.
- **Primär-Button**: 343 × 46, Weiß, Text "Lerne mit diesem Stapel".
- **Aufklappbare Karte "letzte 5 Wörter"**: `--surface`, Radius 12, Titel "Deine letzten 5 gesehenen Wörter dieses Stapels:" (`title`, Weiß) + Chevron `⌄` bzw. `⌃`.
  - Aufgeklappt: 5 Einträge, getrennt durch 1 px Trennlinien.
  - Jeder Eintrag dreizeilig:
    1. Deutsches Wort (`title`, Weiß)
    2. Deutscher Beispielsatz (`body-sm`, `--text-muted`)
    3. Englischer Beispielsatz (`sentence`/`en-line`, `--cyan`, Serif)

### 5.18 Eingabemodus-Umschalter (Wörter/Text)

Segmented Control mit genau zwei Segmenten, der zwischen zwei Eingabearten wechselt. Eingesetzt beim Erstellen eigener Stapel: "Wörter" (einzelne Wörter eingeben) und "Text" (ganze Sätze eingeben). Neu gegenüber den Screenshots; abgeleitet aus 5.14 (Farben), 3.3 (Pill-Radius) und der Flächenleiter aus 1.6.

- **Maße**: volle Inhaltsbreite (343), Höhe **40**, Innenabstand **4** rundum. Die beiden Segmente teilen sich die Breite gleichmäßig und sind **32** hoch.
- **Track** (Fläche hinter beiden Segmenten): `--surface`, Radius **9999**. Er liegt auf `--bg`, das gewählte Segment liegt eine Stufe heller darauf.
- **Segment gewählt**: Fläche `--surface-2`, Radius **9999**, Label `--white`.
- **Segment nicht gewählt**: keine eigene Fläche (der Track scheint durch), Label `--text-muted`.
- **Label**: `nav-title` (17 / 22, Sans 400), zentriert. Der Text wechselt nur die Farbe, nicht das Gewicht.
- **Verhalten**: Immer genau ein Segment gewählt, Startzustand ist das linke ("Wörter"). Ein Tipp auf das gewählte Segment ändert nichts. Die ganze Segmentfläche ist tippbar, nicht nur der Text. Der Wechsel erfolgt sofort ohne Animation.
- **Zustände**: nur gewählt und nicht gewählt. Ein Gedrückt-, Deaktiviert- oder Fokus-Zustand ist nicht definiert.
- **Barrierefreiheit**: Jedes Segment ist als Button mit Auswahlzustand ausgezeichnet (Status nie nur über Farbe, siehe 8).
- **Bekannte Abweichung**: Die Segmente sind mit 32 px niedriger als die in 7 geforderten 44 px Tap-Ziel. Sollte bei Gelegenheit auf eine Höhe von mindestens 44 (Segment) angehoben werden.

---

## 6. Screen-Inventar

| Screen | Wichtigster Aufbau |
|---|---|
| **Startseite** | Kopf (Flagge, Glocke, Zahnrad) → HEUTIGES ZIEL + Wochenleiste → Promo-Carousel → MEINE FORTSCHRITTE (breite Karte + 2 Stat-Karten) → DERZEITIGE LERNAKTIVITÄT (Aktivitäts-Karten: Icon-Kachel 40 × 40 in `--surface-2` + Titel + Untertitel) → Bottom-Nav |
| **Inhalte** | Titel `display` → Sektion STAPEL (2 Kacheln) → Sektion ÜBUNGSAUFGABEN (Kacheln: Vokabeln, Stapel-Revue, Texte, Sprechen, Grammatik, Hören, Musik). Kacheln 163 × 100, Icon oben, Label darunter zentriert. |
| **Stapel (Liste)** | Top-Bar mit Hilfe-Icon → Sektion LINGVIST-STAPEL → Stapel-Listenkarten (mit individuellen Icon-Farben; Balken nur bei begonnenen Stapeln) |
| **Stapel (Detail)** | Top-Bar (beim Scrollen Titel einblendend) → Icon + Level → Titel `display` → Beschreibung → Status (5.17) → Toggle-Karte "Stapel lernen" → Primär-Button "Lerne mit diesem Stapel" → aufklappbare Karte "Deine letzten 5 gesehenen Wörter..." (dreizeilige Einträge) → MEHR DAVON (Revue-Karte mit Outline-Button "Diesen Stapel durchsehen") |
| **Stapel-Revue** | Info-Karte (schließbar, `--surface-2`) → Liste der Stapel mit Play-Buttons (Ø 44) und leerem Track |
| **Custom-Stapel erstellen** | *Übersicht:* Top-Bar (Zurück-Pfeil, Titel "Custom-Stapel" zentriert, Text-Link "Fertigstellen" in `--lilac` rechts) → Kopfzeile "Karten: N" (`title`, `--white`) mit "+"-Button (24) rechts → Karten-Zeilen (Karte nach 5.3: `--surface`, Radius 8, Padding 16, Abstand 8; Punkt Ø 8 `--orange`; dreizeilig in der Reihenfolge von 5.17: englisches Zielwort = Lückenwort (`en-headword`, `--cyan`, Serif), deutscher Satz (`body-sm`, `--text-muted`), englischer Satz (`en-line`, `--cyan`, Serif). Die Karte übt Englisch, deshalb Serif + Cyan für Zielwort und englischen Satz; eine Karte ohne englischen Satz, angelegt vor dessen Einführung, zeigt nur die ersten beiden Zeilen); ohne Karten stattdessen zentrierter Leertext ("Noch keine Karten. Füge Wörter hinzu, um zu starten.", `body`, `--text-muted`, keine Grafik). *Hinzufügen* (vom "+" geöffnet): Top-Bar (✕ links, Titel "Wörter hinzufügen", Text-Link "Hinzufügen" rechts, bei leerem Feld 40 %) → Umschalter Wörter/Text (5.18) → Abschnittstitel ("Wörter" bzw. "Text", `title`) → Hilfetext (`body`, `--text-muted`) → mehrzeiliges Eingabefeld (`--surface`, Radius 8, Padding 16, Platzhalter `--text-muted`, Fokus 2 px `--lilac`) → Hinweis zum Trennzeichen `;` (`body-sm`, `--text-muted`). Nach "Hinzufügen" zurück zur Übersicht, dort steigt "Karten: N". |
| **Übung (Vokabeln)** | Übungs-Top-Bar → Lückentext-Karte → Übersetzungs-Karte → Tastatur-Leiste. Sheet für Grammatikhinweis. |
| **Texte** | Carousel mit Text-Covern → Sheet mit Vorschau und Übungen ("Verben", "Beliebige Wortart") mit Play-Buttons |
| **Text-Übung** | Fließtext mit Inline-Lücken (5.8) → Tastatur-Zusatzleiste (Icons `文A`, `⇄` links, Button "Antwort anzeigen" rechts; keine Sprungleiste) |
| **Grammatik** | Tabs "Meine Übungen / Fertig" → Zeilenliste direkt auf `--bg` (5.10). Übung: Auswahl-Aufgaben mit Frage & Optionen unten (5.9). |
| **Grammatikhinweise** | Tabs (Anfänger / Mittleres Niveau / Fortgeschrittene) → Themenliste ohne Chevrons (5.10) → helle Erklärungsseite (9) |
| **Wortlisten** | Suchfeld → Wortlisten-Zeilen mit vertikalen Aktions-Icons und A–Z-Sprungleiste → Info-Sheet zum Wort (`--surface`, mit Notizfeld "Füge eigene Notizen hinzu …", Zähler "0 / 1000", ohne Button) |
| **Mein Wissenszentrum** | Große Illustration (zentriert, ca. 300 breit) → 2 Statistik-Karten (3 Zeilen und 1 Zeile) → Info-Sheet ohne Button bei Zeilen-Tap |
| **Konto** | Titel zentriert → Profilzeilen (Icon + Wert) → Liste (Kontoeinstellungen, Abonnement mit rotem Punkt und Wert "Testabo", Hilfe, App bewerten) → Version + Links → Outline-Button "Abmelden" |
| **Einstellungen** | Zeilenliste mit Toggles und Chevron-Werten (Motiv, Benachrichtigungen, Ton aus, Audiogeschwindigkeit, Spracheingabe, Diakritische Zeichen, Nächste Karte automatisch, Grammatiktabellen) |

---

## 7. Interaktion & Zustände

- **Tap-Ziele** mindestens 44 × 44.
- **Sheets** schließen über `✕`, Tipp auf den Scrim oder Wisch nach unten. Sie fahren von unten ein (ca. 250 ms, ease-out), der Scrim blendet dabei ein.
- **Aufklappbare Karten**: Chevron wechselt `⌄` ↔ `⌃`, Inhalt klappt ohne Sprung auf (ca. 200 ms).
- **Antwort-Feedback**: richtig `--success`, falsch `--error` (Rahmen + Icon), danach wahlweise automatisch weiter (Einstellung "Automatisch nächste Karte anzeigen").
- **Leerer Zustand**: Zahl `0` mit normalem Label (z. B. "0 Verfügbare Wiederholungen"), keine eigene Leer-Grafik.
- **Reduzierte Bewegung** respektieren (`prefers-reduced-motion`): Animationen auf Einblenden ohne Bewegung beschränken.
- **Mikrofon-/Spracheingabe** ist optional und per Einstellung schaltbar.

---

## 8. Barrierefreiheit

- Kontrast: Weiß auf `--bg` und `--surface` sowie `--cyan` auf `--surface` erfüllen WCAG AA für normalen Text. `--text-muted` (`#B2B8CB`) nur für Sekundärinformation verwenden. Gedimmte Icons (`--icon-dim`) sind nur dekorativ und tragen keine Bedeutung allein.
- Status nie nur über Farbe zeigen: Richtig/Falsch immer zusätzlich mit Icon, Level immer mit Blitzzahl.
- Alle Icon-Buttons brauchen ein `aria-label` (Deutsch).
- Fokus sichtbar (`--lilac`, 2 px Outline).

---

## 9. Helle Erklärungsseite (Grammatik)

Einzige Seite im hellen Theme (wirkt wie eine eingebettete Web-Ansicht):

- Hintergrund `--light-bg`, Text `--light-text`, englische Wörter Serif `--light-en`.
- Top-Bar: Zurück-Pfeil und zentrierter Titel (`nav-title`) in `--light-text`.
- **Zweispaltige Tabelle**: Spalte 1 englisch (Serif, 18/26), Spalte 2 deutsch (Sans, 18/26), Spalte 2 beginnt bei 63 px, 16 px Seitenrand.
- **Hinweisbox**: Überschrift "Achtung!" (24, 700, zentriert), darunter eine Box mit 1 px `--light-border`, keine Rundung, Padding 16, Aufzählungspunkte. Englische Wörter im Text erscheinen in Serif `--light-en`.

---

## 10. Offene Punkte / Annahmen

- Die Original-Schriften sind nicht bestimmt, die Ersatzschriften aus Abschnitt 2 sind eine Annahme.
- Schriftgrößen sind Schätzwerte (±1–2 pt).
- Der Zwischenzustand "richtig" der Auswahl-Übung ist in den Screenshots nicht zu sehen und aus dem Fehler-Zustand abgeleitet.
- Das Cover-Design (Streifen/Dreiecke) und die Illustrationen sind eigene Assets, die neu entworfen werden müssen.
- Helles Theme der restlichen App: in den Einstellungen gibt es den Punkt "Motiv" (Automatisch, zwei Farbschemata), ein helles Gesamt-Theme ist aber nicht abgebildet. Bis dahin ist nur das dunkle Theme verbindlich.
- **Individuelle Stapel-Icon-Hintergrundfarben**: In `Alle_Stapel_Übersicht.PNG` besitzen die Kacheln der Stapel-Icons jeweils individuelle Hintergrundfarben (z. B. Pink/Magenta `#E0528B`, Türkis/Mint `#00BFA5`, Blau/Teal `#00B894` etc.). Diese sind nicht im Design-Token-Set definiert und sollten als Thema für Stapel-Metadaten oder ein erweitertes Farbsystem geklärt werden, anstatt ad hoc neue Farb-Tokens einzuführen.
- **Farbsemantik der Statuspunkte im Wissenszentrum**: Im Wissenszentrum (`Mein_Wissen_Statistiken.PNG`) ist der Punkt für "Gesamtzahl gelernter Wörter" lila (`--lilac`), während gelernte Wörter im Stapel-Detail-Fortschrittsbalken mit `--success` (Grün) dargestellt werden. Die semantische Farbvergabe sollte vereinheitlicht oder dokumentiert werden.
