// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:port/main.dart';

void main() {
  Future<void> pumpPortfolio(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PortfolioApp());
  }

  testWidgets('Portfolio renders key tiles', (tester) async {
    await pumpPortfolio(tester);

    // Verify some expected tiles are present
    expect(find.text('CV'), findsOneWidget);
    expect(find.text('Introduction'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);

    final heroImage = tester.widget<widgets.Image>(
      find.byType(widgets.Image).first,
    );
    expect(
      (heroImage.image as widgets.NetworkImage).url,
      '/images/meformal.png',
    );
    expect(
      tester
          .widget<widgets.AspectRatio>(find.byType(widgets.AspectRatio).first)
          .aspectRatio,
      closeTo(2048 / 1136, 0.001),
    );
  });

  testWidgets('Document tile language options stay on one row', (tester) async {
    await pumpPortfolio(tester);

    await tester.ensureVisible(find.text('CV'));
    await tester.tap(find.text('CV'));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Hebrew'), findsOneWidget);

    await tester.ensureVisible(find.text('Cover Letter'));
    await tester.tap(find.text('Cover Letter'));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsWidgets);
    expect(find.text('Hebrew'), findsWidgets);
  });

  testWidgets('Contact dialog lists both email addresses', (tester) async {
    await pumpPortfolio(tester);

    await tester.ensureVisible(find.text('Contact'));
    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();

    expect(find.text('lubacareer@gmail.com'), findsWidgets);
    expect(find.text('lubani@lubacorp.com'), findsWidgets);
  });

  testWidgets(
    'Projects dialog lists public GitHub repositories for both accounts',
    (tester) async {
      await pumpPortfolio(tester);

      await tester.tap(find.text('Projects'));
      await tester.pumpAndSettle();

      const expectedProjects = [
        'ast2',
        'Mazilon',
        'HeatEquationSimulator',
        'portfolio',
        'ccomp',
        'astro',
        'Portfolio',
        'math',
        'scientificProject',
        'HebSum',
        'MySoftware',
        'DevOps2412',
        'hw6',
        '2412-first-repo2',
        'IRCourse',
        'DeepStefan',
        'DjangoMS',
        'DjangoMSA',
        'Summarizer-Extension',
        'bert-extractive-summarizer',
        'HebrewSumy',
      ];

      for (final project in expectedProjects) {
        expect(find.text(project), findsOneWidget);
      }
    },
  );
}
