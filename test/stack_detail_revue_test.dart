import 'dart:async';

import 'package:sprachlern/models/content_data.dart';
import 'package:sprachlern/providers/content_provider.dart';

import 'helpers/stack_fixtures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sprachlern/screens/stack_detail_screen.dart';
import 'package:sprachlern/screens/stack_list_screen.dart';
import 'package:sprachlern/screens/stack_revue_screen.dart';
import 'package:sprachlern/widgets/recent_words_card.dart';
import 'package:sprachlern/widgets/revue_stack_row.dart';
import 'package:sprachlern/widgets/stack_status_bar.dart';

Widget _app(Widget home) => ProviderScope(
  overrides: [
    stackListProvider.overrideWith((ref) async => fixtureStacks),
    stackDetailsProvider.overrideWith((ref, id) async => fixtureDetails[id]),
  ],
  child: MaterialApp(home: home),
);

void main() {
  testWidgets('Stapeldetail zeigt Laden und anschließend Fehler', (
    tester,
  ) async {
    final pending = Completer<StackDetailData?>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stackDetailsProvider.overrideWith((ref, id) => pending.future),
        ],
        child: const MaterialApp(home: StackDetailScreen(stackId: 'test')),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.completeError(StateError('fake query failure'));
    await tester.pumpAndSettle();
    expect(find.text('Stapel konnte nicht geladen werden.'), findsOneWidget);
  });

  testWidgets('Unbekannter Stapel zeigt Hinweis', (tester) async {
    await tester.pumpWidget(_app(const StackDetailScreen(stackId: 'unknown')));
    await tester.pumpAndSettle();
    expect(find.text('Dieser Stapel ist nicht verfügbar.'), findsOneWidget);
  });

  testWidgets(
    'Detailscreen zeigt Niveau ohne Fortschritt und klappt Wortliste auf und zu',
    (tester) async {
      tester.view.physicalSize = const Size(375, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _app(const StackDetailScreen(stackId: 'reisen-und-alltag')),
      );
      await tester.pumpAndSettle();

      // Data comes from the provider, not from the widget.
      expect(find.text('Reisen und Alltag'), findsOneWidget);
      expect(find.byType(StackStatusBar), findsNothing);
      expect(find.text('41 von 126 neuen Wörtern'), findsNothing);
      expect(find.text('28 Wörter gelernt'), findsNothing);
      expect(find.text('Mittleres Niveau'), findsOneWidget);
      expect(find.byKey(const ValueKey('stack_detail_progress')), findsNothing);
      expect(find.byType(RecentWordsCard), findsOneWidget);

      // Collapsed by default.
      expect(find.text('Gepäck'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('recent_words_toggle')));
      await tester.pumpAndSettle();

      // All five mock entries, each with its three lines.
      expect(find.text('Gepäck'), findsOneWidget);
      expect(
        find.text('Mein Gepäck ist noch nicht angekommen.'),
        findsOneWidget,
      );
      expect(find.text('My luggage has not arrived yet.'), findsOneWidget);
      expect(find.text('umsteigen'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('recent_words_toggle')));
      await tester.pumpAndSettle();
      expect(find.text('Gepäck'), findsNothing);
    },
  );

  testWidgets('Revue zeigt Info-Karte und Zeilen mit leerem Track', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(const StackRevueScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('revue_info_card')), findsOneWidget);
    expect(find.byType(RevueStackRow), findsNWidgets(3));
    expect(
      find.byKey(const ValueKey('revue_track_reisen-und-alltag')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('revue_play_reisen-und-alltag')),
      findsOneWidget,
    );

    // Revue rows never show a learned/seen fill, unlike the stack list.
    expect(
      find.byKey(const ValueKey('stack_progress_Reisen und Alltag')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('revue_info_dismiss')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('revue_info_card')), findsNothing);
  });

  testWidgets('Tap auf Stapel öffnet passendes Detail', (tester) async {
    tester.view.physicalSize = const Size(375, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/stacks',
      routes: [
        GoRoute(
          path: '/stacks',
          builder: (_, _) => const StackListScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (_, state) =>
                  StackDetailScreen(stackId: state.pathParameters['id']!),
            ),
          ],
        ),
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
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('stack_item_arbeit-und-termine')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Arbeit und Termine'), findsOneWidget);
    expect(find.text('Fortgeschritten'), findsOneWidget);
    expect(find.text('16 von 40 neuen Wörtern'), findsNothing);
  });
}
