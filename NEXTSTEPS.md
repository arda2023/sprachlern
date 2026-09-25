# NEXTSTEPS

## Erledigt
- CLAUDE.md Tech-Stack aktualisiert (Flutter, Dart, Riverpod, go_router, Supabase-Notiz, Befehle)
- Dependencies flutter_riverpod, go_router, google_fonts via flutter pub add hinzugefügt
- lib/theme/app_colors.dart mit allen Tokens aus design.md 1.1–1.5 erstellt
- lib/theme/app_text_styles.dart mit allen 14 Styles aus design.md 2 erstellt
- lib/theme/app_spacing.dart mit Spacing-Skala und Radien aus design.md 3 erstellt

## Geänderte Dateien
- CLAUDE.md, pubspec.yaml, pubspec.lock
- lib/theme/app_colors.dart, lib/theme/app_text_styles.dart, lib/theme/app_spacing.dart
- test/theme_tokens_test.dart

## Testergebnis
- `flutter pub get`: Erfolgreich (Exit-Code 0)
- `flutter analyze`: 0 Issues gefunden
- `flutter test`: Alle Tests bestanden (9/9)

## Abweichungen
- `AppTextStyles`: `static final` statt `static const`, da GoogleFonts-Methodenaufrufe in Dart nicht `const` sein können.

## Offene Probleme
- Keine.
