# NEXTSTEPS – Inkrement: Startseite

## Erledigt
- Startseite komplett aus Mock-Provider (`homeProvider`, `Provider<HomeData>`), keine Werte im Screen hartcodiert.
- Reihenfolge: Header, HEUTIGES ZIEL + Wochenleiste, Promo-Carousel, MEINE FORTSCHRITTE (breite Karte + 2 Kompaktkarten), DERZEITIGE LERNAKTIVITÄT.
- Wochenleiste: 3 erledigt (Häkchen), 3 offen, 1 heute (surface-3-Kachel am Label).
- `ProviderScope` in `main()` ergänzt.

## Geänderte / neue Dateien
- Neu: `lib/models/home_data.dart`, `lib/providers/home_provider.dart`, `lib/utils/german_number.dart`, `lib/widgets/{home_header,goal_card,promo_card,progress_stat_card,compact_stat_card,section_header,activity_card}.dart`, `test/home_screen_test.dart`
- Geändert: `lib/screens/home_screen.dart`, `lib/main.dart`, `test/widget_test.dart` (pumpt jetzt `ProviderScope(child: MyApp())`)

## Testergebnis
- `flutter analyze`: No issues found.
- `flutter test`: 11/11 bestanden (Home-Test bei 375×812; prüft "24 / 50", "1.456", "93 %", Wochenleisten-Zustände).

## Abweichungen
- Flaggen-Rand: design.md nennt `#3A475F` (kein Token). Verwendet: `AppColors.surface3` (`#3B3F58`). Flagge = `surface2`-Platzhalter.
- Zusätzliche, nicht gelistete Dateien: `section_header.dart`, `activity_card.dart` (Wiederverwendung statt Duplikat), `german_number.dart`.
- Aktivitätskarten zeigen zusätzlich Icon-Kachel (40×40, `surface2`) statt reiner Textzeile (angelehnt an 5.10).
- Fortschrittskarte hat natürliche Höhe (Padding 16); die 75 px in 5.6 reichen für Titel + Text + Balken + Padding nicht aus.

## Offene Probleme
- Nicht im Simulator/Browser gegen Screenshots geprüft; Tests laufen mit Ahem-Fallbackschrift, echte Figtree-Umbrüche ungeprüft.
- design.md 5.6/Abschnitt 2: "1433" ohne, "1.456" mit Tausenderpunkt; wörtlich übernommen, bitte klären.
- Bell/Zahnrad/✕/"Ziel ändern"/"Übung starten" sind inert; Icons sind Material-Outlined, keine Akzentfüllungen.
- Inhaltsbreite nicht auf 480 px begrenzt (App-Shell-Thema).
