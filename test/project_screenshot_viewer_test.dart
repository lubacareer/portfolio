import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port/main.dart';

Future<void> openProject(
  WidgetTester tester,
  PortfolioLanguage language, {
  Size size = const Size(320, 720),
  AssetBundle? bundle,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  const project = PortfolioProject(
    owner: 'lubacareer',
    name: 'HeatEquationSimulator',
    githubUrl: 'https://github.com/lubacareer/HeatEquationSimulator',
  );
  final app = MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showProjectDetails(context, language, project),
          child: const Text('Open project'),
        ),
      ),
    ),
  );
  await tester.pumpWidget(
    bundle == null ? app : DefaultAssetBundle(bundle: bundle, child: app),
  );
  if (bundle == null) {
    final context = tester.element(find.byType(Scaffold));
    final size = await tester.runAsync(() async {
      const image = AssetImage('web/images/projects/magnetic-torus.jpg');
      await precacheImage(image, context);
      final dimensions = Completer<Size>();
      final stream = image.resolve(createLocalImageConfiguration(context));
      late final ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, _) {
          dimensions.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()),
          );
          info.dispose();
        },
        onError: (Object error, StackTrace? stack) =>
            dimensions.completeError(error, stack),
      );
      stream.addListener(listener);
      final result = await dimensions.future;
      stream.removeListener(listener);
      return result;
    });
    expect(size, const Size(1280, 720));
  }
  await tester.tap(find.text('Open project'));
  await tester.pumpAndSettle();
}

class ControlledImageBundle extends CachingAssetBundle {
  final completer = Completer<ByteData>();

  @override
  Future<ByteData> load(String key) =>
      key == 'web/images/projects/magnetic-torus.jpg'
      ? completer.future
      : rootBundle.load(key);
}

/// The source image is 1280 × 720; check the rendered pixels rather than the
/// transparent, viewport-sized child used by InteractiveViewer.
void expectImageInBounds(WidgetTester tester) {
  final viewer = find.byType(InteractiveViewer);
  final viewport = tester.getSize(viewer);
  final controller = tester
      .widget<InteractiveViewer>(viewer)
      .transformationController!;
  final fitted = applyBoxFit(
    BoxFit.contain,
    const Size(1280, 720),
    viewport,
  ).destination;
  final rect = Alignment.center.inscribe(fitted, Offset.zero & viewport);
  final painted = MatrixUtils.transformRect(controller.value, rect);
  const tolerance = 0.1;
  if (painted.width <= viewport.width + tolerance) {
    expect(painted.center.dx, closeTo(viewport.width / 2, tolerance));
  } else {
    expect(painted.left, lessThanOrEqualTo(tolerance));
    expect(painted.right, greaterThanOrEqualTo(viewport.width - tolerance));
  }
  if (painted.height <= viewport.height + tolerance) {
    expect(painted.center.dy, closeTo(viewport.height / 2, tolerance));
  } else {
    expect(painted.top, lessThanOrEqualTo(tolerance));
    expect(painted.bottom, greaterThanOrEqualTo(viewport.height - tolerance));
  }
}

