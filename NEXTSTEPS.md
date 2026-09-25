# NEXTSTEPS – Grammatikübung und Inhalte

## Erledigt
- Grammatik-Auswahlübung mit Feedback für richtige und falsche Auswahl umgesetzt.
- Inhalte-Übersicht mit 2 Stapel- und 7 Übungs-Kacheln umgesetzt.
- Markenneutrale Stapelliste mit begonnenen und unbegonnenen Stapeln umgesetzt.
- Routen `/grammar-exercise` und `/stacks` sowie Widget-Tests ergänzt.

## Geänderte Dateien
- `lib/models/grammar_exercise_data.dart`, `lib/providers/grammar_exercise_provider.dart`
- `lib/screens/grammar_exercise_screen.dart`, `lib/widgets/grammar_answer_option.dart`
- `lib/models/content_data.dart`, `lib/providers/content_provider.dart`
- `lib/screens/content_screen.dart`, `lib/screens/stack_list_screen.dart`
- `lib/widgets/content_tile.dart`, `lib/widgets/stack_list_item.dart`, `lib/router/app_router.dart`
- `test/grammar_exercise_screen_test.dart`, `test/content_stack_screens_test.dart`, `NEXTSTEPS.md`

## Testergebnis
- `flutter analyze`: No issues found.
- `flutter test`: 16 Tests bestanden.

## Abweichungen
- Die Grammatikübung nutzt einen eigenen Kopf, weil sie ✕, Glühbirne und einen 2-px-Balken statt der Vokabel-Top-Bar benötigt.
- Inhalte-Kacheln verwenden Radius 8 gemäß der Regel für kleine Karten; alle Kachel- und Stapel-Icons nutzen `AppColors.periwinkle`.
- Die markenfreie Stapel-Sektion heißt „DEINE STAPEL“ statt „LINGVIST-STAPEL“.

## Offene Probleme
- Keine visuelle Prüfung im Simulator oder Browser durchgeführt.
