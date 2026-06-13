import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppPalette {
  static const background = Color(0xFFEAFBF2);
  static const backgroundWarm = Color(0xFFFFFAEA);
  static const backgroundCool = Color(0xFFDFF7FF);
  static const surface = Color(0xFFF8FFF9);
  static const tileSurface = Color(0xF2FFFFFF);
  static const tileHover = Color(0xFFE0FFF3);
  static const tilePressed = Color(0xFFFFECE7);
  static const primary = Color(0xFF0EAD8B);
  static const primaryDeep = Color(0xFF103C36);
  static const accent = Color(0xFFFF7F6E);
  static const text = Color(0xFF123B35);
  static const mutedText = Color(0xFF4C7068);
  static const subtleText = Color(0xFF78918A);
  static const border = Color(0x6637C8A2);
  static const hoverBorder = Color(0x9937C8A2);
  static const pressedBorder = Color(0x99FF7F6E);
  static const primaryGlow = Color(0x3337C8A2);
  static const accentGlow = Color(0x33FF7F6E);
  static const tileShadow = Color(0x1F0EAD8B);
  static const imageFallback = Color(0xFFE3F8EF);
  static const onAccent = Color(0xFFFFFFFF);
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
  const PortfolioApp({super.key});

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
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppPalette.background,
        colorScheme: const ColorScheme.light(
          surface: AppPalette.surface,
          primary: AppPalette.primary,
          onPrimary: AppPalette.onAccent,
          secondary: AppPalette.accent,
          onSecondary: AppPalette.primaryDeep,
          onSurface: AppPalette.text,
          outline: AppPalette.border,
        ),
        fontFamily: 'PlaypenSansThai',
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

  const PortfolioHome({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      for (final section in _longSections)
        HoverTile(
          title: section.title.resolve(language),
          subtitle: section.subtitle.resolve(language),
          onTap: () => showLongSection(context, language, section),
          icon: section.icon,
        ),
      HoverTile(
        title: _localized(language, english: 'Projects', hebrew: 'פרויקטים'),
        subtitle: _localized(
          language,
          english: 'My builds',
          hebrew: 'הפרויקטים שלי',
        ),
        onTap: () => showProjects(context, language),
        icon: Icons.dashboard_customize,
      ),
      HoverTile(
        title: _localized(language, english: 'Hobbies', hebrew: 'תחביבים'),
        subtitle: _localized(
          language,
          english: 'Yoga, audio, and books',
          hebrew: 'יוגה, אודיו וספרים',
        ),
        onTap: () => showLongSection(context, language, _hobbiesSection),
        icon: Icons.interests,
      ),
      HoverTile(
        title: _localized(language, english: 'Contact', hebrew: 'יצירת קשר'),
        subtitle: _localized(
          language,
          english: 'Email me',
          hebrew: 'שלחו לי מייל',
        ),
        onTap: () => showContact(context, language),
        icon: Icons.email_outlined,
      ),
      CvTile(language: language),
      CoverLetterTile(language: language),
      HoverTile(
        title: _localized(
          language,
          english: "Master's Diploma",
          hebrew: 'תעודת תואר שני',
        ),
        subtitle: _localized(
          language,
          english: 'M.Sc. certificate',
          hebrew: 'אישור תואר M.Sc.',
        ),
        onTap: () => openPublic('/docs/masters_public.pdf'),
        icon: Icons.workspace_premium_outlined,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppPalette.background,
              AppPalette.backgroundWarm,
              AppPalette.backgroundCool,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: AspectRatio(
                        aspectRatio: 2048 / 1136,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.network(
                            '/images/meformal.png',
                            fit: BoxFit.cover,
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
                    const SizedBox(height: 16),
                    Text(
                      _localized(
                        language,
                        english: "Luba Ira Korlat",
                        hebrew: 'לובה אירה קורלט',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppPalette.primaryDeep,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _localized(
                        language,
                        english:
                            'Software Engineer | Python | TypeScript | Flutter | Backend | AI/NLP',
                        hebrew:
                            'מהנדסת תוכנה | Python | TypeScript | Flutter | Backend | AI/NLP',
                      ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPalette.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Text(
                        _localized(
                          language,
                          english:
                              'M.Sc. Software Engineering graduate building practical apps, backend systems, AI/NLP tools, and polished client projects.',
                          hebrew:
                              'בוגרת תואר שני בהנדסת תוכנה שבונה אפליקציות, מערכות Backend, כלי AI/NLP ופרויקטים מלוטשים ללקוחות.',
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPalette.mutedText,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _LanguageSelector(
                      language: language,
                      onLanguageChanged: onLanguageChanged,
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        int cols;
                        if (w >= 1000) {
                          cols = 4;
                        } else if (w >= 600) {
                          cols = 2;
                        } else {
                          cols = 1;
                        }
                        const spacing = 24.0;
                        const tileHeight = 150.0;
                        final tileWidth = (w - (spacing * (cols - 1))) / cols;
                        final documentTileWidth = cols >= 4
                            ? (w - tileWidth - (spacing * 2)) / 2
                            : cols == 2
                            ? w
                            : tileWidth;

                        return Wrap(
                          alignment: WrapAlignment.center,
                          spacing: spacing,
                          runSpacing: spacing,
                          children: tiles.map((tile) {
                            final isDocumentTile =
                                tile is CvTile || tile is CoverLetterTile;

                            return SizedBox(
                              width: isDocumentTile
                                  ? documentTileWidth
                                  : tileWidth,
                              height: tileHeight,
                              child: tile,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
        'Broad software foundation across Python, C, C++, Java, SQL, Linux, machine learning, Flutter, and practical teaching-oriented problem solving.',
    hebrew:
        'בסיס תוכנה רחב הכולל Python, C, C++, Java, SQL, Linux, למידת מכונה, Flutter ופתרון בעיות מעשי עם אוריינטציה להוראה.',
  ),
  paragraphs: [
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
        'Teaching, accessibility support, cybersecurity instruction, and freelance software development form a practical path centered on clear technical problem solving.',
    hebrew:
        'הוראה, נגישות, הדרכת סייבר ופיתוח תוכנה עצמאי יוצרים מסלול מעשי שממוקד בפתרון בעיות טכניות בצורה ברורה.',
  ),
  paragraphs: [
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
          'The Case of the Missing Logic is a 2D point-and-click comedy mystery built with Phaser, TypeScript, and Vite. The current slice includes scene navigation, character movement, branching dialogue, inventory, map gating, and a playable puzzle chain.',
      hebrew:
          'The Case of the Missing Logic הוא משחק מסתורין קומי דו-ממדי בסגנון point-and-click, שנבנה עם Phaser, TypeScript ו-Vite. החתך הנוכחי כולל ניווט בין סצנות, תנועת דמות, דיאלוג מסתעף, מלאי, פתיחת מפה ושרשרת חידות משחקית.',
    ),
    programmingLanguage: 'TypeScript',
    githubUrl: 'https://github.com/lubacareer/CML',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'spritebury',
    description: LocalizedString(
      english:
          'A nostalgic browser-based virtual city and social web game in early Next.js/Supabase development. The design focuses on accounts, static pixel avatars, profiles, inventory ownership, shops, jobs, fake currency, homes, presence, and server-authoritative game actions.',
      hebrew:
          'משחק עיר וירטואלית וחברתית בדפדפן, בסגנון נוסטלגי, בשלבי פיתוח ראשונים עם Next.js ו-Supabase. התכנון מתמקד בחשבונות, אווטארים סטטיים בפיקסל-ארט, פרופילים, בעלות על מלאי, חנויות, עבודות, מטבע משחקי, בתים, נוכחות ופעולות משחק שמאומתות בשרת.',
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
      english: 'Heat equation and Stefan problem addressed.',
      hebrew: 'סימולציה ופתרון של משוואת החום ובעיית סטפן.',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubacareer/HeatEquationSimulator',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'portfolio',
    description: LocalizedString(
      english: 'My new portfolio website',
      hebrew: 'אתר הפורטפוליו החדש שלי',
    ),
    programmingLanguage: 'Dart',
    githubUrl: 'https://github.com/lubacareer/portfolio',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'ccomp',
    description: LocalizedString(
      english: 'A robust C compiler',
      hebrew: 'מהדר C יציב ורחב יכולות',
    ),
    programmingLanguage: 'C',
    githubUrl: 'https://github.com/lubacareer/ccomp',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'astro',
    description: LocalizedString(
      english: 'An Astrology App',
      hebrew: 'אפליקציית אסטרולוגיה',
    ),
    programmingLanguage: 'C++',
    githubUrl: 'https://github.com/lubani/astro',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'Portfolio',
    description: LocalizedString(
      english: 'My personal portfolio source code.',
      hebrew: 'קוד המקור של הפורטפוליו האישי שלי.',
    ),
    programmingLanguage: 'JavaScript',
    githubUrl: 'https://github.com/lubani/Portfolio',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'math',
    description: LocalizedString(
      english: 'Some Python scripts for mathematical demonstrations',
      hebrew: 'סקריפטים ב-Python להדגמות מתמטיות',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/math',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'scientificProject',
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/scientificProject',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'HebSum',
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/HebSum',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'MySoftware',
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/MySoftware',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DevOps2412',
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/DevOps2412',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'hw6',
    description: LocalizedString(
      english: 'A repository for the 6th lesson in the DevOps course',
      hebrew: 'מאגר לשיעור השישי בקורס DevOps',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/hw6',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: '2412-first-repo2',
    githubUrl: 'https://github.com/lubani/2412-first-repo2',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'IRCourse',
    description: LocalizedString(
      english: 'Information Retrieval Course',
      hebrew: 'קורס אחזור מידע',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/IRCourse',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DeepStefan',
    githubUrl: 'https://github.com/lubani/DeepStefan',
    isFork: true,
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DjangoMS',
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/DjangoMS',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DjangoMSA',
    description: LocalizedString(
      english: 'Microservices Website',
      hebrew: 'אתר מבוסס מיקרו-שירותים',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/DjangoMSA',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'Summarizer-Extension',
    description: LocalizedString(
      english: 'Accessability Plugin',
      hebrew: 'תוסף נגישות לסיכום טקסטים',
    ),
    programmingLanguage: 'JavaScript',
    githubUrl: 'https://github.com/lubani/Summarizer-Extension',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'bert-extractive-summarizer',
    description: LocalizedString(
      english: 'Easy to use extractive text summarization with BERT',
      hebrew: 'כלי פשוט לשימוש לסיכום טקסטים בשיטה חילוצית עם BERT',
    ),
    githubUrl: 'https://github.com/lubani/bert-extractive-summarizer',
    isFork: true,
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'HebrewSumy',
    description: LocalizedString(
      english: 'A Hebrew Summarizer',
      hebrew: 'מסכם טקסטים בעברית',
    ),
    programmingLanguage: 'Python',
    githubUrl: 'https://github.com/lubani/HebrewSumy',
  ),
];

void showProjects(BuildContext context, PortfolioLanguage language) {
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
                  _ProjectOwnerSection(owner: 'lubacareer', language: language),
                  const SizedBox(height: 18),
                  _ProjectOwnerSection(owner: 'lubani', language: language),
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

class _ProjectOwnerSection extends StatelessWidget {
  final String owner;
  final PortfolioLanguage language;

  const _ProjectOwnerSection({required this.owner, required this.language});

  @override
  Widget build(BuildContext context) {
    final projects = _githubProjects
        .where((project) => project.owner == owner)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$owner (${projects.length})',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppPalette.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        for (final project in projects)
          _ProjectListItem(project: project, language: language),
      ],
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
