# NEXTSTEPS – Token- und Designanpassungen

## Erledigt
- Token `AppColors.flagBorder` (`#3A475F`) hinzugefügt und in `HomeHeader` eingesetzt.
- `ProgressStatCard` formatiert `wordsBase` mit Tausenderpunkt (`93 % von 1.433`).
- Intrinsische Höhe von `ProgressStatCard` verifiziert (kein Overflow).
- Tests in `theme_tokens_test.dart` und `home_screen_test.dart` aktualisiert.

## Geänderte Dateien
- `lib/theme/app_colors.dart`
- `lib/widgets/home_header.dart`
- `lib/widgets/progress_stat_card.dart`
- `test/theme_tokens_test.dart`
- `test/home_screen_test.dart`

## Testergebnis
- `flutter analyze`: No issues found.
- `flutter test`: 11/11 bestanden.

## Abweichungen
- Keine.

## Offene Probleme
- Keine.
