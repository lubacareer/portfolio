import 'dart:convert';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:port/github_repositories.dart';
import 'package:port/main.dart';

void main() {
  testWidgets('Invalid repository name shows fallback and retry recovers', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var academicAttempts = 0;
    final client = MockClient((request) async {
      final owner = request.url.pathSegments[1];
      final name = owner == 'lubani'
          ? (++academicAttempts == 1 ? 'invalid/name' : 'RecoveredProject')
          : 'CurrentProject';
      return http.Response(
        jsonEncode([
          {
            'name': name,
            'html_url': 'https://github.com/$owner/$name',
            'fork': false,
          },
        ]),
        200,
      );
    });
    addTearDown(client.close);

    await tester.pumpWidget(
      PortfolioApp(
        loadGitHubRepositories: (owner) =>
            loadPublicGitHubRepositories(owner, client: client),
      ),
    );
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();

    expect(find.text('CurrentProject'), findsOneWidget);
    expect(
      find.text('Could not load repositories. Showing saved projects.'),
      findsOneWidget,
    );
    expect(find.text('astro'), findsOneWidget);
    expect(find.text('invalid/name'), findsNothing);

    await tester.ensureVisible(find.text('Retry'));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(academicAttempts, 2);
    expect(find.text('RecoveredProject'), findsOneWidget);
    expect(find.text('astro'), findsNothing);
    expect(find.text('Retry'), findsNothing);
  });
}
