import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:port/github_repositories.dart';

Map<String, Object?> repository(int index, {bool fork = false}) => {
  'name': 'project-$index',
  'html_url': 'https://github.com/lubani/project-$index',
  'description': null,
  'language': null,
  'fork': fork,
  'private': false,
};

void main() {
  test('loads every page, including forks and missing descriptions', () async {
    final requests = <Uri>[];
    final client = MockClient((request) async {
      requests.add(request.url);
      final page = request.url.queryParameters['page'];
      final items = page == '1'
          ? List.generate(100, (index) => repository(index))
          : [repository(100, fork: true)];
      return http.Response(jsonEncode(items), 200);
    });
    final result = await loadPublicGitHubRepositories('lubani', client: client);
    expect(requests.length, 2);
    expect(requests.first.path, '/users/lubani/repos');
    expect(requests.first.queryParameters['type'], 'owner');
    expect(requests.first.queryParameters['per_page'], '100');
    expect(result.length, 101);
    expect(result.last.isFork, isTrue);
    expect(result.last.description, isNull);
    expect(result.last.language, isNull);
  });

  test('returns an empty list when an account has no repositories', () async {
    final client = MockClient((_) async => http.Response('[]', 200));
    expect(
      await loadPublicGitHubRepositories('lubacareer', client: client),
      isEmpty,
    );
  });

  test('propagates rate limits and does not return incomplete pages', () async {
    final client = MockClient((request) async {
      if (request.url.queryParameters['page'] == '1') {
        return http.Response(jsonEncode(List.generate(100, repository)), 200);
      }
      return http.Response('{}', 403);
    });
    await expectLater(
      loadPublicGitHubRepositories('lubani', client: client),
      throwsA(
        isA<GitHubRepositoriesException>().having(
          (e) => e.statusCode,
          'statusCode',
          403,
        ),
      ),
    );
  });

  test('rejects malformed API responses', () async {
    final client = MockClient(
      (_) async => http.Response('{"message":"error"}', 200),
    );
    await expectLater(
      loadPublicGitHubRepositories('lubacareer', client: client),
      throwsFormatException,
    );
  });
}
