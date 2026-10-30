import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port/github_repositories.dart';
import 'package:port/main.dart';

Future<List<GitHubRepository>> _loadProjects(String owner) async => [
  GitHubRepository(
    name: owner == 'lubacareer' ? 'CML' : 'DeepStefan',
    htmlUrl:
        'https://github.com/$owner/${owner == 'lubacareer' ? 'CML' : 'DeepStefan'}',
    isFork: owner == 'lubani',
  ),
];

void main() {
  testWidgets('Mobile navigation opens projects and keeps Hebrew RTL', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const PortfolioApp(loadGitHubRepositories: _loadProjects),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('Projects').first);
    await tester.tap(find.text('Projects').first);
    await tester.pumpAndSettle();
    Finder inDialog(Finder matching) =>
        find.descendant(of: find.byType(AlertDialog), matching: matching);

    expect(inDialog(find.text('CML')), findsOneWidget);
    expect(inDialog(find.text('DeepStefan')), findsOneWidget);
    expect(inDialog(find.textContaining('Fork')), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Close').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('עברית').first);
    await tester.tap(find.text('עברית').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('פרויקטים').first);
    expect(
      Directionality.of(tester.element(find.text('פרויקטים').first)),
      TextDirection.rtl,
    );
    await tester.tap(find.text('פרויקטים').first);
    await tester.pumpAndSettle();
    expect(inDialog(find.text('CML')), findsOneWidget);
    expect(inDialog(find.text('DeepStefan')), findsOneWidget);
    expect(
      Directionality.of(tester.element(inDialog(find.text('DeepStefan')))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('סגירה').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('ניסיון').first);
    await tester.tap(find.text('ניסיון').first);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SelectableText &&
            (widget.data?.contains('תמיכה בתהליכי AOI ב-Flex') ?? false),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
