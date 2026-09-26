import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/main.dart';
import 'package:sprachlern/providers/auth_provider.dart';

import 'helpers/fake_auth_service.dart';

/// The app now sends signed-out users to /login, so these shell tests run
/// with a signed-in fake session.
Widget _signedInApp() => ProviderScope(
  overrides: [
    authServiceProvider.overrideWithValue(FakeAuthService(signedIn: true)),
  ],
  child: const MyApp(),
);

void main() {
  testWidgets('Bottom-Nav zeigt alle 5 Slots', (WidgetTester tester) async {
    await tester.pumpWidget(_signedInApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('nav_0')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_1')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_2')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_3')), findsOneWidget);
    expect(find.byKey(const ValueKey('nav_4')), findsOneWidget);
  });

  testWidgets('Lernen-Label ist sichtbar und nicht verdeckt', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_signedInApp());
    await tester.pumpAndSettle();

    expect(find.text('Lernen'), findsOneWidget);

    // Label must sit clear of the ring (diameter 73, centred on the bar edge).
    final label = tester.getRect(find.text('Lernen'));
    final ring = tester.getRect(find.byKey(const ValueKey('nav_ring')));
    expect(label.top, greaterThanOrEqualTo(ring.bottom));

    // Same baseline as the other four tab labels.
    expect(label.top, equals(tester.getRect(find.text('Inhalte')).top));
  });

  testWidgets('Tab-Taps wechseln den aktiven Screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_signedInApp());
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
