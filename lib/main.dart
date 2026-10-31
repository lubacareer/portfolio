import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'github_repositories.dart';
import 'project_media.dart';
import 'youtube_player.dart';

class AppPalette {
  static const background = Color(0xFF080F22);
  static const backgroundWarm = Color(0xFF101934);
  static const backgroundCool = Color(0xFF111C3C);
  static const surface = Color(0xFF101A32);
  static const tileSurface = Color(0xFF111A30);
  static const tileHover = Color(0xFF1B2848);
  static const tilePressed = Color(0xFF242F53);
  static const primary = Color(0xFFB9B4FF);
  static const primaryDeep = Color(0xFFE0DFFF);
  static const accent = Color(0xFF92A6FF);
  static const text = Color(0xFFF1F1FF);
  static const mutedText = Color(0xFFC1C9E2);
  static const subtleText = Color(0xFFA6B5D4);
  static const border = Color(0xFF4D5E96);
  static const hoverBorder = Color(0xFF9EABFF);
  static const pressedBorder = Color(0xFFCBC7FF);
  static const primaryGlow = Color(0x339EABFF);
  static const accentGlow = Color(0x3392A6FF);
  static const tileShadow = Color(0x22000000);
  static const imageFallback = Color(0xFF1B2848);
  static const onAccent = Color(0xFF090F22);
}

const _dialogRadius = 24.0;
const _tileRadius = 22.0;
const _buttonRadius = 14.0;

enum PortfolioLanguage { english, hebrew }

extension PortfolioLanguageValues on PortfolioLanguage {
  bool get isHebrew => this == PortfolioLanguage.hebrew;

  Locale get locale => isHebrew ? const Locale('he') : const Locale('en');

  TextDirection get direction =>
      isHebrew ? TextDirection.rtl : TextDirection.ltr;

  TextAlign get paragraphAlign =>
      isHebrew ? TextAlign.right : TextAlign.justify;
}

class LocalizedString {
  final String english;
  final String hebrew;

  const LocalizedString({required this.english, required this.hebrew});

  String resolve(PortfolioLanguage language) =>
      language.isHebrew ? hebrew : english;
}

String _localized(
  PortfolioLanguage language, {
  required String english,
  required String hebrew,
}) => language.isHebrew ? hebrew : english;

Color _tileFill({required bool hovered, required bool pressed}) {
  if (pressed) {
    return AppPalette.tilePressed;
  }
  if (hovered) {
    return AppPalette.tileHover;
  }
  return AppPalette.tileSurface;
}

Color _tileBorder({required bool hovered, required bool pressed}) {
  if (pressed) {
    return AppPalette.pressedBorder;
  }
  if (hovered) {
    return AppPalette.hoverBorder;
  }
  return AppPalette.border;
}

List<BoxShadow> _tileShadows({required bool hovered, required bool pressed}) {
  return [
    const BoxShadow(
      color: AppPalette.tileShadow,
      blurRadius: 22,
      offset: Offset(0, 10),
    ),
    if (hovered || pressed)
      BoxShadow(
        color: pressed ? AppPalette.accentGlow : AppPalette.primaryGlow,
        blurRadius: 22,
        spreadRadius: 1,
      ),
  ];
}

ShapeBorder _dialogShape() => RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(_dialogRadius),
  side: const BorderSide(color: AppPalette.border),
);

TextStyle? _dialogTitleStyle(BuildContext context) => Theme.of(context)
    .textTheme
    .titleMedium
    ?.copyWith(color: AppPalette.text, fontWeight: FontWeight.w700);

TextStyle? _dialogContentStyle(BuildContext context) => Theme.of(
  context,
).textTheme.bodyMedium?.copyWith(color: AppPalette.mutedText, height: 1.35);

String _closeLabel(PortfolioLanguage language) =>
    _localized(language, english: 'Close', hebrew: 'סגירה');

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key, this.loadGitHubRepositories});

  final GitHubRepositoryLoader? loadGitHubRepositories;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  PortfolioLanguage _language = PortfolioLanguage.english;

  @override
  Widget build(BuildContext context) {
    final title = _localized(
      _language,
      english: "Luba Ira Korlat",
      hebrew: 'לובה אירה קורלט',
    );

    return MaterialApp(
      title: title,
      locale: _language.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppPalette.background,
        colorScheme: const ColorScheme.dark(
          surface: AppPalette.surface,
          primary: AppPalette.primary,
          onPrimary: AppPalette.onAccent,
          secondary: AppPalette.accent,
          onSecondary: AppPalette.onAccent,
          onSurface: AppPalette.text,
          outline: AppPalette.border,
        ),
        fontFamily: 'Rubik',
        fontFamilyFallback: const ['Segoe UI', 'Arial', 'Noto Sans Hebrew'],
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppPalette.primaryDeep),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppPalette.primaryDeep,
            side: const BorderSide(color: AppPalette.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_buttonRadius),
            ),
          ),
        ),
      ),
      home: Directionality(
        textDirection: _language.direction,
        child: PortfolioHome(
          language: _language,
          loadGitHubRepositories: widget.loadGitHubRepositories,
          onLanguageChanged: (language) {
            setState(() => _language = language);
          },
        ),
      ),
    );
  }
}

class PortfolioHome extends StatelessWidget {
  final PortfolioLanguage language;
  final ValueChanged<PortfolioLanguage> onLanguageChanged;
  final GitHubRepositoryLoader? loadGitHubRepositories;

  const PortfolioHome({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    this.loadGitHubRepositories,
  });

  @override
  Widget build(BuildContext context) {
    void openProjects() => showProjects(
      context,
      language,
      loadGitHubRepositories: loadGitHubRepositories,
    );
    final navigation = <_OrbitNavigationItem>[
      _OrbitNavigationItem(
        label: _localized(language, english: 'Projects', hebrew: 'פרויקטים'),
        icon: Icons.grid_view_rounded,
        onPressed: openProjects,
      ),
      for (final section in _longSections)
        _OrbitNavigationItem(
          label: section.title.resolve(language),
          icon: section.icon,
          onPressed: () => showLongSection(context, language, section),
        ),
      _OrbitNavigationItem(
        label: _localized(language, english: 'Hobbies', hebrew: 'תחביבים'),
        icon: Icons.favorite_outline_rounded,
        onPressed: () => showLongSection(context, language, _hobbiesSection),
      ),
      _OrbitNavigationItem(
        label: _localized(language, english: 'Contact', hebrew: 'יצירת קשר'),
        icon: Icons.mail_outline_rounded,
        onPressed: () => showContact(context, language),
      ),
      _OrbitNavigationItem(
        label: _localized(language, english: 'CV', hebrew: 'קורות חיים'),
        icon: Icons.description_outlined,
        onPressed: () => _showDocumentLanguages(context, language, false),
      ),
      _OrbitNavigationItem(
        label: _localized(
          language,
          english: 'Cover Letter',
          hebrew: 'מכתב מקדים',
        ),
        icon: Icons.article_outlined,
        onPressed: () => _showDocumentLanguages(context, language, true),
      ),
      _OrbitNavigationItem(
        label: _localized(
          language,
          english: "Master's Diploma",
          hebrew: 'תעודת תואר שני',
        ),
        icon: Icons.workspace_premium_outlined,
        onPressed: () => openPublic('/docs/masters_public.pdf'),
      ),
    ];

    return Scaffold(
      backgroundColor: AppPalette.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 900;
          final content = SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!desktop)
                  _OrbitMobileNavigation(
                    language: language,
                    onLanguageChanged: onLanguageChanged,
                    items: navigation,
                  ),
                _OrbitHero(
                  language: language,
                  onProjects: openProjects,
                  onCv: () => _showDocumentLanguages(context, language, false),
                ),
                _OrbitFeaturedProjects(
                  language: language,
                  onProjects: openProjects,
                ),
                _OrbitContactStrip(language: language),
              ],
            ),
          );
          if (!desktop) return content;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OrbitDesktopNavigation(
                language: language,
                onLanguageChanged: onLanguageChanged,
                items: navigation,
              ),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }
}

