import 'dart:async';

import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/providers/content_provider.dart';

import 'helpers/stack_fixtures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/screens/content_screen.dart';
import 'package:sprachlern/screens/stack_list_screen.dart';
import 'package:sprachlern/theme/app_colors.dart';
import 'package:sprachlern/widgets/content_tile.dart';
import 'package:sprachlern/widgets/stack_list_item.dart';

void main() {
  testWidgets('Stapelliste zeigt Laden und anschließend Fehler', (
    tester,
  ) async {
    final pending = Completer<List<VocabularyStackData>>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stackListProvider.overrideWith((ref) => pending.future)],
        child: const MaterialApp(home: StackListScreen()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.completeError(StateError('fake query failure'));
    await tester.pumpAndSettle();
    expect(find.text('Stapel konnten nicht geladen werden.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Inhalte zeigt beide Kachelsektionen mit Periwinkle-Icons', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stackListProvider.overrideWith((ref) async => fixtureStacks),
          stackDetailsProvider.overrideWith(
            (ref, id) async => fixtureDetails[id],
          ),
        ],
        child: const MaterialApp(home: ContentScreen()),
      ),
    );

    expect(find.text('STAPEL'), findsOneWidget);
    expect(find.text('ÜBUNGSAUFGABEN'), findsOneWidget);
    expect(find.byType(ContentTile), findsNWidgets(9));

    final icons = tester.widgetList<Icon>(
      find.descendant(
        of: find.byType(ContentTile),
        matching: find.byType(Icon),
      ),
    );
    expect(icons, hasLength(9));
    expect(icons.every((icon) => icon.color == AppColors.periwinkle), isTrue);
  });

  testWidgets('Stapel-Kachel öffnet Liste ohne Fortschritt', (tester) async {
    final router = GoRouter(
      initialLocation: '/content',
      routes: [
        GoRoute(path: '/content', builder: (_, _) => const ContentScreen()),
        GoRoute(path: '/stacks', builder: (_, _) => const StackListScreen()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stackListProvider.overrideWith((ref) async => fixtureStacks),
          stackDetailsProvider.overrideWith(
            (ref, id) async => fixtureDetails[id],
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('content_tile_Stapel')));
    await tester.pumpAndSettle();

    expect(find.text('DEINE STAPEL'), findsOneWidget);
    expect(find.byType(StackListItem), findsNWidgets(3));
    expect(
      find.byKey(const ValueKey('stack_progress_Reisen und Alltag')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('stack_progress_Nützliche Gespräche')),
      findsNothing,
    );
  });
}
