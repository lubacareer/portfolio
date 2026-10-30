import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port/github_repositories.dart';
import 'package:port/main.dart';

const projects = <String, List<String>>{
  'lubacareer': [
    'ccomp',
    'CML',
    'electricity',
    'finance1',
    'HeatEquationSimulator',
    'jupiter',
    'Nasa2',
    'nasaCLPS-releases',
    'portfolio',
    'spritebury',
  ],
  'lubani': [
    '2412-first-repo2',
    'astro',
    'bert-extractive-summarizer',
    'DeepStefan',
    'DevOps2412',
    'DjangoMS',
    'DjangoMSA',
    'HebrewSumy',
    'HebSum',
    'hw6',
    'IRCourse',
    'math',
    'MySoftware',
    'Portfolio',
    'scientificProject',
    'Summarizer-Extension',
  ],
};

const apiDescription = 'Description supplied by the GitHub API';

Future<List<GitHubRepository>> loadProjects(String owner) async {
  return [
    for (final name in projects[owner]!)
      GitHubRepository(
        name: name,
        htmlUrl: 'https://github.com/$owner/$name',
        description: apiDescription,
        isFork: name == 'bert-extractive-summarizer' || name == 'DeepStefan',
      ),
    if (owner == 'lubacareer')
      const GitHubRepository(
        name: 'FutureProject',
        htmlUrl: 'https://github.com/lubacareer/FutureProject',
        description: apiDescription,
        isFork: false,
      ),
  ];
}

Finder projectCard(String name) =>
    find.ancestor(of: find.text(name), matching: find.byType(OutlinedButton));

void main() {
  testWidgets('Every current project has a bilingual curated description', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const PortfolioApp(loadGitHubRepositories: loadProjects),
    );

    Future<void> verifyProjects({required bool hebrew}) async {
      await tester.tap(find.text(hebrew ? 'פרויקטים' : 'Projects'));
      await tester.pumpAndSettle();

      for (final entry in projects.entries) {
        for (final name in entry.value) {
          final card = projectCard(name);
          expect(card, findsOneWidget, reason: '${entry.key}/$name');
          final texts = tester
              .widgetList<Text>(
                find.descendant(of: card, matching: find.byType(Text)),
              )
              .map((widget) => widget.data ?? '')
              .toList();
          expect(texts.length, greaterThanOrEqualTo(3), reason: name);
          final summary = texts.last;
          expect(summary, isNotEmpty, reason: name);
          expect(summary, isNot(apiDescription), reason: name);
          expect(summary, isNot('Public GitHub repository.'), reason: name);
          expect(summary, isNot('מאגר GitHub ציבורי.'), reason: name);
          if (hebrew) {
            expect(
              RegExp(r'[\u0590-\u05ff]').hasMatch(summary),
              isTrue,
              reason: name,
            );
          } else {
            expect(RegExp(r'[A-Za-z]').hasMatch(summary), isTrue, reason: name);
          }
          if (name == 'DeepStefan' || name == 'bert-extractive-summarizer') {
            expect(
              texts.any((text) => text.contains('Fork')),
              isTrue,
              reason: name,
            );
          }
        }
      }

      expect(
        find.descendant(
          of: projectCard('FutureProject'),
          matching: find.text(apiDescription),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text(hebrew ? 'סגירה' : 'Close'));
      await tester.pumpAndSettle();
    }

    await verifyProjects(hebrew: false);
    await tester.tap(find.text('עברית'));
    await tester.pumpAndSettle();
    await verifyProjects(hebrew: true);
  });
}
