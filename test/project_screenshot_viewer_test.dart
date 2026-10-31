import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port/main.dart';

Future<void> openProject(
  WidgetTester tester,
  PortfolioLanguage language,
) async {
  tester.view.physicalSize = const Size(320, 720);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  const project = PortfolioProject(
    owner: 'lubacareer',
    name: 'HeatEquationSimulator',
    githubUrl: 'https://github.com/lubacareer/HeatEquationSimulator',
  );
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showProjectDetails(context, language, project),
            child: const Text('Open project'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open project'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Screenshot viewer zooms, pans and returns to project details', (
    tester,
  ) async {
    await openProject(tester, PortfolioLanguage.english);
    await tester.ensureVisible(find.text('Enlarge screenshot'));
    await tester.tap(find.text('Enlarge screenshot'));
    await tester.pumpAndSettle();

    final viewer = find.byType(InteractiveViewer);
    expect(viewer, findsOneWidget);
    final controller = tester
        .widget<InteractiveViewer>(viewer)
        .transformationController!;
    expect(controller.value.getMaxScaleOnAxis(), 1);
    await tester.tap(find.byTooltip('Zoom in'));
    await tester.pumpAndSettle();
    expect(controller.value.getMaxScaleOnAxis(), 1.5);
    final originalX = controller.value.storage[12];
    await tester.tap(find.byTooltip('Move image left'));
    await tester.pumpAndSettle();
    expect(controller.value.storage[12], lessThan(originalX));
    await tester.tap(find.byTooltip('Reset zoom'));
    await tester.pumpAndSettle();
    expect(controller.value.getMaxScaleOnAxis(), 1);
    expect(controller.value.storage[12], 0);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(viewer, findsNothing);
    expect(find.text('Enlarge screenshot'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Screenshot viewer controls are localized and RTL in Hebrew', (
    tester,
  ) async {
    await openProject(tester, PortfolioLanguage.hebrew);
    await tester.ensureVisible(find.text('הגדלת צילום המסך'));
    await tester.tap(find.text('הגדלת צילום המסך'));
    await tester.pumpAndSettle();
    final zoom = find.byTooltip('הגדלה');
    expect(zoom, findsOneWidget);
    expect(Directionality.of(tester.element(zoom)), TextDirection.rtl);
    expect(find.byTooltip('הזזת התמונה שמאלה'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
