import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port/github_repositories.dart';
import 'package:port/main.dart';
import 'package:port/project_media.dart';

GitHubRepository repository(String owner, String name) => GitHubRepository(
  name: name,
  htmlUrl: 'https://github.com/$owner/$name',
  isFork: false,
);

Future<void> pumpPortfolio(
  WidgetTester tester,
  GitHubRepositoryLoader loader,
) async {
  tester.view.physicalSize = const Size(1400, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(PortfolioApp(loadGitHubRepositories: loader));
  await tester.pumpAndSettle();
}

Finder projectButton(String owner) =>
    find.ancestor(of: find.text(owner), matching: find.byType(OutlinedButton));

Finder get detailsDialog => find.byType(AlertDialog).last;

Finder inDetails(Finder finder) =>
    find.descendant(of: detailsDialog, matching: finder);

Finder get torusScreenshot => find.byWidgetPredicate(
  (widget) =>
      widget is Image &&
      widget.image is AssetImage &&
      (widget.image as AssetImage).assetName ==
          'web/images/projects/magnetic-torus.jpg',
);

void main() {
  test('Video metadata is matched by owner and repository, ignoring case', () {
    final media = mediaForProject('LUBACAREER', 'heatequationsimulator');
    expect(media?.videos.map((video) => video.id), [
      'dOgUwgH-XtE',
      'QYacq8NXiZY',
    ]);
    expect(media?.videos.map((video) => video.watchUrl), [
      'https://www.youtube.com/watch?v=dOgUwgH-XtE',
      'https://www.youtube.com/watch?v=QYacq8NXiZY',
    ]);
    expect(
      media?.screenshots.single.asset,
      'web/images/projects/magnetic-torus.jpg',
    );
    expect(mediaForProject('lubani', 'HeatEquationSimulator'), isNull);
    expect(mediaForProject('lubacareer', 'UncuratedProject'), isNull);
    expect(
      mediaForProject('LUBACAREER', 'cml')?.screenshots.single.asset,
      'web/images/projects/cml-interface.webp',
    );
    expect(mediaForProject('lubani', 'CML'), isNull);
    expect(
      mediaForProject('lubacareer', 'Nasa2')?.screenshots.single.asset,
      'web/images/projects/nasa2-synthetic-preview.png',
    );
    expect(
      mediaForProject('lubacareer', 'spritebury')?.screenshots.single.asset,
      'web/images/projects/spritebury-interface.webp',
    );
    for (final name in [
      'electricity',
      'jupiter',
      'finance1',
      'nasaCLPS-releases',
    ]) {
      expect(mediaForProject('LUBACAREER', name)?.screenshots, hasLength(1));
      expect(mediaForProject('lubani', name), isNull);
    }
  });

  testWidgets('Live results show videos only for the matching owner', (
    tester,
  ) async {
    await pumpPortfolio(
      tester,
      (owner) async => [repository(owner, 'HeatEquationSimulator')],
    );
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(projectButton('lubacareer'));
    await tester.tap(projectButton('lubacareer'));
    await tester.pumpAndSettle();

    expect(
      await rootBundle.load('web/images/projects/magnetic-torus.jpg'),
      isNotNull,
    );
    expect(inDetails(torusScreenshot), findsOneWidget);
    expect(
      inDetails(find.text('Magnetic torus simulation demonstrations')),
      findsOneWidget,
    );
    expect(inDetails(find.text('Load video')), findsNWidgets(2));
    expect(inDetails(find.text('Watch on YouTube')), findsNWidgets(2));
    expect(
      find.byKey(const ValueKey('youtube-player-dOgUwgH-XtE')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('youtube-player-QYacq8NXiZY')),
      findsNothing,
    );

    await tester.ensureVisible(inDetails(find.text('Load video')).first);
    await tester.tap(inDetails(find.text('Load video')).first);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('youtube-player-dOgUwgH-XtE')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('youtube-player-QYacq8NXiZY')),
      findsNothing,
    );

    await tester.tap(inDetails(find.text('Close')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(projectButton('lubani'));
    await tester.tap(projectButton('lubani'));
    await tester.pumpAndSettle();
    expect(
      inDetails(find.text('Magnetic torus simulation demonstrations')),
      findsNothing,
    );
    expect(inDetails(find.text('Load video')), findsNothing);
    expect(inDetails(torusScreenshot), findsNothing);
  });

  testWidgets('Saved fallback and retried results retain the videos', (
    tester,
  ) async {
    var attempts = 0;
    await pumpPortfolio(tester, (owner) async {
      if (owner == 'lubani') return [];
      attempts++;
      if (attempts == 1) throw Exception('offline');
      return [repository(owner, 'HeatEquationSimulator')];
    });
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not load repositories. Showing saved projects.'),
      findsOneWidget,
    );

    Finder heatButton() => find.ancestor(
      of: find.text('HeatEquationSimulator'),
      matching: find.byType(OutlinedButton),
    );

    await tester.ensureVisible(heatButton());
    await tester.tap(heatButton());
    await tester.pumpAndSettle();
    expect(inDetails(torusScreenshot), findsOneWidget);
    expect(inDetails(find.text('Load video')), findsNWidgets(2));
    await tester.tap(inDetails(find.text('Close')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Retry'));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    await tester.ensureVisible(heatButton());
    await tester.tap(heatButton());
    await tester.pumpAndSettle();
    expect(inDetails(torusScreenshot), findsOneWidget);
    expect(inDetails(find.text('Load video')), findsNWidgets(2));
  });

  testWidgets('Video controls are localized and right-to-left in Hebrew', (
    tester,
  ) async {
    await pumpPortfolio(
      tester,
      (owner) async => owner == 'lubacareer'
          ? [repository(owner, 'HeatEquationSimulator')]
          : [],
    );
    await tester.tap(find.text('עברית'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('פרויקטים'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(projectButton('lubacareer'));
    await tester.tap(projectButton('lubacareer'));
    await tester.pumpAndSettle();

    final heading = inDetails(find.text('הדגמות סימולציה של טורוס מגנטי'));
    expect(heading, findsOneWidget);
    expect(Directionality.of(tester.element(heading)), TextDirection.rtl);
    expect(
      tester.widget<Image>(inDetails(torusScreenshot)).semanticLabel,
      'ממשק סימולטור טורוס מגנטי וההדמיות',
    );
    expect(inDetails(find.text('טעינת סרטון')), findsNWidgets(2));
    expect(inDetails(find.text('צפייה ב-YouTube')), findsNWidgets(2));
  });

  testWidgets('Video controls remain available in a narrow mobile dialog', (
    tester,
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
              onPressed: () => showProjectDetails(
                context,
                PortfolioLanguage.english,
                project,
              ),
              child: const Text('Open project'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open project'));
    await tester.pumpAndSettle();

    expect(find.text('Load video'), findsNWidgets(2));
    expect(find.text('Watch on YouTube'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
