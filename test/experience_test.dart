import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port/main.dart';

Finder selectableTextContaining(String value) => find.byWidgetPredicate(
  (widget) =>
      widget is SelectableText && (widget.data?.contains(value) ?? false),
);

void main() {
  testWidgets('Flex role appears in English and Hebrew summaries and details', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PortfolioApp());

    await tester.ensureVisible(find.text('Experience'));
    await tester.tap(find.text('Experience'));
    await tester.pumpAndSettle();
    expect(selectableTextContaining('24 June 2026–Present'), findsNWidgets(2));
    expect(selectableTextContaining('handling PCBAs'), findsOneWidget);
    expect(
      selectableTextContaining('configuring program thresholds'),
      findsOneWidget,
    );
    await tester.tap(find.text('TL;DR only'));
    await tester.pumpAndSettle();
    expect(selectableTextContaining('24 June 2026–Present'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('עברית'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('ניסיון'));
    await tester.tap(find.text('ניסיון'));
    await tester.pumpAndSettle();
    expect(selectableTextContaining('24 ביוני 2026–היום'), findsNWidgets(2));
    expect(selectableTextContaining('PCBAs'), findsOneWidget);
    expect(selectableTextContaining('ערכי סף'), findsOneWidget);
    await tester.tap(find.text('בקצרה בלבד'));
    await tester.pumpAndSettle();
    expect(selectableTextContaining('24 ביוני 2026–היום'), findsOneWidget);
  });
}
