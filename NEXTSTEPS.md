# NEXTSTEPS – Stapel-Detail & Stapel-Revue

## Erledigt
- `StackDetailScreen` (design.md 5.17, 6) mit `StackStatusBar`, `RecentWordsCard` & `_LearnToggleCard` erstellt.
- `StackRevueScreen` (design.md 5.10, 6) mit `_InfoCard` & `RevueStackRow` (leerer Track) erstellt.
- Routing via `app_router.dart` (/stacks/:id & /stack-revue) und Navigation aus `StackListScreen` & `ContentScreen` angebunden.
- 3 Tests in `test/stack_detail_revue_test.dart` hinzugefügt.

## Geänderte / neue Dateien
- Neu: `lib/screens/stack_detail_screen.dart`, `lib/screens/stack_revue_screen.dart`, `lib/widgets/stack_status_bar.dart`, `lib/widgets/recent_words_card.dart`, `lib/widgets/revue_stack_row.dart`, `test/stack_detail_revue_test.dart`
- Geändert: `lib/models/content_data.dart`, `lib/providers/content_provider.dart`, `lib/router/app_router.dart`, `lib/screens/stack_list_screen.dart`, `lib/screens/content_screen.dart`

## Testergebnis
- `flutter analyze`: No issues found.
- `flutter test`: 19/19 bestanden.

## Abweichungen
- Primär-Button "Lerne mit diesem Stapel" navigiert zu `/exercise`.
- Scroll-verknüpfter Top-Bar-Titel im Detail-Screen zurückgestellt.

## Offene Probleme
- Keine.
