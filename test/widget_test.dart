import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/main.dart';

void main() {
  testWidgets('Bottom-Nav zeigt alle 5 Slots', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('nav_0')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_1')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_2')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_3')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_4')), findsOneWidget);
  });

  testWidgets('Tab-Taps wechseln den aktiven Screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Initial: branch 0 (Hauptseite)
    expect(
      tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
      equals(0),
    );

    // Tap Inhalte → branch 1
    await tester.tap(find.byKey(const ValueKey('nav_1')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
      equals(1),
    );

    // Tap Lernen → branch 2
    await tester.tap(find.byKey(const ValueKey('nav_2')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
      equals(2),
    );

    // Tap Fortschritte → branch 3
    await tester.tap(find.byKey(const ValueKey('nav_3')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
      equals(3),
    );

    // Tap Konto → branch 4
    await tester.tap(find.byKey(const ValueKey('nav_4')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
      equals(4),
    );

    // Tap Hauptseite → back to branch 0
    await tester.tap(find.byKey(const ValueKey('nav_0')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<IndexedStack>(find.byType(IndexedStack)).index,
      equals(0),
    );
  });
}
