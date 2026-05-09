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

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Luba's Portfolio",
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
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      // Core sections
      HoverTile(
        title: 'Introduction',
        subtitle: 'About me',
        onTap: () => showIntro(context),
        icon: Icons.info_outline,
      ),
      HoverTile(
        title: 'Education',
        subtitle: 'My academic journey',
        onTap: () => showEducation(context),
        icon: Icons.school,
      ),
      HoverTile(
        title: 'Skills',
        subtitle: 'My skillset',
        onTap: () => showSkills(context),
        icon: Icons.handyman,
      ),
      HoverTile(
        title: 'Experience',
        subtitle: 'My professional journey',
        onTap: () => showExperience(context),
        icon: Icons.work_outline,
      ),
      HoverTile(
        title: 'Research',
        subtitle: 'Lunar ISRU focus',
        onTap: () => showResearch(context),
        icon: Icons.biotech,
      ),
      HoverTile(
        title: 'Projects',
        subtitle: 'My builds',
        onTap: () => showProjects(context),
        icon: Icons.dashboard_customize,
      ),
      HoverTile(
        title: 'Hobbies',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Hobbies'),
        icon: Icons.interests,
      ),
      HoverTile(
        title: 'Contact',
        subtitle: 'Email me',
        onTap: () => showContact(context),
        icon: Icons.email_outlined,
      ),
      HoverTile(
        title: 'Links',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Links'),
        icon: Icons.link,
      ),
      // Move CV and Cover Letter to bottom row
      const CvTile(),
      const CoverLetterTile(),
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
                    // Top-centered selfie image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.network(
                        '/images/me2.jpg',
                        width: 520,
                        height: 320,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          width: 520,
                          height: 320,
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
                    const SizedBox(height: 16),
                    Text(
                      "Luba's Portfolio",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppPalette.primaryDeep,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        int cols;
                        if (w >= 1000) {
                          cols = 4; // wide screens: 4 per row (even)
                        } else if (w >= 600) {
                          cols = 2; // medium screens: 2 per row (even)
                        } else {
                          cols = 1; // small screens: single column
                        }
                        return GridView.count(
                          crossAxisCount: cols,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 260 / 150,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: tiles
                              .map(
                                (t) =>
                                    SizedBox(width: 260, height: 150, child: t),
                              )
                              .toList(),
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

Future<void> openPublic(String path) async {
  final uri = Uri.parse(path); // served directly from web/
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}

Future<void> openEmail(String email) async {
  final uri = Uri(scheme: 'mailto', path: email);
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}

void showContact(BuildContext context) {
  const contactEmails = ['lubacareer@gmail.com', 'lubani@lubacorp.com'];

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: const Text('Contact Me'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feel free to reach out via email:',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 12),
            for (final email in contactEmails) ...[
              SelectableText(
                email,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppPalette.text),
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
                    label: Text(email),
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
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void showIntro(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: const Text('Introduction'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SelectableText(
                '''From a young age, curiosity guided me toward math, physics, and languages, nurturing an early passion for solving complex puzzles. However, my journey was far from smooth; high school was particularly challenging, marked by insomnia and personal struggles, ultimately preventing me from completing my matriculation exams (Bagrut). But resilience defined the next chapter of my story: after serving in Sherut Leumi, I rebuilt my academic foundation through a preparatory program at Sami Shamoon College of Engineering, paving the way for a Bachelor's and subsequently a Master's degree in Software Engineering, which I completed cum laude with a GPA of 96. My master's research was particularly fascinating—simulating lunar regolith melting using physics-informed neural networks and advanced numerical analysis.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''Today, my professional journey reflects not only my technical expertise but also a profound commitment to giving back. For several years, I've dedicated myself to tutoring students with disabilities, helping them master software engineering, mathematics, and physics. Since January 2025, I've expanded my impact by taking on freelance software development projects, building tailored technological solutions for private clients. Now, in these challenging times, I'm eagerly looking for an entry-level, part-time position where I can blend my passion for technology, teaching, and problem-solving to contribute meaningfully to an innovative team.''',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void showSkills(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: const Text('Skills'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SelectableText(
                '''My journey with computers started early—in fact, as early as three or four years old when I first encountered the command-line interface of MS-DOS. Even then, typing short commands sparked a lifelong passion for technology. Throughout the 90s, with Microsoft Windows dominating the landscape, I eagerly explored office software, particularly MS Word, where I channeled my love for storytelling and verbal expression.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''In high school, my curiosity deepened as I tackled analytical subjects like math, physics, and computer science. My first experience with databases came through Microsoft Access, followed by my introduction to programming with Java—an experience that was both enjoyable and formative.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''Entering my bachelor's degree in Software Engineering, I dove headfirst into learning programming languages, beginning with C. It was challenging yet rewarding, embedding syntax into my memory. Languages like C++, Python, and Java quickly followed. In my third year, the complexity escalated with compiler design using Lex, Yacc, Linux, and Bash scripting. This exposure ignited a profound interest in Unix-based systems and virtual machines, tools I integrate into my workflow to this day—every new laptop promptly receives a VMware installation running a Linux distribution.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''My undergraduate studies culminated in an NLP-focused project using Python, marking my deep dive into machine learning. During this time, I also honed my database skills, learning and later teaching SQL and MySQL.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''In my master's degree, I specialized further in Python, applying numerical analysis and physics-informed neural networks (PINNs) to simulate thermodynamics—specifically, lunar regolith melting for resource utilization in future lunar colonies.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''Today, as a freelancer and educator, my skillset has expanded to include cross-platform mobile app development with Flutter and Dart, which allows me to build visually appealing, modern apps efficiently. I find Flutter’s elegance a refreshing alternative to traditional HTML and CSS, aligning perfectly with my passion for creating innovative, user-friendly software solutions.''',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void showEducation(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: const Text('Education'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SelectableText(
                '''My educational path has always been driven by curiosity and a deep passion for mathematics, physics, and computers—interests that captivated me from early childhood. Growing up in an era before the rise of generative AI tools, I embraced each academic challenge independently, dedicating countless hours to mastering complex concepts through sheer determination and persistence. Integrity defined every step: throughout my Bachelor’s studies in Software Engineering at Sami Shamoon College of Engineering (SCE), even amid the turbulent shift to remote learning during the COVID pandemic, I completed every task without compromising on honesty or seeking shortcuts.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''My initial ventures into the world of programming began with natural language processing (NLP). I vividly recall my excitement and struggles when exploring Python libraries such as the Sumy repository for text summarization. Navigating GitHub repositories for the first time was daunting but incredibly rewarding. This early NLP journey sparked a project close to my heart: developing a browser extension to summarize Hebrew texts. Through this endeavor, I encountered JavaScript—my very first experience with the language. While JavaScript continues to puzzle me occasionally, my proficiency and passion for other languages, especially Python, have always provided a reliable foundation.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''Pursuing my Master's degree at SCE marked a significant turning point. During a numerical analysis course, my professor introduced me to an intriguing concept: leveraging lunar regolith for future Moon settlements. Inspired by his vision, I delved deeply into research papers, books, and extensive scientific literature. Initially considering Julia for simulation, we soon transitioned to Python due to its robust long-term support and expansive ecosystem. After numerous iterations, we discovered Physics-Informed Neural Networks (PINNs)—an advanced approach integrating deep learning and physics-based modeling. Given my prior coursework in deep learning and machine learning, this discovery captivated me profoundly. Over the next two years, I meticulously developed, tested, and refined a PINN-based Python simulation to model lunar regolith melting processes. Ultimately, this rigorous effort culminated in a comprehensive thesis and a fully functional codebase, enabling me to graduate cum laude with a Master’s degree in Software Engineering.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''Today, my journey reflects not only technical knowledge but also resilience, creativity, and unwavering commitment to continuous learning and exploration.''',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void showResearch(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: const Text('Research'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SelectableText(
                '''In my master's research I've explored an innovative approach to In-Situ Resource Utilization (ISRU) aimed at supporting future lunar settlements. Our research focused on harnessing latent heat thermal energy storage within lunar regolith, addressing critical challenges in energy management on the Moon.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''By developing Python-based simulations, we tackled complex heat transfer problems, specifically solving the Stefan problem and general heat equations. To push the boundaries further, we implemented a Physics-Informed Neural Network (PINN), validating its accuracy against classical analytical and numerical solutions. This work bridges traditional computational modeling with modern machine learning, paving the way for sustainable human presence on the lunar surface.''',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class PortfolioProject {
  final String owner;
  final String name;
  final String? description;
  final String? language;
  final String githubUrl;
  final bool isFork;

  const PortfolioProject({
    required this.owner,
    required this.name,
    required this.githubUrl,
    this.description,
    this.language,
    this.isFork = false,
  });

  String get summary {
    final value = description?.trim();
    if (value == null || value.isEmpty) {
      return 'Public GitHub repository.';
    }
    return value;
  }

  String get metadata {
    final parts = <String>[owner];
    if (language != null && language!.isNotEmpty) {
      parts.add(language!);
    }
    if (isFork) {
      parts.add('Fork');
    }
    return parts.join(' - ');
  }
}

const _githubProjects = <PortfolioProject>[
  PortfolioProject(
    owner: 'lubacareer',
    name: 'ast2',
    description: 'All-in-one Astrology app',
    language: 'Dart',
    githubUrl: 'https://github.com/lubacareer/ast2',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'Mazilon',
    description:
        'Mezilon is a Flutter-based mobile application designed to provide mental health support and personal planning tools.',
    language: 'Dart',
    githubUrl: 'https://github.com/lubacareer/Mazilon',
    isFork: true,
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'HeatEquationSimulator',
    description: 'Heat equation and Stefan problem addressed.',
    language: 'Python',
    githubUrl: 'https://github.com/lubacareer/HeatEquationSimulator',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'portfolio',
    description: 'My new portfolio website',
    language: 'Dart',
    githubUrl: 'https://github.com/lubacareer/portfolio',
  ),
  PortfolioProject(
    owner: 'lubacareer',
    name: 'ccomp',
    description: 'A robust C compiler',
    language: 'C',
    githubUrl: 'https://github.com/lubacareer/ccomp',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'astro',
    description: 'An Astrology App',
    language: 'C++',
    githubUrl: 'https://github.com/lubani/astro',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'Portfolio',
    description: 'My personal portfolio source code.',
    language: 'JavaScript',
    githubUrl: 'https://github.com/lubani/Portfolio',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'math',
    description: 'Some Python scripts for mathematical demonstrations',
    language: 'Python',
    githubUrl: 'https://github.com/lubani/math',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'scientificProject',
    language: 'Python',
    githubUrl: 'https://github.com/lubani/scientificProject',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'HebSum',
    language: 'Python',
    githubUrl: 'https://github.com/lubani/HebSum',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'MySoftware',
    language: 'Python',
    githubUrl: 'https://github.com/lubani/MySoftware',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DevOps2412',
    language: 'Python',
    githubUrl: 'https://github.com/lubani/DevOps2412',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'hw6',
    description: 'A repository for the 6th lesson in the DevOps course',
    language: 'Python',
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
    description: 'Information Retrieval Course',
    language: 'Python',
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
    language: 'Python',
    githubUrl: 'https://github.com/lubani/DjangoMS',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'DjangoMSA',
    description: 'Microservices Website',
    language: 'Python',
    githubUrl: 'https://github.com/lubani/DjangoMSA',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'Summarizer-Extension',
    description: 'Accessability Plugin',
    language: 'JavaScript',
    githubUrl: 'https://github.com/lubani/Summarizer-Extension',
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'bert-extractive-summarizer',
    description: 'Easy to use extractive text summarization with BERT',
    githubUrl: 'https://github.com/lubani/bert-extractive-summarizer',
    isFork: true,
  ),
  PortfolioProject(
    owner: 'lubani',
    name: 'HebrewSumy',
    description: 'A Hebrew Summarizer',
    language: 'Python',
    githubUrl: 'https://github.com/lubani/HebrewSumy',
  ),
];

void showProjects(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: const Text('Projects'),
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
              children: const [
                Text(
                  'Public GitHub repositories from lubacareer and lubani.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16),
                _ProjectOwnerSection(owner: 'lubacareer'),
                SizedBox(height: 18),
                _ProjectOwnerSection(owner: 'lubani'),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _ProjectOwnerSection extends StatelessWidget {
  final String owner;

  const _ProjectOwnerSection({required this.owner});

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
        for (final project in projects) _ProjectListItem(project: project),
      ],
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  final PortfolioProject project;

  const _ProjectListItem({required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: () => showProjectDetails(context, project),
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
                    project.metadata,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.subtleText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.summary,
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

void showProjectDetails(BuildContext context, PortfolioProject project) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: Text(project.name),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.metadata,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppPalette.subtleText),
              ),
              const SizedBox(height: 12),
              SelectableText(project.summary, textAlign: TextAlign.justify),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => openPublic(project.githubUrl),
                  icon: const Icon(
                    Icons.link,
                    color: AppPalette.mutedText,
                    size: 18,
                  ),
                  label: const Text('View on GitHub'),
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
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void showExperience(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: const Text('Experience'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SelectableText(
                '''My formal teaching experience began in 2021 at Achva Academic College, where I led database practice sessions for Information Systems students. In that role, I helped students strengthen their understanding of SQL and normalization through focused exercises and step-by-step guidance. This early position established the foundation for my approach as an educator: combining technical clarity with practical problem-solving.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''From 2023 to 2024, I continued this path at Sami Shamoon College, tutoring both individuals and small groups in core Software Engineering subjects such as algorithms, data structures, and object-oriented programming. Alongside that work, from 2023 to 2025 I served at the Aleh Association as both a tutor and transcriber, supporting students with disabilities in computer science and software engineering courses. This role required me to adapt explanations to different learning needs, create accessible learning materials and concise technical summaries, and refine academic content so that it remained clear, accurate, and approachable.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''Since 2025, my experience has expanded into several parallel roles. As a tutor at Alut Organization and Ono Academic College, I teach students on the spectrum in computer science and mathematics, with a strong emphasis on hands-on practice and guided exercise solving. In parallel, I work as an instructor at the Cyber Education Centre, where I teach a communication networks course for high-achieving high school students in the Magshimim program. There, I focus on building strong foundations in networking and cybersecurity while making the material concrete through practical work.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 12),
              SelectableText(
                '''Alongside my educational roles, since 2025 I have also been working as a freelance software developer as a registered sole proprietor. I deliver end-to-end projects for private clients, including mobile applications, websites, and backend systems, and I also provide consultation and implementation support in mathematics, algorithms, and software engineering. Taken together, these experiences reflect a professional path built around teaching, accessibility, and software development, with a consistent focus on helping others solve complex technical problems in a practical way.''',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
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
  const CvTile({super.key});

  @override
  State<CvTile> createState() => _CvTileState();
}

class _CvTileState extends State<CvTile> {
  bool _hovered = false;
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
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
                    Text(
                      'CV',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: AppPalette.text),
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
                          label: const Text('English'),
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
                          label: const Text('Hebrew'),
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
                    children: const [
                      Expanded(
                        child: Text(
                          'Hover to choose',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppPalette.mutedText),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.folder_open, color: AppPalette.mutedText),
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
  const CoverLetterTile({super.key});

  @override
  State<CoverLetterTile> createState() => _CoverLetterTileState();
}

class _CoverLetterTileState extends State<CoverLetterTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
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
                        'Cover Letter',
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
                          label: const Text('English'),
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
                          label: const Text('Hebrew'),
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
                    children: const [
                      Expanded(
                        child: Text(
                          'Hover to choose',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppPalette.mutedText),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.folder_open, color: AppPalette.mutedText),
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

void showPlaceholder(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppPalette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: const BorderSide(color: AppPalette.border),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppPalette.text,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppPalette.mutedText,
        height: 1.35,
      ),
      title: Text(title),
      content: const SizedBox(
        width: 420,
        child: Text('Content coming soon.', textAlign: TextAlign.justify),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