class _OrbitNavigationItem {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _OrbitNavigationItem({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
}

class _OrbitDesktopNavigation extends StatelessWidget {
  final PortfolioLanguage language;
  final ValueChanged<PortfolioLanguage> onLanguageChanged;
  final List<_OrbitNavigationItem> items;

  const _OrbitDesktopNavigation({
    required this.language,
    required this.onLanguageChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 174,
      decoration: BoxDecoration(
        color: AppPalette.surface,
        border: BorderDirectional(end: BorderSide(color: AppPalette.border)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 55,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppPalette.primary),
                  ),
                  child: Text(
                    'LK',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppPalette.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              for (final item in items) ...[
                TextButton(
                  onPressed: item.onPressed,
                  style: TextButton.styleFrom(
                    alignment: AlignmentDirectional.centerStart,
                    foregroundColor: AppPalette.text,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 20),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          item.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
              ],
              const SizedBox(height: 16),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: _LanguageSelector(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrbitMobileNavigation extends StatelessWidget {
  final PortfolioLanguage language;
  final ValueChanged<PortfolioLanguage> onLanguageChanged;
  final List<_OrbitNavigationItem> items;

  const _OrbitMobileNavigation({
    required this.language,
    required this.onLanguageChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPalette.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _localized(
                      language,
                      english: 'Luba Ira Korlat',
                      hebrew: 'לובה אירה קורלט',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppPalette.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _LanguageSelector(
                      language: language,
                      onLanguageChanged: onLanguageChanged,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: [
                for (final item in items)
                  TextButton(
                    onPressed: item.onPressed,
                    style: TextButton.styleFrom(
                      foregroundColor: AppPalette.text,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    child: Text(item.label),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitHero extends StatelessWidget {
  final PortfolioLanguage language;
  final VoidCallback onProjects;
  final VoidCallback onCv;

  const _OrbitHero({
    required this.language,
    required this.onProjects,
    required this.onCv,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppPalette.background,
        image: DecorationImage(
          image: AssetImage('web/images/night-orbit-hero.png'),
          fit: BoxFit.cover,
          opacity: 0.65,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final portrait = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: wide ? 460 : 320),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipOval(
                  child: Image.asset(
                    'web/images/meformal.png',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.4, 0),
                    semanticLabel: _localized(
                      language,
                      english: 'Portrait of Luba Ira Korlat',
                      hebrew: 'דיוקן של לובה אירה קורלט',
                    ),
                    errorBuilder: (context, error, stack) => Container(
                      alignment: Alignment.center,
                      color: AppPalette.imageFallback,
                      child: const Icon(
                        Icons.person,
                        color: AppPalette.subtleText,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _localized(
                  language,
                  english: 'AOI PROCESS SUPPORT',
                  hebrew: 'תמיכה בתהליכי AOI',
                ),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppPalette.primary,
                  letterSpacing: language.isHebrew ? 0 : 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _localized(
                  language,
                  english: 'Luba Ira Korlat',
                  hebrew: 'לובה אירה קורלט',
                ),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppPalette.text,
                  fontWeight: FontWeight.w700,
                  height: 1.04,
                  fontSize: wide ? 60 : 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _localized(
                  language,
                  english: 'AOI Process Support & Software Engineering',
                  hebrew: 'תמיכה בתהליכי AOI והנדסת תוכנה',
                ),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppPalette.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _localized(
                  language,
                  english:
                      'M.Sc. Software Engineering graduate building practical apps, backend systems, AI/NLP tools, and polished client projects.',
                  hebrew:
                      'בוגרת תואר שני בהנדסת תוכנה שבונה אפליקציות, מערכות Backend, כלי AI/NLP ופרויקטים מלוטשים ללקוחות.',
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppPalette.mutedText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: onProjects,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPalette.primary,
                      foregroundColor: AppPalette.background,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 17,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                    label: Text(
                      _localized(
                        language,
                        english: 'Explore Projects',
                        hebrew: 'לכל הפרויקטים',
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: onCv,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 17,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.download_rounded, size: 19),
                    label: Text(
                      _localized(
                        language,
                        english: 'Download CV',
                        hebrew: 'הורדת קורות חיים',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                _localized(
                  language,
                  english:
                      'AOI | Software Engineer | Python | TypeScript | Flutter | Backend | AI/NLP',
                  hebrew:
                      'AOI | מהנדסת תוכנה | Python | TypeScript | Flutter | Backend | AI/NLP',
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.mutedText,
                  height: 1.6,
                ),
              ),
            ],
          );
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: wide ? 50 : 24,
              vertical: wide ? 46 : 32,
            ),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: copy),
                      const SizedBox(width: 24),
                      Expanded(flex: 5, child: portrait),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      copy,
                      const SizedBox(height: 28),
                      Center(child: portrait),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _OrbitFeaturedProjects extends StatelessWidget {
  final PortfolioLanguage language;
  final VoidCallback onProjects;

  const _OrbitFeaturedProjects({
    required this.language,
    required this.onProjects,
  });

  @override
  Widget build(BuildContext context) {
    const featured = [
      ('lubacareer', 'HeatEquationSimulator'),
      ('lubani', 'scientificProject'),
      ('lubacareer', 'jupiter'),
      ('lubacareer', 'Nasa2'),
      ('lubacareer', 'nasaCLPS-releases'),
      ('lubacareer', 'CML'),
      ('lubacareer', 'electricity'),
    ];
    final projects = [
      for (final (owner, name) in featured)
        _githubProjects.firstWhere(
          (project) => project.owner == owner && project.name == name,
        ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 34, 32, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localized(
              language,
              english: 'SELECTED PROJECTS',
              hebrew: 'פרויקטים נבחרים',
            ),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppPalette.primary,
              letterSpacing: language.isHebrew ? 0 : 1.8,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 10,
            children: [
              Text(
                _localized(
                  language,
                  english: 'Turning ideas into working solutions',
                  hebrew: 'מרעיון לפתרון מעשי',
                ),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppPalette.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton.icon(
                onPressed: onProjects,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(
                  _localized(
                    language,
                    english: 'View all projects',
                    hebrew: 'לכל הפרויקטים',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 900
                  ? 3
                  : width >= 600
                  ? 2
                  : 1;
              const gap = 16.0;
              final cardWidth = (width - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var i = 0; i < projects.length; i++)
                    SizedBox(
                      width: cardWidth,
                      child: _OrbitProjectCard(
                        language: language,
                        project: projects[i],
                        image: mediaForProject(
                          projects[i].owner,
                          projects[i].name,
                        )?.screenshots.firstOrNull?.asset,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrbitProjectCard extends StatelessWidget {
  final PortfolioLanguage language;
  final PortfolioProject project;
  final String? image;

  const _OrbitProjectCard({
    required this.language,
    required this.project,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppPalette.tileSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppPalette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showProjectDetails(context, language, project),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppPalette.text,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          project.summary(language),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppPalette.mutedText,
                                height: 1.45,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        image!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                      ),
                    )
                  else
                    const SizedBox(
                      width: 72,
                      height: 72,
                      child: Icon(
                        Icons.science_outlined,
                        color: AppPalette.primary,
                        size: 36,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                project.metadata(language),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppPalette.subtleText),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _localized(
                      language,
                      english: 'View project',
                      hebrew: 'הצגת הפרויקט',
                    ),
                    style: TextStyle(
                      color: AppPalette.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppPalette.primary,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrbitContactStrip extends StatelessWidget {
  final PortfolioLanguage language;
  const _OrbitContactStrip({required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPalette.surface,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        spacing: 24,
        runSpacing: 16,
        children: [
          Text(
            _localized(
              language,
              english: 'Let’s connect about projects and opportunities.',
              hebrew: 'מוזמנים ליצור קשר בנוגע לפרויקטים ולהזדמנויות.',
            ),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppPalette.text),
          ),
          FilledButton.icon(
            onPressed: () => showContact(context, language),
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.primary,
              foregroundColor: AppPalette.background,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
            ),
            icon: const Icon(Icons.mail_outline_rounded, size: 19),
            label: Text(
              _localized(
                language,
                english: 'Get in touch',
                hebrew: 'יצירת קשר',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showDocumentLanguages(
  BuildContext context,
  PortfolioLanguage language,
  bool coverLetter,
) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => Directionality(
      textDirection: language.direction,
      child: AlertDialog(
        backgroundColor: AppPalette.surface,
        shape: _dialogShape(),
        titleTextStyle: _dialogTitleStyle(dialogContext),
        title: Text(
          _localized(
            language,
            english: 'Choose a language',
            hebrew: 'בחירת שפה',
          ),
        ),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton(
              onPressed: () =>
                  openPublic(coverLetter ? '/docs/CL1.pdf' : '/docs/CV1.pdf'),
              child: Text(
                _localized(language, english: 'English', hebrew: 'אנגלית'),
              ),
            ),
            OutlinedButton(
              onPressed: () => openPublic(
                coverLetter ? '/docs/CL1heb.pdf' : '/docs/CV1heb.pdf',
              ),
              child: Text(
                _localized(language, english: 'Hebrew', hebrew: 'עברית'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(_closeLabel(language)),
          ),
        ],
      ),
    ),
  );
}

class _LanguageSelector extends StatelessWidget {
  final PortfolioLanguage language;
  final ValueChanged<PortfolioLanguage> onLanguageChanged;

  const _LanguageSelector({
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PortfolioLanguage>(
      segments: const [
        ButtonSegment(value: PortfolioLanguage.english, label: Text('English')),
        ButtonSegment(value: PortfolioLanguage.hebrew, label: Text('עברית')),
      ],
      selected: {language},
      showSelectedIcon: false,
      onSelectionChanged: (selected) => onLanguageChanged(selected.first),
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppPalette.onAccent;
          }
          return AppPalette.primaryDeep;
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppPalette.primary;
          }
          return AppPalette.tileSurface;
        }),
        side: WidgetStateProperty.all(
          const BorderSide(color: AppPalette.border),
        ),
      ),
    );
  }
}

Future<void> openPublic(String path) async {
  final uri = Uri.parse(path);
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}

Future<void> openEmail(String email) async {
  final uri = Uri(scheme: 'mailto', path: email);
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}

class PortfolioSection {
  final LocalizedString title;
  final LocalizedString subtitle;
  final IconData icon;
  final LocalizedString summary;
  final List<LocalizedString> paragraphs;

  const PortfolioSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.summary,
    required this.paragraphs,
  });
}

const _introSection = PortfolioSection(
  title: LocalizedString(english: 'Introduction', hebrew: 'מבוא'),
  subtitle: LocalizedString(english: 'About me', hebrew: 'עליי'),
  icon: Icons.info_outline,
  summary: LocalizedString(
    english:
        'Hard-working and technically talented software engineer, educator, and freelancer with cum laude graduate studies and practical delivery across Python, Flutter, backend, AI/NLP, and web projects.',
    hebrew:
        'מהנדסת תוכנה, מורה ומפתחת עצמאית עם מוסר עבודה גבוה, כישרון טכני, תואר שני בהצטיינות וניסיון מעשי ב-Python, Flutter, Backend, AI/NLP ופרויקטי Web.',
  ),
  paragraphs: [
    LocalizedString(
      english:
          '''From a young age, curiosity guided me toward math, physics, languages, and computers, nurturing an early passion for solving complex puzzles. I have always been a hard-working and self-directed learner, drawn to problems that require patience, precision, and clear thinking. After serving in Sherut Leumi, I completed a preparatory program at Sami Shamoon College of Engineering, then earned both a Bachelor's degree and a Master's degree in Software Engineering, completing the master's cum laude with a GPA of 96. My master's research focused on simulating lunar regolith melting using physics-informed neural networks and advanced numerical analysis.''',
      hebrew:
          '''מגיל צעיר הסקרנות הובילה אותי אל מתמטיקה, פיזיקה, שפות ומחשבים, וטיפחה אצלי אהבה לפתרון בעיות מורכבות. תמיד הייתי לומדת חרוצה ועצמאית, שנמשכת לבעיות שדורשות סבלנות, דיוק וחשיבה בהירה. לאחר שירות לאומי השלמתי מכינה במכללה האקדמית להנדסה סמי שמעון, ובהמשך סיימתי תואר ראשון ותואר שני בהנדסת תוכנה. את התואר השני סיימתי בהצטיינות עם ממוצע 96. המחקר שלי בתואר השני עסק בסימולציה של התכת רגולית ירחי באמצעות רשתות עצביות מוכוונות פיזיקה וניתוח נומרי מתקדם.''',
    ),
    LocalizedString(
      english:
          '''Today, my professional profile combines software development, teaching, and client-focused delivery. I tutor students in software engineering, mathematics, and physics, teach practical networking and cybersecurity concepts, and build tailored software solutions for private clients. Since January 2025, I have worked as a registered freelance developer, delivering mobile apps, websites, backend systems, and technical prototypes. I am now looking for a software engineering role where I can contribute strong problem-solving, disciplined implementation, and clear technical communication to an innovative team.''',
      hebrew:
          '''כיום הפרופיל המקצועי שלי משלב פיתוח תוכנה, הוראה וביצוע פרויקטים ללקוחות. אני מלמדת הנדסת תוכנה, מתמטיקה ופיזיקה, מדריכה נושאים מעשיים ברשתות ובסייבר, ובונה פתרונות תוכנה מותאמים ללקוחות פרטיים. מאז ינואר 2025 אני עובדת כמפתחת עצמאית רשומה, ומספקת אפליקציות מובייל, אתרים, מערכות Backend ואבות-טיפוס טכניים. כעת אני מחפשת תפקיד בהנדסת תוכנה שבו אוכל להביא פתרון בעיות חזק, יישום מסודר ותקשורת טכנית ברורה לצוות חדשני.''',
    ),
  ],
);

const _educationSection = PortfolioSection(
  title: LocalizedString(english: 'Education', hebrew: 'השכלה'),
  subtitle: LocalizedString(
    english: 'My academic journey',
    hebrew: 'הדרך האקדמית שלי',
  ),
  icon: Icons.school,
  summary: LocalizedString(
    english:
        'Academic growth built through persistence: preparatory studies, a Software Engineering degree, NLP work, and a cum laude master\'s thesis on lunar regolith simulation.',
    hebrew:
        'צמיחה אקדמית שנבנתה בהתמדה: מכינה, תואר בהנדסת תוכנה, עבודת NLP ותזה מצטיינת על סימולציית רגולית ירחי.',
  ),
  paragraphs: [
    LocalizedString(
      english:
          '''My educational path has always been driven by curiosity and a deep passion for mathematics, physics, and computers: interests that captivated me from early childhood. Growing up in an era before the rise of generative AI tools, I embraced each academic challenge independently, dedicating countless hours to mastering complex concepts through sheer determination and persistence. Integrity defined every step: throughout my Bachelor's studies in Software Engineering at Sami Shamoon College of Engineering (SCE), even amid the turbulent shift to remote learning during the COVID pandemic, I completed every task without compromising on honesty or seeking shortcuts.''',
      hebrew:
          '''הדרך הלימודית שלי תמיד הונעה מסקרנות ומאהבה עמוקה למתמטיקה, פיזיקה ומחשבים - תחומים שריתקו אותי כבר מילדות. גדלתי בתקופה שלפני כלי הבינה המלאכותית הגנרטיבית, ולכן התמודדתי עם אתגרים אקדמיים באופן עצמאי, תוך השקעת שעות רבות בלמידה ובהבנה של מושגים מורכבים. יושרה הייתה חלק מרכזי בכל שלב: לאורך התואר הראשון בהנדסת תוכנה במכללה האקדמית להנדסה סמי שמעון, גם בתקופת המעבר הסוערת ללמידה מרחוק בזמן הקורונה, הקפדתי לבצע כל משימה בלי לוותר על הגינות ובלי לחפש קיצורי דרך.''',
    ),
    LocalizedString(
      english:
          '''My initial ventures into the world of programming began with natural language processing (NLP). I vividly remember the excitement of exploring Python libraries such as the Sumy repository for text summarization and learning how open-source GitHub projects are structured. This early NLP journey sparked a project close to my heart: developing a browser extension to summarize Hebrew texts. Through this work, I encountered JavaScript for the first time while continuing to build on my strongest foundation: Python, algorithms, and structured problem solving.''',
      hebrew:
          '''הכניסה הראשונית שלי לעולם התכנות החלה בעיבוד שפה טבעית. אני זוכרת היטב את ההתרגשות כשחקרתי ספריות Python כמו Sumy לסיכום טקסטים ולמדתי איך בנויים פרויקטי קוד פתוח ב-GitHub. המסע הזה ב-NLP הוביל לפרויקט שקרוב ללבי: פיתוח תוסף דפדפן לסיכום טקסטים בעברית. דרך העבודה הזו פגשתי לראשונה את JavaScript, תוך שאני ממשיכה לבנות על הבסיס החזק ביותר שלי: Python, אלגוריתמים ופתרון בעיות מסודר.''',
    ),
    LocalizedString(
      english:
          '''Pursuing my Master's degree at SCE marked a significant turning point. During a numerical analysis course, my professor introduced me to an intriguing concept: leveraging lunar regolith for future Moon settlements. Inspired by his vision, I delved deeply into research papers, books, and extensive scientific literature. Initially considering Julia for simulation, we soon transitioned to Python due to its robust long-term support and expansive ecosystem. After numerous iterations, we discovered Physics-Informed Neural Networks (PINNs): an advanced approach integrating deep learning and physics-based modeling. Given my prior coursework in deep learning and machine learning, this discovery captivated me profoundly. Over the next two years, I meticulously developed, tested, and refined a PINN-based Python simulation to model lunar regolith melting processes. Ultimately, this rigorous effort culminated in a comprehensive thesis and a fully functional codebase, enabling me to graduate cum laude with a Master's degree in Software Engineering.''',
      hebrew:
          '''הלימודים לתואר השני ב-SCE היו נקודת מפנה משמעותית. במהלך קורס בניתוח נומרי המרצה שלי הציג רעיון מרתק: שימוש ברגולית ירחי לטובת התיישבות עתידית על הירח. בהשראת הרעיון העמקתי במאמרים, ספרים וספרות מדעית רחבה. בתחילה שקלנו להשתמש ב-Julia לסימולציה, אך עברנו ל-Python בזכות התמיכה ארוכת הטווח והאקוסיסטם הרחב שלה. לאחר ניסיונות רבים הגענו לרשתות עצביות מוכוונות פיזיקה, PINNs, שמחברות בין למידה עמוקה למידול פיזיקלי. מאחר שכבר למדתי למידה עמוקה ולמידת מכונה, הגילוי הזה ריתק אותי במיוחד. במשך כשנתיים פיתחתי, בדקתי ושיפרתי סימולציית Python מבוססת PINN למידול תהליכי התכה של רגולית ירחי. העבודה הסתיימה בתזה מקיפה ובקוד פעיל, ואפשרה לי לסיים תואר שני בהנדסת תוכנה בהצטיינות.''',
    ),
    LocalizedString(
      english:
          '''Today, my academic path reflects strong technical ability, creativity, disciplined work habits, and a long-term commitment to continuous learning and exploration.''',
      hebrew:
          '''כיום הדרך האקדמית שלי משקפת יכולת טכנית חזקה, יצירתיות, הרגלי עבודה מסודרים ומחויבות ארוכת טווח ללמידה ולחקירה.''',
    ),
  ],
);

const _skillsSection = PortfolioSection(
  title: LocalizedString(english: 'Skills', hebrew: 'כישורים'),
  subtitle: LocalizedString(english: 'My skillset', hebrew: 'סט הכישורים שלי'),
  icon: Icons.handyman,
  summary: LocalizedString(
    english:
        'AOI process support and program threshold configuration, alongside a broad software foundation across Python, C, C++, Java, SQL, Linux, machine learning, Flutter, and practical teaching-oriented problem solving.',
    hebrew:
        'תמיכה בתהליכי AOI והגדרת ערכי סף בתוכניות, לצד בסיס תוכנה רחב הכולל Python, C, C++, Java, SQL, Linux, למידת מכונה, Flutter ופתרון בעיות מעשי עם אוריינטציה להוראה.',
  ),
  paragraphs: [
    LocalizedString(
      english:
          '''My skills include AOI process support, handling PCBAs, and configuring program thresholds.''',
      hebrew:
          '''הכישורים שלי כוללים תמיכה בתהליכי AOI, טיפול בכרטיסים אלקטרוניים מורכבים (PCBAs) והגדרת ערכי סף בתוכניות.''',
    ),
    LocalizedString(
      english:
          '''My journey with computers started early: in fact, as early as three or four years old when I first encountered the command-line interface of MS-DOS. Even then, typing short commands sparked a lifelong passion for technology. Throughout the 90s, with Microsoft Windows dominating the landscape, I eagerly explored office software, particularly MS Word, where I channeled my love for storytelling and verbal expression.''',
      hebrew:
          '''המסע שלי עם מחשבים התחיל מוקדם מאוד, כבר בגיל שלוש או ארבע, כשפגשתי לראשונה את שורת הפקודה של MS-DOS. אפילו אז, הקלדה של פקודות קצרות הציתה בי אהבה ארוכת שנים לטכנולוגיה. לאורך שנות התשעים, כש-Windows שלטה בנוף המחשוב, חקרתי בהתלהבות תוכנות משרדיות, במיוחד MS Word, ושם שילבתי את אהבתי לסיפור ולביטוי מילולי.''',
    ),
    LocalizedString(
      english:
          '''In high school, my curiosity deepened as I tackled analytical subjects like math, physics, and computer science. My first experience with databases came through Microsoft Access, followed by my introduction to programming with Java: an experience that was both enjoyable and formative.''',
      hebrew:
          '''בתיכון הסקרנות שלי העמיקה כשעסקתי בתחומים אנליטיים כמו מתמטיקה, פיזיקה ומדעי המחשב. הניסיון הראשון שלי עם מסדי נתונים היה ב-Microsoft Access, ולאחר מכן נחשפתי לתכנות ב-Java - חוויה שהייתה גם מהנה וגם מעצבת.''',
    ),
    LocalizedString(
      english:
          '''Entering my bachelor's degree in Software Engineering, I dove headfirst into learning programming languages, beginning with C. It was challenging yet rewarding, embedding syntax into my memory. Languages like C++, Python, and Java quickly followed. In my third year, the complexity escalated with compiler design using Lex, Yacc, Linux, and Bash scripting. This exposure ignited a profound interest in Unix-based systems and virtual machines, tools I integrate into my workflow to this day: every new laptop promptly receives a VMware installation running a Linux distribution.''',
      hebrew:
          '''בתחילת התואר הראשון בהנדסת תוכנה צללתי לעומק לימוד שפות תכנות, החל מ-C. זה היה מאתגר אך מתגמל, והתחביר ממש נצרב בזיכרון. בהמשך הגיעו C++, Python ו-Java. בשנה השלישית רמת המורכבות עלתה עם תכנון מהדרים באמצעות Lex, Yacc, Linux וסקריפטים ב-Bash. החשיפה הזאת הציתה בי עניין עמוק במערכות מבוססות Unix ובמכונות וירטואליות - כלים שאני משלבת בעבודה עד היום, וכל מחשב חדש מקבל במהירות התקנת VMware עם הפצת Linux.''',
    ),
    LocalizedString(
      english:
          '''My undergraduate studies culminated in an NLP-focused project using Python, marking my deep dive into machine learning. During this time, I also honed my database skills, learning and later teaching SQL and MySQL.''',
      hebrew:
          '''הלימודים לתואר הראשון הסתיימו בפרויקט ממוקד NLP ב-Python, שסימן את הצלילה העמוקה שלי לעולם למידת המכונה. באותה תקופה גם חיזקתי את יכולות מסדי הנתונים שלי, למדתי SQL ו-MySQL ובהמשך גם לימדתי אותם.''',
    ),
    LocalizedString(
      english:
          '''In my master's degree, I specialized further in Python, applying numerical analysis and physics-informed neural networks (PINNs) to simulate thermodynamics: specifically, lunar regolith melting for resource utilization in future lunar colonies.''',
      hebrew:
          '''בתואר השני העמקתי עוד יותר ב-Python, והשתמשתי בניתוח נומרי וברשתות עצביות מוכוונות פיזיקה כדי לדמות תהליכים תרמודינמיים - במיוחד התכת רגולית ירחי לטובת ניצול משאבים במושבות ירח עתידיות.''',
    ),
    LocalizedString(
      english:
          '''Today, as a freelancer and educator, my skillset has expanded to include cross-platform mobile app development with Flutter and Dart, which allows me to build visually appealing, modern apps efficiently. I find Flutter's elegance a refreshing alternative to traditional HTML and CSS, aligning perfectly with my passion for creating innovative, user-friendly software solutions.''',
      hebrew:
          '''כיום, כמפתחת עצמאית וכמורה, סט הכישורים שלי התרחב גם לפיתוח אפליקציות חוצות פלטפורמות עם Flutter ו-Dart, שמאפשרים לי לבנות אפליקציות מודרניות, יפות ויעילות. האלגנטיות של Flutter מרגישה לי כמו חלופה מרעננת ל-HTML ו-CSS מסורתיים, והיא משתלבת היטב עם הרצון שלי ליצור פתרונות תוכנה חדשניים וידידותיים למשתמש.''',
    ),
  ],
);

const _experienceSection = PortfolioSection(
  title: LocalizedString(english: 'Experience', hebrew: 'ניסיון'),
  subtitle: LocalizedString(
    english: 'My professional journey',
    hebrew: 'הדרך המקצועית שלי',
  ),
  icon: Icons.work_outline,
  summary: LocalizedString(
    english:
        'AOI process support at Flex (24 June 2026–Present), teaching, accessibility support, cybersecurity instruction, and freelance software development form a practical path centered on clear technical problem solving.',
    hebrew:
        'תמיכה בתהליכי AOI ב-Flex (24 ביוני 2026–היום), הוראה, נגישות, הדרכת סייבר ופיתוח תוכנה עצמאי יוצרים מסלול מעשי שממוקד בפתרון בעיות טכניות בצורה ברורה.',
  ),
  paragraphs: [
    LocalizedString(
      english:
          '''At Flex, I’m excited to work in Process Support AOI (24 June 2026–Present), handling PCBAs and configuring program thresholds. This hands-on role brings together electronics and automated optical inspection, with an emphasis on careful, detail-oriented configuration. I enjoy developing my skills in a field where technology and precision meet.''',
      hebrew:
          '''ב-Flex אני שמחה לעבוד בתפקיד תמיכה בתהליכי AOI (24 ביוני 2026–היום). התפקיד כולל טיפול בכרטיסים אלקטרוניים מורכבים (PCBAs) והגדרת ערכי סף בתוכניות. העבודה המעשית משלבת אלקטרוניקה ובדיקה אופטית אוטומטית, עם דגש על הגדרות מדויקות ותשומת לב לפרטים. אני נהנית לפתח את הכישורים שלי בתחום שמחבר בין טכנולוגיה לדיוק.''',
    ),
    LocalizedString(
      english:
          '''My formal teaching experience began in 2021 at Achva Academic College, where I led database practice sessions for Information Systems students. In that role, I helped students strengthen their understanding of SQL and normalization through focused exercises and step-by-step guidance. This early position established the foundation for my approach as an educator: combining technical clarity with practical problem-solving.''',
      hebrew:
          '''הניסיון הרשמי שלי בהוראה התחיל בשנת 2021 במכללה האקדמית אחוה, שם הובלתי תרגולים במסדי נתונים לסטודנטים למערכות מידע. בתפקיד הזה עזרתי לסטודנטים לחזק את ההבנה שלהם ב-SQL ובנרמול באמצעות תרגול ממוקד והנחיה צעד אחר צעד. התפקיד הראשוני הזה הניח את הבסיס לגישה שלי כמורה: שילוב בין בהירות טכנית לפתרון בעיות מעשי.''',
    ),
    LocalizedString(
      english:
          '''From 2023 to 2024, I continued this path at Sami Shamoon College, tutoring both individuals and small groups in core Software Engineering subjects such as algorithms, data structures, and object-oriented programming. Alongside that work, from 2023 to 2025 I served at the Aleh Association as both a tutor and transcriber, supporting students with disabilities in computer science and software engineering courses. This role required me to adapt explanations to different learning needs, create accessible learning materials and concise technical summaries, and refine academic content so that it remained clear, accurate, and approachable.''',
      hebrew:
          '''בשנים 2023 עד 2024 המשכתי בדרך הזאת במכללה האקדמית להנדסה סמי שמעון, שם לימדתי יחידים וקבוצות קטנות בנושאי ליבה בהנדסת תוכנה, כמו אלגוריתמים, מבני נתונים ותכנות מונחה עצמים. במקביל, בשנים 2023 עד 2025, עבדתי בעמותת עלה כמורה וכמתמללת, ותמכתי בסטודנטים עם מוגבלויות בקורסים במדעי המחשב ובהנדסת תוכנה. התפקיד דרש ממני להתאים הסברים לצורכי למידה שונים, ליצור חומרי למידה נגישים וסיכומים טכניים תמציתיים, ולדייק תוכן אקדמי כך שיישאר ברור, נכון ונגיש.''',
    ),
    LocalizedString(
      english:
          '''Since 2025, my experience has expanded into several parallel roles. As a tutor at Alut Organization and Ono Academic College, I teach students on the spectrum in computer science and mathematics, with a strong emphasis on hands-on practice and guided exercise solving. In parallel, I work as an instructor at the Cyber Education Centre, where I teach a communication networks course for high-achieving high school students in the Magshimim program. There, I focus on building strong foundations in networking and cybersecurity while making the material concrete through practical work.''',
      hebrew:
          '''מאז 2025 הניסיון שלי התרחב לכמה תפקידים במקביל. כמורה באלו"ט ובקריה האקדמית אונו, אני מלמדת סטודנטים על הרצף בתחומי מדעי המחשב ומתמטיקה, עם דגש חזק על תרגול מעשי ופתרון מודרך של תרגילים. במקביל אני מדריכה במרכז לחינוך סייבר, שם אני מלמדת קורס ברשתות תקשורת לתלמידי תיכון מצטיינים בתוכנית מגשימים. שם אני מתמקדת בבניית יסודות חזקים ברשתות ובסייבר, תוך הפיכת החומר למוחשי דרך עבודה מעשית.''',
    ),
    LocalizedString(
      english:
          '''Alongside my educational roles, since 2025 I have also been working as a freelance software developer as a registered sole proprietor. I deliver end-to-end projects for private clients, including mobile applications, websites, and backend systems, and I also provide consultation and implementation support in mathematics, algorithms, and software engineering. Taken together, these experiences reflect a professional path built around teaching, accessibility, and software development, with a consistent focus on helping others solve complex technical problems in a practical way.''',
      hebrew:
          '''לצד התפקידים החינוכיים, מאז 2025 אני עובדת גם כמפתחת תוכנה עצמאית כעוסק מורשה. אני מספקת פרויקטים מקצה לקצה ללקוחות פרטיים, כולל אפליקציות מובייל, אתרים ומערכות backend, וגם מעניקה ייעוץ ותמיכה ביישום בתחומי מתמטיקה, אלגוריתמים והנדסת תוכנה. יחד, החוויות האלה משקפות דרך מקצועית שנבנתה סביב הוראה, נגישות ופיתוח תוכנה, עם מיקוד עקבי בעזרה לאחרים לפתור בעיות טכניות מורכבות בצורה מעשית.''',
    ),
  ],
);

const _researchSection = PortfolioSection(
  title: LocalizedString(english: 'Research', hebrew: 'מחקר'),
  subtitle: LocalizedString(
    english: 'Lunar ISRU focus',
    hebrew: 'מחקר ISRU ירחי',
  ),
  icon: Icons.biotech,
  summary: LocalizedString(
    english:
        'Master\'s research on lunar regolith melting combined heat-transfer simulation, the Stefan problem, and physics-informed neural networks.',
    hebrew:
        'מחקר התואר השני שלי עסק בהתכת רגולית ירחי ושילב סימולציות מעבר חום, את בעיית סטפן ורשתות עצביות מוכוונות פיזיקה.',
  ),
  paragraphs: [
    LocalizedString(
      english:
          '''In my master's research I've explored an innovative approach to In-Situ Resource Utilization (ISRU) aimed at supporting future lunar settlements. Our research focused on harnessing latent heat thermal energy storage within lunar regolith, addressing critical challenges in energy management on the Moon.''',
      hebrew:
          '''במחקר התואר השני שלי חקרתי גישה חדשנית לניצול משאבים מקומיים, ISRU, שמטרתה לתמוך בהתיישבות עתידית על הירח. המחקר התמקד בניצול אגירת אנרגיה תרמית בחום כמוס בתוך רגולית ירחי, כדי להתמודד עם אתגרים משמעותיים בניהול אנרגיה על הירח.''',
    ),
    LocalizedString(
      english:
          '''By developing Python-based simulations, we tackled complex heat transfer problems, specifically solving the Stefan problem and general heat equations. To push the boundaries further, we implemented a Physics-Informed Neural Network (PINN), validating its accuracy against classical analytical and numerical solutions. This work bridges traditional computational modeling with modern machine learning, paving the way for sustainable human presence on the lunar surface.''',
      hebrew:
          '''באמצעות פיתוח סימולציות מבוססות Python התמודדנו עם בעיות מורכבות במעבר חום, ובפרט עם פתרון בעיית סטפן ומשוואות חום כלליות. כדי להרחיב את גבולות המודל יישמנו רשת עצבית מוכוונת פיזיקה, PINN, ואימתנו את הדיוק שלה מול פתרונות אנליטיים ונומריים קלאסיים. העבודה מחברת בין מידול חישובי מסורתי ללמידת מכונה מודרנית, ויכולה לתרום לנוכחות אנושית בת קיימא על פני הירח.''',
    ),
  ],
);

const _hobbiesSection = PortfolioSection(
  title: LocalizedString(english: 'Hobbies', hebrew: 'תחביבים'),
  subtitle: LocalizedString(
    english: 'Yoga, audio, and books',
    hebrew: 'יוגה, אודיו וספרים',
  ),
  icon: Icons.interests,
  summary: LocalizedString(
    english:
        'I enjoy Yin yoga, long-form audio, and books that make me think. I also built an Amazon Polly and S3 text-to-speech workflow with a custom lexicon so written yoga routines could become clear audio instructions.',
    hebrew:
        'אני אוהבת יין יוגה, אודיו ארוך וספרים שגורמים לי לחשוב. בנוסף, בניתי תהליך text-to-speech עם Amazon Polly ו-S3, כולל קובץ lexicon מותאם, כדי להפוך רוטינות יוגה כתובות להוראות אודיו ברורות.',
  ),
  paragraphs: [
    LocalizedString(
      english:
          '''Outside software work, yoga is one of the practices that helps me slow down, listen more carefully, and stay connected to the body rather than only to the screen. I especially like Yin yoga because it is quiet, patient, and precise in a different way from programming: it asks for stillness, attention, and respect for small changes over time.''',
      hebrew:
          '''מחוץ לעבודה עם תוכנה, יוגה היא אחת מהרוטינות שעוזרות לי להאט, להקשיב טוב יותר ולהישאר מחוברת לגוף ולא רק למסך. אני אוהבת במיוחד יין יוגה, כי יש בה שקט, סבלנות ודיוק מסוג אחר מתכנות: היא מבקשת שהייה, תשומת לב וכבוד לשינויים קטנים לאורך זמן.''',
    ),
    LocalizedString(
      english:
          '''That interest also led me to create a text-to-speech service for routine scripts, using Amazon Polly and S3 buckets with a custom lexicon file so the generated audio would pronounce terms naturally and turn written routines into usable spoken instructions. In the same spirit, I enjoy audiobooks, podcasts, and reading books, especially detective stories, mysteries, psychological novels, and clever classics that reward attention and layered thinking.''',
      hebrew:
          '''העניין הזה ברוטינות מוקלטות הוביל אותי גם לבנות שירות text-to-speech לתסריטי תרגול, באמצעות Amazon Polly ו-S3 buckets יחד עם קובץ lexicon מותאם, כדי שהאודיו שנוצר יבטא מונחים בצורה טבעית ויהפוך רוטינות כתובות להוראות קוליות שימושיות. באותה רוח אני אוהבת גם ספרי אודיו, פודקאסטים וקריאת ספרים, במיוחד ספרי בלש, מסתורין, רומנים פסיכולוגיים וקלאסיקות חכמות שמתגמלות תשומת לב וחשיבה בשכבות.''',
    ),
  ],
);

const _longSections = [
  _introSection,
  _educationSection,
  _skillsSection,
  _experienceSection,
  _researchSection,
];

void showLongSection(
  BuildContext context,
  PortfolioLanguage language,
  PortfolioSection section,
) {
  showDialog(
    context: context,
    builder: (_) => _LongSectionDialog(language: language, section: section),
  );
}

class _LongSectionDialog extends StatefulWidget {
  final PortfolioLanguage language;
  final PortfolioSection section;

  const _LongSectionDialog({required this.language, required this.section});

  @override
  State<_LongSectionDialog> createState() => _LongSectionDialogState();
}

class _LongSectionDialogState extends State<_LongSectionDialog> {
  bool _showFullText = true;

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    final summaryLabel = _localized(
      language,
      english: 'TL;DR',
      hebrew: 'בקצרה',
    );
    final toggleLabel = _showFullText
        ? _localized(language, english: 'TL;DR only', hebrew: 'בקצרה בלבד')
        : _localized(
            language,
            english: 'Show full text',
            hebrew: 'הצגת הטקסט המלא',
          );

    return Directionality(
      textDirection: language.direction,
      child: AlertDialog(
        backgroundColor: AppPalette.surface,
        shape: _dialogShape(),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        titleTextStyle: _dialogTitleStyle(context),
        contentTextStyle: _dialogContentStyle(context),
        title: Text(widget.section.title.resolve(language)),
        content: SizedBox(
          width: 520,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.72,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppPalette.tileSurface,
                      border: Border.all(color: AppPalette.border),
                      borderRadius: BorderRadius.circular(_buttonRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summaryLabel,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppPalette.text,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          widget.section.summary.resolve(language),
                          textAlign: language.paragraphAlign,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: language.isHebrew
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() => _showFullText = !_showFullText);
                      },
                      icon: Icon(
                        _showFullText ? Icons.unfold_less : Icons.unfold_more,
                        size: 18,
                      ),
                      label: Text(toggleLabel),
                    ),
                  ),
                  if (_showFullText)
                    for (final paragraph in widget.section.paragraphs) ...[
                      const SizedBox(height: 12),
                      SelectableText(
                        paragraph.resolve(language),
                        textAlign: language.paragraphAlign,
                      ),
                    ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_closeLabel(language)),
          ),
        ],
      ),
    );
  }
}

void showContact(BuildContext context, PortfolioLanguage language) {
  const contactEmails = ['lubacareer@gmail.com', 'lubani@lubacorp.com'];

  showDialog(
    context: context,
    builder: (_) => Directionality(
      textDirection: language.direction,
      child: AlertDialog(
        backgroundColor: AppPalette.surface,
        shape: _dialogShape(),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        titleTextStyle: _dialogTitleStyle(context),
        contentTextStyle: _dialogContentStyle(context),
        title: Text(
          _localized(language, english: 'Contact Me', hebrew: 'יצירת קשר'),
        ),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localized(
                  language,
                  english: 'Feel free to reach out via email:',
                  hebrew: 'אפשר לפנות אליי במייל:',
                ),
                textAlign: language.paragraphAlign,
              ),
              const SizedBox(height: 12),
              for (final email in contactEmails) ...[
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: SelectableText(
                    email,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: AppPalette.text),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final email in contactEmails)
                    OutlinedButton.icon(
                      onPressed: () => openEmail(email),
                      icon: const Icon(
                        Icons.email_outlined,
                        color: AppPalette.mutedText,
                        size: 18,
                      ),
                      label: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(email),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppPalette.primaryDeep,
                        side: const BorderSide(color: AppPalette.border),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_closeLabel(language)),
          ),
        ],
      ),
    ),
  );
}

class PortfolioProject {
  final String owner;
  final String name;
  final LocalizedString? description;
  final String? programmingLanguage;
  final String githubUrl;
  final bool isFork;

  const PortfolioProject({
    required this.owner,
    required this.name,
    required this.githubUrl,
    this.description,
    this.programmingLanguage,
    this.isFork = false,
  });

  String summary(PortfolioLanguage language) {
    final value = description?.resolve(language).trim();
    if (value == null || value.isEmpty) {
      return _localized(
        language,
        english: 'Public GitHub repository.',
        hebrew: 'מאגר GitHub ציבורי.',
      );
    }
    return value;
  }

  String metadata(PortfolioLanguage language) {
    final parts = <String>[owner];
    if (programmingLanguage != null && programmingLanguage!.isNotEmpty) {
      parts.add(programmingLanguage!);
    }
    if (isFork) {
      parts.add(_localized(language, english: 'Fork', hebrew: 'Fork'));
    }
    return parts.join(' - ');
  }
}

const _githubProjects = <PortfolioProject>[
  PortfolioProject(
    owner: 'lubacareer',
    name: 'ExitViolet',
    description: LocalizedString(
      english:
          'Browser-first isometric psychological thriller prototype built with Phaser, TypeScript, and Vite. It presents a playable vertical slice with a DOM menu overlay, opening video, exploration, scene blockers, interactive hotspots, and Playwright smoke coverage.',
      hebrew:
          'אב-טיפוס למשחק מתח פסיכולוגי איזומטרי בדפדפן, שנבנה עם Phaser, TypeScript ו-Vite. כולל חתך משחקי עם תפריט DOM, סרטון פתיחה, חקירה, חסימות סצנה, נקודות אינטראקציה וכיסוי smoke tests ב-Playwright.',
    ),
    programmingLanguage: 'TypeScript',
    githubUrl: 'https://github.com/lubacareer/ExitViolet',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'CML',
    description: LocalizedString(
      english:
          'A point-and-click comedy mystery built with Phaser and TypeScript, featuring interactive scenes, dialogue, inventory, and puzzles.',
      hebrew:
          'משחק תעלומת קומדיה בסגנון הצבעה ולחיצה, שנבנה עם Phaser ו־TypeScript ומשלב סצנות אינטראקטיביות, דיאלוגים, מלאי וחידות.',
    ),
    programmingLanguage: 'TypeScript',
    githubUrl: 'https://github.com/lubacareer/CML',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'spritebury',
    description: LocalizedString(
      english:
          'A virtual city web game with avatar creation, profiles, and a marketplace, built with Next.js and TypeScript.',
      hebrew:
          'משחק עיר וירטואלית ברשת הכולל יצירת דמויות, פרופילים ושוק מקוון, שנבנה עם Next.js ו־TypeScript.',
    ),
    programmingLanguage: 'TypeScript',
    githubUrl: 'https://github.com/lubacareer/spritebury',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'ast2',
    description: LocalizedString(
      english: 'All-in-one Astrology app',
      hebrew: 'אפליקציית אסטרולוגיה כוללת במקום אחד',
    ),
    programmingLanguage: 'Dart',
    githubUrl: 'https://github.com/lubacareer/ast2',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'Mazilon',
    description: LocalizedString(
      english:
          'Mezilon is a Flutter-based mobile application designed to provide mental health support and personal planning tools.',
      hebrew:
          'מזילון היא אפליקציית Flutter למובייל שמיועדת לתמיכה בבריאות הנפש ולכלי תכנון אישי.',
    ),
    programmingLanguage: 'Dart',
    githubUrl: 'https://github.com/lubacareer/Mazilon',
    isFork: true,
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'HeatEquationSimulator',
    description: LocalizedString(
      english:
          'An experimental Python desktop simulator for exploring heat transfer, phase changes, and related physics through interactive visualizations.',
      hebrew:
          'סימולטור ניסיוני למחשב ב־Python לחקר מעבר חום, שינויי פאזה ותופעות פיזיקליות קשורות באמצעות הדמיות אינטראקטיביות.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubacareer/HeatEquationSimulator',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'portfolio',
    description: LocalizedString(
      english:
          'A bilingual Flutter portfolio presenting professional experience, projects, education, and contact information.',
      hebrew:
          'אתר תיק עבודות דו־לשוני ב־Flutter המציג ניסיון מקצועי, פרויקטים, השכלה ופרטי קשר.',
    ),
    programmingLanguage: 'Dart',
    githubUrl: 'https://github.com/lubacareer/portfolio',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'ccomp',
    description: LocalizedString(
      english:
          'An educational C compiler that parses a subset of C, performs semantic checks, and generates intermediate code and x86-64 assembly.',
      hebrew:
          'מהדר לימודי לשפת C שמנתח תת־קבוצה של השפה, מבצע בדיקות סמנטיות ומפיק קוד ביניים ואסמבלי ל־x86-64.',
    ),
    programmingLanguage: 'C',
    githubUrl: 'https://github.com/lubacareer/ccomp',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'astro',
    description: LocalizedString(
      english:
          'A Flutter astrology app with screens for natal charts and aspects.',
      hebrew:
          'אפליקציית אסטרולוגיה ב־Flutter עם מסכים למפות לידה ולהיבטים אסטרולוגיים.',
    ),
    programmingLanguage: 'C++',
    githubUrl: 'https://github.com/lubani/astro',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'Portfolio',
    description: LocalizedString(
      english: 'An earlier personal portfolio built with Next.js and React.',
      hebrew: 'גרסה קודמת של תיק עבודות אישי שנבנתה באמצעות Next.js ו־React.',
    ),
    programmingLanguage: 'JavaScript',
    githubUrl: 'https://github.com/lubani/Portfolio',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'math',
    description: LocalizedString(
      english:
          'Python scripts illustrating mathematical concepts, calculations, and visualizations.',
      hebrew: 'אוסף סקריפטים ב־Python להמחשת מושגים מתמטיים, חישובים והדמיות.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/math',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'scientificProject',
    description: LocalizedString(
      english:
          'A Python desktop research application exploring two-phase Stefan problems with physics-informed neural networks and analytical and numerical methods.',
      hebrew:
          'יישום מחקרי לשולחן העבודה ב־Python לחקר בעיית סטפן דו־פאזית באמצעות רשתות נוירונים מונחות פיזיקה ושיטות אנליטיות ונומריות.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/scientificProject',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'HebSum',
    description: LocalizedString(
      english:
          'A Hebrew text summarization prototype with a Flask service and browser extension.',
      hebrew: 'אב־טיפוס לסיכום טקסט בעברית הכולל שירות Flask ותוסף לדפדפן.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/HebSum',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'MySoftware',
    description: LocalizedString(
      english:
          'A small Python practice repository with simple interaction functions.',
      hebrew:
          'מאגר תרגול קטן ב־Python עם פונקציות בסיסיות המדמות פעולות משתמש.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/MySoftware',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DevOps2412',
    description: LocalizedString(
      english:
          'DevOps course exercises featuring Python scripts and a Jenkins pipeline.',
      hebrew: 'תרגילי קורס DevOps הכוללים סקריפטים ב־Python ותהליך Jenkins.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/DevOps2412',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'hw6',
    description: LocalizedString(
      english:
          'A small Python exercise from the sixth lesson of a DevOps course.',
      hebrew: 'תרגיל Python קצר מהשיעור השישי בקורס DevOps.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/hw6',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: '2412-first-repo2',
    description: LocalizedString(
      english: 'An introductory Git repository containing a simple text file.',
      hebrew: 'מאגר Git ראשוני הכולל קובץ טקסט פשוט.',
    ),
    githubUrl: 'https://github.com/lubani/2412-first-repo2',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'IRCourse',
    description: LocalizedString(
      english:
          'An information retrieval course project exploring review sentiment classification and BART-based text summarization.',
      hebrew:
          'פרויקט בקורס אחזור מידע הבוחן סיווג רגשות בביקורות וסיכום טקסט באמצעות BART.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/IRCourse',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DeepStefan',
    description: LocalizedString(
      english:
          'A fork of research code by Sifan Wang and Paris Perdikaris exploring physics-informed neural networks for Stefan problems.',
      hebrew:
          'עותק מפוצל של קוד מחקר מאת Sifan Wang ו־Paris Perdikaris, הבוחן רשתות נוירונים מונחות פיזיקה לפתרון בעיות סטפן.',
    ),
    githubUrl: 'https://github.com/lubani/DeepStefan',
    isFork: true,
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DjangoMS',
    description: LocalizedString(
      english:
          'A Django REST API for managing countries and their local currencies.',
      hebrew: 'ממשק REST ב־Django לניהול מדינות והמטבעות המקומיים שלהן.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/DjangoMS',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DjangoMSA',
    description: LocalizedString(
      english:
          'A Django website prototype with registration, authentication, and a user forum.',
      hebrew: 'אב־טיפוס לאתר Django הכולל הרשמה, אימות משתמשים ופורום.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/DjangoMSA',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'Summarizer-Extension',
    description: LocalizedString(
      english:
          'A Chrome extension prototype that extracts webpage text and displays a generated summary.',
      hebrew:
          'אב־טיפוס לתוסף Chrome שמחלץ טקסט מדפי אינטרנט ומציג סיכום שנוצר עבורו.',
    ),
    programmingLanguage: 'JavaScript',
    githubUrl: 'https://github.com/lubani/Summarizer-Extension',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'bert-extractive-summarizer',
    description: LocalizedString(
      english:
          'A fork of a BERT-based extractive summarization library that selects representative sentences.',
      hebrew:
          'עותק מפוצל של ספרייה לסיכום טקסט מבוסס BERT, הבוחרת משפטים מייצגים.',
    ),
    githubUrl: 'https://github.com/lubani/bert-extractive-summarizer',
    isFork: true,
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'HebrewSumy',
    description: LocalizedString(
      english:
          'A Hebrew text summarization experiment using Sumy and Hebrew-language tools.',
      hebrew: 'ניסוי לסיכום טקסטים בעברית באמצעות Sumy וכלי עיבוד לשפה העברית.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/HebrewSumy',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'electricity',
    description: LocalizedString(
      english:
          'SMD Twin Lab is a desktop learning tool for exploring PCB behavior and simulated component faults, with an early PCB design workspace.',
      hebrew:
          'SMD Twin Lab הוא כלי לימודי למחשב לחקר התנהגות כרטיסים אלקטרוניים ותקלות רכיבים בסימולציה, לצד סביבת תכנון PCB ראשונית.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubacareer/electricity',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'finance1',
    description: LocalizedString(
      english:
          'A local-first Flutter financial diary for tracking accounts, income and expenses, reviewing imported statements, and exploring cash flow.',
      hebrew:
          'יומן פיננסי ב־Flutter השומר מידע מקומית ומאפשר מעקב אחר חשבונות, הכנסות והוצאות, סקירת דפי חשבון מיובאים ובחינת תזרים מזומנים.',
    ),
    programmingLanguage: 'Dart',
    githubUrl: 'https://github.com/lubacareer/finance1',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'jupiter',
    description: LocalizedString(
      english:
          'An early research prototype exploring Jupiter\'s moons through orbital simulations and a separate, simplified Europa ice–ocean model.',
      hebrew:
          'אב־טיפוס מחקרי ראשוני לחקר ירחי צדק באמצעות סימולציות מסלול ומודל נפרד ומפושט של הקרח והאוקיינוס באירופה.',
    ),
    programmingLanguage: 'TypeScript',
    githubUrl: 'https://github.com/lubacareer/jupiter',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'Nasa2',
    description: LocalizedString(
      english:
          'An exploratory surface-change visualization inspired by NISAR radar observations, currently using synthetic preview data.',
      hebrew:
          'כלי ניסיוני להדמיית שינויים על פני השטח בהשראת תצפיות המכ״ם של NISAR, המבוסס כרגע על נתוני הדגמה סינתטיים.',
    ),
    programmingLanguage: 'TypeScript',
    githubUrl: 'https://github.com/lubacareer/Nasa2',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'nasaCLPS-releases',
    description: LocalizedString(
      english:
          'A planned public distribution repository for Trend Detective desktop downloads.',
      hebrew: 'מאגר ציבורי מתוכנן להפצת Trend Detective למחשבים.',
    ),
    githubUrl: 'https://github.com/lubacareer/nasaCLPS-releases',
  ),
];

void showProjects(
  BuildContext context,
  PortfolioLanguage language, {
  GitHubRepositoryLoader? loadGitHubRepositories,
}) {
  showDialog(
    context: context,
    builder: (_) => Directionality(
      textDirection: language.direction,
      child: AlertDialog(
        backgroundColor: AppPalette.surface,
        shape: _dialogShape(),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        titleTextStyle: _dialogTitleStyle(context),
        contentTextStyle: _dialogContentStyle(context),
        title: Text(
          _localized(language, english: 'Projects', hebrew: 'פרויקטים'),
        ),
        content: SizedBox(
          width: 560,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.72,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localized(
                      language,
                      english:
                          'Public GitHub repositories from lubacareer and lubani.',
                      hebrew:
                          'מאגרי GitHub ציבוריים מהחשבונות lubacareer ו-lubani.',
                    ),
                    textAlign: language.paragraphAlign,
                  ),
                  const SizedBox(height: 16),
                  _ProjectOwnerSection(
                    owner: 'lubacareer',
                    language: language,
                    loadRepositories:
                        loadGitHubRepositories ?? loadPublicGitHubRepositories,
                  ),
                  const SizedBox(height: 18),
                  _ProjectOwnerSection(
                    owner: 'lubani',
                    language: language,
                    loadRepositories:
                        loadGitHubRepositories ?? loadPublicGitHubRepositories,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_closeLabel(language)),
          ),
        ],
      ),
    ),
  );
}

class _ProjectOwnerSection extends StatefulWidget {
  final String owner;
  final PortfolioLanguage language;
  final GitHubRepositoryLoader loadRepositories;

  const _ProjectOwnerSection({
    required this.owner,
    required this.language,
    required this.loadRepositories,
  });

  @override
  State<_ProjectOwnerSection> createState() => _ProjectOwnerSectionState();
}

class _ProjectOwnerSectionState extends State<_ProjectOwnerSection> {
  late Future<List<GitHubRepository>> _repositories;

  @override
  void initState() {
    super.initState();
    _repositories = widget.loadRepositories(widget.owner);
  }

  void _retry() {
    setState(() {
      _repositories = widget.loadRepositories(widget.owner);
    });
  }

  PortfolioProject _toProject(GitHubRepository repository) {
    PortfolioProject? curated;
    for (final project in _githubProjects) {
      if (project.owner.toLowerCase() == widget.owner.toLowerCase() &&
          project.name.toLowerCase() == repository.name.toLowerCase()) {
        curated = project;
        break;
      }
    }
    final description = repository.description?.trim();
    return PortfolioProject(
      owner: widget.owner,
      name: repository.name,
      githubUrl: repository.htmlUrl,
      description:
          curated?.description ??
          (description == null || description.isEmpty
              ? null
              : LocalizedString(english: description, hebrew: description)),
      programmingLanguage: repository.language,
      isFork: repository.isFork,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    return FutureBuilder<List<GitHubRepository>>(
      future: _repositories,
      builder: (context, snapshot) {
        final loading = snapshot.connectionState != ConnectionState.done;
        final failed = snapshot.hasError;
        final projects = failed
            ? _githubProjects
                  .where((project) => project.owner == widget.owner)
                  .toList()
            : (snapshot.data ?? []).map(_toProject).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loading ? widget.owner : '${widget.owner} (${projects.length})',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppPalette.text,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            if (loading)
              Text(
                _localized(
                  language,
                  english: 'Loading repositories...',
                  hebrew: 'טוען מאגרים...',
                ),
              )
            else if (failed) ...[
              Text(
                _localized(
                  language,
                  english:
                      'Could not load repositories. Showing saved projects.',
                  hebrew: 'לא ניתן לטעון מאגרים. מוצגים פרויקטים שמורים.',
                ),
              ),
              TextButton(
                onPressed: _retry,
                child: Text(
                  _localized(language, english: 'Retry', hebrew: 'ניסיון חוזר'),
                ),
              ),
            ] else if (projects.isEmpty)
              Text(
                _localized(
                  language,
                  english: 'No public repositories found.',
                  hebrew: 'לא נמצאו מאגרים ציבוריים.',
                ),
              ),
            for (final project in projects)
              _ProjectListItem(project: project, language: language),
          ],
        );
      },
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  final PortfolioProject project;
  final PortfolioLanguage language;

  const _ProjectListItem({required this.project, required this.language});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: () => showProjectDetails(context, language, project),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.primaryDeep,
          side: const BorderSide(color: AppPalette.border),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.code, color: AppPalette.mutedText, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: AppPalette.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.metadata(language),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.subtleText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.summary(language),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.open_in_new,
              color: AppPalette.subtleText,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

void showProjectDetails(
  BuildContext context,
  PortfolioLanguage language,
  PortfolioProject project,
) {
  final media = mediaForProject(project.owner, project.name);
  showDialog(
    context: context,
    builder: (_) => Directionality(
      textDirection: language.direction,
      child: AlertDialog(
        backgroundColor: AppPalette.surface,
        shape: _dialogShape(),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        titleTextStyle: _dialogTitleStyle(context),
        contentTextStyle: _dialogContentStyle(context),
        title: Text(project.name),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.metadata(language),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppPalette.subtleText),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  project.summary(language),
                  textAlign: language.paragraphAlign,
                ),
                if (media != null && media.screenshots.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    _localized(
                      language,
                      english: 'Project screenshots',
                      hebrew: 'צילומי מסך של הפרויקט',
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: AppPalette.text),
                  ),
                  for (final screenshot in media.screenshots) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => _showScreenshotViewer(
                          context,
                          language,
                          screenshot,
                        ),
                        child: Image.asset(
                          screenshot.asset,
                          semanticLabel: language.isHebrew
                              ? screenshot.hebrewLabel
                              : screenshot.englishLabel,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      language.isHebrew
                          ? screenshot.hebrewLabel
                          : screenshot.englishLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.subtleText,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          _showScreenshotViewer(context, language, screenshot),
                      icon: const Icon(Icons.zoom_in),
                      label: Text(
                        _localized(
                          language,
                          english: 'Enlarge screenshot',
                          hebrew: 'הגדלת צילום המסך',
                        ),
                      ),
                    ),
                  ],
                ],
                if (media != null && media.videos.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    _localized(
                      language,
                      english: 'Magnetic torus simulation demonstrations',
                      hebrew: 'הדגמות סימולציה של טורוס מגנטי',
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: AppPalette.text),
                  ),
                  for (final video in media.videos)
                    _ProjectVideo(video: video, language: language),
                ],
                const SizedBox(height: 12),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => openPublic(project.githubUrl),
                    icon: const Icon(
                      Icons.link,
                      color: AppPalette.mutedText,
                      size: 18,
                    ),
                    label: Text(
                      _localized(
                        language,
                        english: 'View on GitHub',
                        hebrew: 'צפייה ב-GitHub',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppPalette.primaryDeep,
                      side: const BorderSide(color: AppPalette.border),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_closeLabel(language)),
          ),
        ],
      ),
    ),
  );
}

void _showScreenshotViewer(
  BuildContext context,
  PortfolioLanguage language,
  ProjectScreenshot screenshot,
) {
  showDialog<void>(
    context: context,
    builder: (_) => Directionality(
      textDirection: language.direction,
      child: _ProjectScreenshotViewer(
        language: language,
        screenshot: screenshot,
      ),
    ),
  );
}

class _ProjectScreenshotViewer extends StatefulWidget {
  const _ProjectScreenshotViewer({
    required this.language,
    required this.screenshot,
  });

  final PortfolioLanguage language;
  final ProjectScreenshot screenshot;

  @override
  State<_ProjectScreenshotViewer> createState() =>
      _ProjectScreenshotViewerState();
}

class _ProjectScreenshotViewerState extends State<_ProjectScreenshotViewer> {
  final _transform = TransformationController();

  @override
  void initState() {
    super.initState();
    _transform.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _transform.removeListener(_refresh);
    _transform.dispose();
    super.dispose();
  }

  void _setTransform(double scale, double x, double y, Size viewport) {
    final maxX = (scale - 1) * viewport.width;
    final maxY = (scale - 1) * viewport.height;
    _transform.value = Matrix4.diagonal3Values(scale, scale, 1)
      ..setTranslationRaw(x.clamp(-maxX, 0), y.clamp(-maxY, 0), 0);
  }

  void _zoom(double factor, Size viewport) {
    final current = _transform.value;
    final oldScale = current.getMaxScaleOnAxis();
    final nextScale = (oldScale * factor).clamp(1.0, 4.0);
    final ratio = nextScale / oldScale;
    _setTransform(
      nextScale,
      current.storage[12] * ratio + viewport.width * (1 - ratio) / 2,
      current.storage[13] * ratio + viewport.height * (1 - ratio) / 2,
      viewport,
    );
  }

  void _pan(double dx, double dy, Size viewport) {
    final current = _transform.value;
    _setTransform(
      current.getMaxScaleOnAxis(),
      current.storage[12] + dx,
      current.storage[13] + dy,
      viewport,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    final caption = language.isHebrew
        ? widget.screenshot.hebrewLabel
        : widget.screenshot.englishLabel;
    final scale = _transform.value.getMaxScaleOnAxis();
    return Dialog(
      backgroundColor: AppPalette.surface,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 1100,
        height: MediaQuery.sizeOf(context).height * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(caption)),
                      IconButton(
                        tooltip: _closeLabel(language),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, imageConstraints) {
                        var viewport = imageConstraints.biggest;
                        String label(String english, String hebrew) =>
                            _localized(
                              language,
                              english: english,
                              hebrew: hebrew,
                            );
                        return Column(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, viewerConstraints) {
                                  viewport = viewerConstraints.biggest;
                                  return InteractiveViewer(
                                    transformationController: _transform,
                                    minScale: 1,
                                    maxScale: 4,
                                    child: SizedBox.expand(
                                      child: Image.asset(
                                        widget.screenshot.asset,
                                        semanticLabel: caption,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                IconButton(
                                  tooltip: label('Zoom in', 'הגדלה'),
                                  onPressed: scale < 4
                                      ? () => _zoom(1.5, viewport)
                                      : null,
                                  icon: const Icon(Icons.zoom_in),
                                ),
                                IconButton(
                                  tooltip: label('Zoom out', 'הקטנה'),
                                  onPressed: scale > 1
                                      ? () => _zoom(1 / 1.5, viewport)
                                      : null,
                                  icon: const Icon(Icons.zoom_out),
                                ),
                                IconButton(
                                  tooltip: label('Reset zoom', 'איפוס תצוגה'),
                                  onPressed: scale > 1
                                      ? () => _transform.value =
                                            Matrix4.identity()
                                      : null,
                                  icon: const Icon(Icons.fit_screen),
                                ),
                                for (final direction in [
                                  (
                                    Icons.arrow_left,
                                    -100.0,
                                    0.0,
                                    'Move image left',
                                    'הזזת התמונה שמאלה',
                                  ),
                                  (
                                    Icons.arrow_right,
                                    100.0,
                                    0.0,
                                    'Move image right',
                                    'הזזת התמונה ימינה',
                                  ),
                                  (
                                    Icons.arrow_upward,
                                    0.0,
                                    -100.0,
                                    'Move image up',
                                    'הזזת התמונה למעלה',
                                  ),
                                  (
                                    Icons.arrow_downward,
                                    0.0,
                                    100.0,
                                    'Move image down',
                                    'הזזת התמונה למטה',
                                  ),
                                ])
                                  IconButton(
                                    tooltip: label(direction.$4, direction.$5),
                                    onPressed: scale > 1
                                        ? () => _pan(
                                            direction.$2,
                                            direction.$3,
                                            viewport,
                                          )
                                        : null,
                                    icon: Icon(direction.$1),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProjectVideo extends StatefulWidget {
  const _ProjectVideo({required this.video, required this.language});

  final ProjectVideo video;
  final PortfolioLanguage language;

  @override
  State<_ProjectVideo> createState() => _ProjectVideoState();
}

class _ProjectVideoState extends State<_ProjectVideo> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    final title = language.isHebrew
        ? widget.video.hebrewLabel
        : widget.video.englishLabel;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              if (width < 200) return const SizedBox.shrink();
              final height = (width * 9 / 16).clamp(200.0, double.infinity);
              return SizedBox(
                width: width,
                height: height,
                child: _loaded
                    ? YouTubePlayer(
                        key: ValueKey('youtube-player-${widget.video.id}'),
                        videoId: widget.video.id,
                        title: title,
                        fallbackMessage: _localized(
                          language,
                          english:
                              'Embedded playback is unavailable on this device. Use Watch on YouTube below.',
                          hebrew:
                              'הנגן המוטמע אינו זמין במכשיר זה. אפשר לצפות ב-YouTube באמצעות הקישור למטה.',
                        ),
                      )
                    : Material(
                        color: AppPalette.tileSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppPalette.border),
                        ),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: () => setState(() => _loaded = true),
                            icon: const Icon(Icons.play_circle_outline),
                            label: Text(
                              _localized(
                                language,
                                english: 'Load video',
                                hebrew: 'טעינת סרטון',
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            },
          ),
          TextButton.icon(
            onPressed: () => openPublic(widget.video.watchUrl),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text(
              _localized(
                language,
                english: 'Watch on YouTube',
                hebrew: 'צפייה ב-YouTube',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoverTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData icon;

  const HoverTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.icon,
  });

  @override
  State<HoverTile> createState() => _HoverTileState();
}

class _HoverTileState extends State<HoverTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _tileFill(hovered: _hovered, pressed: _pressed),
          border: Border.all(
            color: _tileBorder(hovered: _hovered, pressed: _pressed),
          ),
          borderRadius: BorderRadius.circular(_tileRadius),
          boxShadow: _tileShadows(hovered: _hovered, pressed: _pressed),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(_tileRadius),
          onHighlightChanged: (v) => setState(() => _pressed = v),
          onTap: widget.onTap,
          splashColor: AppPalette.accentGlow,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(widget.icon, color: AppPalette.mutedText),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppPalette.text,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppPalette.mutedText),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedOpacity(
                      opacity: _hovered ? 1 : 0,
                      duration: const Duration(milliseconds: 120),
                      child: const Icon(
                        Icons.open_in_new,
                        color: AppPalette.mutedText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CvTile extends StatefulWidget {
  final PortfolioLanguage language;

  const CvTile({super.key, required this.language});

  @override
  State<CvTile> createState() => _CvTileState();
}

class _CvTileState extends State<CvTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final language = widget.language;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _hovered = !_hovered),
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _tileFill(hovered: _hovered, pressed: _pressed),
            border: Border.all(
              color: _tileBorder(hovered: _hovered, pressed: _pressed),
            ),
            borderRadius: BorderRadius.circular(_tileRadius),
            boxShadow: _tileShadows(hovered: _hovered, pressed: _pressed),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      color: AppPalette.mutedText,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _localized(
                          language,
                          english: 'CV',
                          hebrew: 'קורות חיים',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppPalette.text,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_hovered)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => openPublic('/docs/CV1.pdf'),
                          icon: const Icon(
                            Icons.description,
                            color: AppPalette.mutedText,
                            size: 18,
                          ),
                          label: Text(
                            _localized(
                              language,
                              english: 'English',
                              hebrew: 'אנגלית',
                            ),
                            softWrap: false,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPalette.primaryDeep,
                            side: const BorderSide(color: AppPalette.border),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => openPublic('/docs/CV1heb.pdf'),
                          icon: const Icon(
                            Icons.description,
                            color: AppPalette.mutedText,
                            size: 18,
                          ),
                          label: Text(
                            _localized(
                              language,
                              english: 'Hebrew',
                              hebrew: 'עברית',
                            ),
                            softWrap: false,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPalette.primaryDeep,
                            side: const BorderSide(color: AppPalette.border),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _localized(
                            language,
                            english: 'Hover to choose',
                            hebrew: 'רחף כדי לבחור',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppPalette.mutedText),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.folder_open,
                        color: AppPalette.mutedText,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CoverLetterTile extends StatefulWidget {
  final PortfolioLanguage language;

  const CoverLetterTile({super.key, required this.language});

  @override
  State<CoverLetterTile> createState() => _CoverLetterTileState();
}

class _CoverLetterTileState extends State<CoverLetterTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final language = widget.language;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _hovered = !_hovered),
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _tileFill(hovered: _hovered, pressed: _pressed),
            border: Border.all(
              color: _tileBorder(hovered: _hovered, pressed: _pressed),
            ),
            borderRadius: BorderRadius.circular(_tileRadius),
            boxShadow: _tileShadows(hovered: _hovered, pressed: _pressed),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_note, color: AppPalette.mutedText),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _localized(
                          language,
                          english: 'Cover Letter',
                          hebrew: 'מכתב מקדים',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppPalette.text,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_hovered)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => openPublic('/docs/CL1.pdf'),
                          icon: const Icon(
                            Icons.description,
                            color: AppPalette.mutedText,
                            size: 18,
                          ),
                          label: Text(
                            _localized(
                              language,
                              english: 'English',
                              hebrew: 'אנגלית',
                            ),
                            softWrap: false,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPalette.primaryDeep,
                            side: const BorderSide(color: AppPalette.border),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => openPublic('/docs/CL1heb.pdf'),
                          icon: const Icon(
                            Icons.description,
                            color: AppPalette.mutedText,
                            size: 18,
                          ),
                          label: Text(
                            _localized(
                              language,
                              english: 'Hebrew',
                              hebrew: 'עברית',
                            ),
                            softWrap: false,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppPalette.primaryDeep,
                            side: const BorderSide(color: AppPalette.border),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _localized(
                            language,
                            english: 'Hover to choose',
                            hebrew: 'רחף כדי לבחור',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppPalette.mutedText),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.folder_open,
                        color: AppPalette.mutedText,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
