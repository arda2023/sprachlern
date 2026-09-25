import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprachlern/screens/home_screen.dart';
import 'package:sprachlern/theme/app_colors.dart';

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
    expect(find.text('93 % von 1.433'), findsOneWidget);
    expect(find.text('1.456'), findsOneWidget);
    expect(find.text('DERZEITIGE LERNAKTIVITÄT'), findsOneWidget);
    expect(find.text('Alltagswortschatz'), findsOneWidget);

    // Verify flag tile uses AppColors.flagBorder
    final flagBorderContainer = tester.widget<Container>(
      find.descendant(
        of: find.byType(HomeScreen),
        matching: find.byWidgetPredicate((widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).border ==
                Border.all(color: AppColors.flagBorder)),
      ),
    );
    expect(flagBorderContainer, isNotNull);

    // Week bar: 7 days with visibly different states (done / open / today).
    expect(find.bySemanticsLabel(RegExp(r', erledigt$')), findsNWidgets(3));
    expect(find.bySemanticsLabel(RegExp(r', offen$')), findsNWidgets(3));
    expect(find.bySemanticsLabel(RegExp(r', heute$')), findsOneWidget);
  });
}