Future<void> openViewer(
  WidgetTester tester,
  String label, {
  bool loading = false,
}) async {
  await tester.ensureVisible(find.text(label));
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
  if (!loading) {
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.text('Loading screenshot…'), findsNothing);
  }
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

  for (final size in [const Size(320, 720), const Size(1000, 620)]) {
    testWidgets('Image remains visible during zoom and pan at $size', (
      tester,
    ) async {
      await openProject(tester, PortfolioLanguage.english, size: size);
      await openViewer(tester, 'Enlarge screenshot');
      expectImageInBounds(tester);

      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byTooltip('Zoom in'));
        await tester.pumpAndSettle();
        expectImageInBounds(tester);
      }
      await tester.tap(find.byTooltip('Reset zoom'));
      await tester.pumpAndSettle();
      final center = tester.getCenter(find.byType(InteractiveViewer));
      final first = await tester.startGesture(
        center + const Offset(-30, 0),
        pointer: 1,
      );
      final second = await tester.startGesture(
        center + const Offset(30, 0),
        pointer: 2,
      );
      await first.moveTo(center + const Offset(-80, 0));
      await second.moveTo(center + const Offset(80, 0));
      await tester.pump();
      final controller = tester
          .widget<InteractiveViewer>(find.byType(InteractiveViewer))
          .transformationController!;
      expect(controller.value.getMaxScaleOnAxis(), greaterThan(1));
      expectImageInBounds(tester);
      await first.up();
      await second.up();
      await tester.pumpAndSettle();
      expectImageInBounds(tester);
      for (final direction in [
        'Move image left',
        'Move image up',
        'Move image right',
        'Move image down',
      ]) {
        for (var i = 0; i < 15; i++) {
          await tester.tap(find.byTooltip(direction));
          await tester.pump();
          expectImageInBounds(tester);
        }
      }

      // A fling exercises InteractiveViewer's inertia after the pointer lifts.
      await tester.fling(
        find.byType(InteractiveViewer),
        const Offset(-180, -150),
        1400,
      );
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        expectImageInBounds(tester);
      }
      await tester.pumpAndSettle();
      expectImageInBounds(tester);

      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byTooltip('Zoom out'));
        await tester.pumpAndSettle();
        expectImageInBounds(tester);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Resizing the viewport keeps a zoomed image in bounds', (
    tester,
  ) async {
    await openProject(tester, PortfolioLanguage.english);
    await openViewer(tester, 'Enlarge screenshot');
    await tester.tap(find.byTooltip('Zoom in'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Zoom in'));
    await tester.pumpAndSettle();
    await tester.fling(
      find.byType(InteractiveViewer),
      const Offset(-160, -120),
      1000,
    );
    await tester.pumpAndSettle();
    expectImageInBounds(tester);

    tester.view.physicalSize = const Size(1000, 620);
    await tester.pumpAndSettle();
    expectImageInBounds(tester);
    tester.view.physicalSize = const Size(320, 720);
    await tester.pumpAndSettle();
    expectImageInBounds(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Image loading and failure are visible in both languages', (
    tester,
  ) async {
    // Clear the cached image between languages so both exercise the bundle.
    for (final language in [
      PortfolioLanguage.english,
      PortfolioLanguage.hebrew,
    ]) {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      final bundle = ControlledImageBundle();
      await openProject(tester, language, bundle: bundle);
      final hebrew = language == PortfolioLanguage.hebrew;
      await openViewer(
        tester,
        hebrew ? 'הגדלת צילום המסך' : 'Enlarge screenshot',
        loading: true,
      );
      final loading = find.text(
        hebrew ? 'טוען צילום מסך…' : 'Loading screenshot…',
      );
      expect(loading, findsOneWidget);
      final zoom = find.byTooltip(hebrew ? 'הגדלה' : 'Zoom in');
      final zoomButton = find.ancestor(
        of: zoom,
        matching: find.byType(IconButton),
      );
      expect(tester.widget<IconButton>(zoomButton).onPressed, isNull);
      if (hebrew) {
        expect(Directionality.of(tester.element(loading)), TextDirection.rtl);
      }
      bundle.completer.completeError(StateError('Image unavailable'));
      await tester.pumpAndSettle();
      final failure = find.text(
        hebrew ? 'לא ניתן לטעון את צילום המסך.' : 'Unable to load screenshot.',
      );
      expect(failure, findsOneWidget);
      expect(tester.widget<IconButton>(zoomButton).onPressed, isNull);
      if (hebrew) {
        expect(Directionality.of(tester.element(failure)), TextDirection.rtl);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });

  testWidgets(
    'Closing before an image resolves does not update a disposed viewer',
    (tester) async {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
      final imageBytes = await rootBundle.load(
        'web/images/projects/magnetic-torus.jpg',
      );
      final bundle = ControlledImageBundle();
      await openProject(tester, PortfolioLanguage.english, bundle: bundle);
      await tester.ensureVisible(find.text('Enlarge screenshot'));
      await tester.tap(find.text('Enlarge screenshot'));
      await tester.pumpAndSettle();
      expect(find.text('Loading screenshot…'), findsOneWidget);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      bundle.completer.complete(imageBytes);
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
