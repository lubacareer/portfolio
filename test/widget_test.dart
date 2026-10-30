// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:port/main.dart';
import 'package:port/github_repositories.dart';

void main() {
  Finder selectableTextContaining(String value) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is material.SelectableText &&
          (widget.data?.contains(value) ?? false),
    );
  }

  Future<void> pumpPortfolio(
    WidgetTester tester, {
    Future<List<GitHubRepository>> Function(String owner)? loadRepositories,
  }) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      PortfolioApp(loadGitHubRepositories: loadRepositories),
    );
  }

  testWidgets('Portfolio renders key tiles', (tester) async {
    await pumpPortfolio(tester);

    // Verify some expected tiles are present
    expect(find.text('CV'), findsOneWidget);
    expect(find.text("Master's Diploma"), findsOneWidget);
    expect(find.text('Introduction'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
    expect(
      find.text(
        'Software Engineer | Python | TypeScript | Flutter | Backend | AI/NLP',
      ),
      findsOneWidget,
    );
    expect(find.text('English'), findsOneWidget);
    expect(find.text('עברית'), findsOneWidget);

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

    expect(find.text('English'), findsWidgets);
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

  testWidgets('Hobbies dialog is populated and Links tile is removed', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.text('Links'), findsNothing);

    await tester.ensureVisible(find.text('Hobbies'));
    await tester.tap(find.text('Hobbies'));
    await tester.pumpAndSettle();

    expect(find.text('TL;DR'), findsOneWidget);
    expect(selectableTextContaining('I enjoy Yin yoga'), findsOneWidget);
    expect(
      selectableTextContaining('Amazon Polly and S3 buckets'),
      findsOneWidget,
    );
    expect(selectableTextContaining('detective stories'), findsOneWidget);
  });

  GitHubRepository repository(
    String owner,
    String name, {
    String? description,
    String? language,
    bool fork = false,
  }) => GitHubRepository(
    name: name,
    description: description,
    language: language,
    htmlUrl: 'https://github.com/$owner/$name',
    isFork: fork,
  );

  testWidgets('Projects load independently for both GitHub accounts', (
    tester,
  ) async {
    final career = Completer<List<GitHubRepository>>();
    final academic = Completer<List<GitHubRepository>>();
    final calls = <String>[];
    await pumpPortfolio(
      tester,
      loadRepositories: (owner) {
        calls.add(owner);
        return owner == 'lubacareer' ? career.future : academic.future;
      },
    );

    await tester.tap(find.text('Projects'));
    await tester.pump();
    expect(calls, containsAll(['lubacareer', 'lubani']));
    expect(find.text('Loading repositories...'), findsNWidgets(2));

    career.complete([
      repository('lubacareer', 'ExitViolet', description: 'API description'),
      repository(
        'lubacareer',
        'NewProject',
        description: 'A new public project',
      ),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('lubacareer (2)'), findsOneWidget);
    expect(find.text('NewProject'), findsOneWidget);
    expect(find.text('A new public project'), findsOneWidget);
    expect(find.text('Loading repositories...'), findsOneWidget);
    expect(
      find.textContaining('Browser-first isometric psychological thriller'),
      findsOneWidget,
    );

    academic.complete([repository('lubani', 'AcademicFork', fork: true)]);
    await tester.pumpAndSettle();
    expect(find.text('lubani (1)'), findsOneWidget);
    expect(find.text('AcademicFork'), findsOneWidget);
    expect(find.text('lubani - Fork'), findsOneWidget);
    expect(find.text('Public GitHub repository.'), findsOneWidget);
  });

  testWidgets('A failed account shows its saved projects and can retry', (
    tester,
  ) async {
    var academicAttempts = 0;
    await pumpPortfolio(
      tester,
      loadRepositories: (owner) async {
        if (owner == 'lubacareer') {
          return [repository(owner, 'CurrentProject')];
        }
        academicAttempts++;
        if (academicAttempts == 1) throw Exception('rate limit');
        return [repository(owner, 'RecoveredProject')];
      },
    );

    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();
    expect(find.text('CurrentProject'), findsOneWidget);
    expect(
      find.text('Could not load repositories. Showing saved projects.'),
      findsOneWidget,
    );
    expect(find.text('astro'), findsOneWidget);
    await tester.ensureVisible(find.text('Retry'));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(academicAttempts, 2);
    expect(find.text('RecoveredProject'), findsOneWidget);
    expect(find.text('astro'), findsNothing);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('An empty account is shown without treating it as a failure', (
    tester,
  ) async {
    await pumpPortfolio(tester, loadRepositories: (_) async => []);
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();
    expect(find.text('No public repositories found.'), findsNWidgets(2));
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('Projects states and retry are localized in Hebrew', (
    tester,
  ) async {
    await pumpPortfolio(
      tester,
      loadRepositories: (owner) async {
        if (owner == 'lubani') throw Exception('offline');
        return [];
      },
    );
    await tester.tap(find.text('עברית'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('פרויקטים'));
    await tester.pumpAndSettle();
    expect(find.text('לא נמצאו מאגרים ציבוריים.'), findsOneWidget);
    expect(
      find.text('לא ניתן לטעון מאגרים. מוצגים פרויקטים שמורים.'),
      findsOneWidget,
    );
    expect(find.text('ניסיון חוזר'), findsOneWidget);
  });

  testWidgets('Experience shows the approved Flex role in both languages', (
    tester,
  ) async {
    await pumpPortfolio(tester);
    await tester.tap(find.text('Experience'));
    await tester.pumpAndSettle();
    expect(
      selectableTextContaining('AOI process support at Flex'),
      findsOneWidget,
    );
    expect(
      selectableTextContaining(
        'handling PCBAs and configuring program thresholds',
      ),
      findsOneWidget,
    );
    expect(selectableTextContaining('24 June 2026–Present'), findsNWidgets(2));
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('עברית'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ניסיון'));
    await tester.pumpAndSettle();
    expect(
      selectableTextContaining('תמיכה בתהליכי AOI ב-Flex'),
      findsOneWidget,
    );
    expect(selectableTextContaining('הגדרת ערכי סף בתוכניות'), findsOneWidget);
    expect(selectableTextContaining('24 ביוני 2026–היום'), findsNWidgets(2));
  });

  testWidgets('Language toggle switches home labels and direction', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(find.text('עברית'));
    await tester.pumpAndSettle();

    expect(find.text('מבוא'), findsOneWidget);
    expect(find.text('השכלה'), findsOneWidget);
    expect(find.text('יצירת קשר'), findsOneWidget);
    expect(
      widgets.Directionality.of(tester.element(find.text('מבוא'))),
      TextDirection.rtl,
    );
  });

  testWidgets('Long section dialog shows TLDR and can collapse full text', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(find.text('Introduction'));
    await tester.pumpAndSettle();

    expect(find.text('TL;DR'), findsOneWidget);
    expect(
      selectableTextContaining('Hard-working and technically talented'),
      findsOneWidget,
    );
    expect(
      selectableTextContaining('hard-working and self-directed'),
      findsOneWidget,
    );

    await tester.tap(find.text('TL;DR only'));
    await tester.pumpAndSettle();

    expect(
      selectableTextContaining('Hard-working and technically talented'),
      findsOneWidget,
    );
    expect(
      selectableTextContaining('hard-working and self-directed'),
      findsNothing,
    );
    expect(find.text('Show full text'), findsOneWidget);

    await tester.tap(find.text('Show full text'));
    await tester.pumpAndSettle();

    expect(
      selectableTextContaining('hard-working and self-directed'),
      findsOneWidget,
    );
  });

  testWidgets('Hebrew long section dialog uses Hebrew copy and controls', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(find.text('עברית'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('מבוא'));
    await tester.pumpAndSettle();

    expect(find.text('מבוא'), findsWidgets);
    expect(find.text('בקצרה'), findsOneWidget);
    expect(find.text('בקצרה בלבד'), findsOneWidget);
    expect(selectableTextContaining('מוסר עבודה גבוה'), findsOneWidget);
  });
}
