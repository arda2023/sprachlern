import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen rendert Mock-Werte und alle Blöcke', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.text('HEUTIGES ZIEL'), findsOneWidget);
    expect(find.text('24 / 50 Karten'), findsOneWidget);
    expect(find.text('Übung starten'), findsOneWidget);
    expect(find.text('MEINE FORTSCHRITTE'), findsOneWidget);
    expect(find.textContaining('93 %'), findsOneWidget);
    expect(find.text('1.456'), findsOneWidget);
    expect(find.text('DERZEITIGE LERNAKTIVITÄT'), findsOneWidget);
    expect(find.text('Alltagswortschatz'), findsOneWidget);

    // Week bar: 7 days with visibly different states (done / open / today).
    expect(find.bySemanticsLabel(RegExp(r', erledigt$')), findsNWidgets(3));
    expect(find.bySemanticsLabel(RegExp(r', offen$')), findsNWidgets(3));
    expect(find.bySemanticsLabel(RegExp(r', heute$')), findsOneWidget);
  });
}
