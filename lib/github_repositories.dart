import 'dart:convert';

import 'package:http/http.dart' as http;

/// The public metadata used to display a repository in the portfolio.
class GitHubRepository {
  const GitHubRepository({
    required this.name,
    required this.htmlUrl,
    required this.isFork,
    this.description,
    this.language,
  });

  final String name;
  final String htmlUrl;
  final bool isFork;
  final String? description;
  final String? language;
}

typedef GitHubRepositoryLoader =
    Future<List<GitHubRepository>> Function(String owner);

/// Fetches every page of a user's public, owned repositories, including forks.
/// No credentials or private information are sent with these requests.
Future<List<GitHubRepository>> loadPublicGitHubRepositories(
  String owner, {
  http.Client? client,
}) async {
  if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(owner)) {
    throw ArgumentError.value(owner, 'owner', 'Invalid GitHub username');
  }
  final ownedClient = client == null;
  final requestClient = client ?? http.Client();
  final repositories = <GitHubRepository>[];
  const pageSize = 100;
  try {
    for (var page = 1; ; page++) {
      final uri = Uri.https('api.github.com', '/users/$owner/repos', {
        'type': 'owner',
        'per_page': '$pageSize',
        'page': '$page',
      });
      final response = await requestClient
          .get(uri, headers: {'Accept': 'application/vnd.github+json'})
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw GitHubRepositoriesException(response.statusCode);
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! List) {
        throw const FormatException('Expected repository list');
      }
      for (final item in data) {
        if (item is! Map<String, dynamic> ||
            item['name'] is! String ||
            item['fork'] is! bool ||
            (item['description'] != null && item['description'] is! String) ||
            (item['language'] != null && item['language'] is! String)) {
          throw const FormatException('Invalid repository metadata');
        }
        if (item['private'] == true) continue;
        final name = item['name'] as String;
        if (name.isEmpty ||
            name.length > 100 ||
            name == '.' ||
            name == '..' ||
            RegExp(r'[^A-Za-z0-9._-]').hasMatch(name)) {
          throw const FormatException('Invalid repository name');
        }
        repositories.add(
          GitHubRepository(
            name: name,
            htmlUrl: Uri(
              scheme: 'https',
              host: 'github.com',
              pathSegments: [owner, name],
            ).toString(),
            isFork: item['fork'] as bool,
            description: item['description'] as String?,
            language: item['language'] as String?,
          ),
        );
      }
      if (data.length < pageSize) break;
    }
    return repositories;
  } finally {
    if (ownedClient) requestClient.close();
  }
}

class GitHubRepositoriesException implements Exception {
  const GitHubRepositoriesException(this.statusCode);
  final int statusCode;
}
