import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port/main.dart';

const featuredProjects = <(String, String)>[
  ('HeatEquationSimulator', 'lubacareer'),
  ('jupiter', 'lubacareer'),
  ('Nasa2', 'lubacareer'),
  ('nasaCLPS-releases', 'lubacareer'),
  ('CML', 'lubacareer'),
  ('electricity', 'lubacareer'),
];

Future<void> showPortfolio(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const PortfolioApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Highlights open the correct projects and omit HebrewSumy', (
    tester,
  ) async {
    await showPortfolio(tester, const Size(1400, 1000));

    for (final (name, owner) in featuredProjects) {
      final title = find.text(name);
      expect(title, findsOneWidget);
      await tester.ensureVisible(title);
      await tester.tap(title);
      await tester.pumpAndSettle();

      final dialog = find.byType(AlertDialog);
      expect(
        find.descendant(of: dialog, matching: find.text(name)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.textContaining(owner)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.text('View on GitHub')),
        findsOneWidget,
      );
      await tester.tap(
        find.descendant(of: dialog, matching: find.text('Close')),
      );
      await tester.pumpAndSettle();
    }
    expect(find.text('HebrewSumy'), findsNothing);
    expect(find.text('scientificProject'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Highlights fit a narrow screen and remain RTL in Hebrew', (
    tester,
  ) async {
    await showPortfolio(tester, const Size(390, 844));
    await tester.tap(find.text('עברית').first);
    await tester.pumpAndSettle();

    for (final (name, _) in featuredProjects) {
      final title = find.text(name);
      expect(title, findsOneWidget);
      await tester.ensureVisible(title);
      expect(Directionality.of(tester.element(title)), TextDirection.rtl);
      expect(tester.takeException(), isNull);
    }
    expect(find.text('HebrewSumy'), findsNothing);
    expect(find.text('scientificProject'), findsNothing);
    await tester.ensureVisible(find.text('HeatEquationSimulator'));
    await tester.tap(find.text('HeatEquationSimulator'));
    await tester.pumpAndSettle();
    final dialog = find.byType(AlertDialog);
    final metadata = find.descendant(
      of: dialog,
      matching: find.textContaining('lubacareer'),
    );
    expect(metadata, findsOneWidget);
    expect(Directionality.of(tester.element(metadata)), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });
}
