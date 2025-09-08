import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          surface: Colors.black,
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
        fontFamily: 'PlaypenSansThai',
        useMaterial3: true,
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
      const CvTile(),
      const CoverLetterTile(),
      HoverTile(
        title: 'Introduction',
        subtitle: 'About me',
        onTap: () => showIntro(context),
        icon: Icons.info_outline,
      ),
      HoverTile(
        title: 'Education',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Education'),
        icon: Icons.school,
      ),
      HoverTile(
        title: 'Skills',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Skills'),
        icon: Icons.handyman,
      ),
      HoverTile(
        title: 'Experience',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Experience'),
        icon: Icons.work_outline,
      ),
      HoverTile(
        title: 'Research',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Research'),
        icon: Icons.biotech,
      ),
      HoverTile(
        title: 'Projects',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Projects'),
        icon: Icons.dashboard_customize,
      ),
      HoverTile(
        title: 'Hobbies',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Hobbies'),
        icon: Icons.interests,
      ),
      HoverTile(
        title: 'Links',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Links'),
        icon: Icons.link,
      ),
    ];

    return Scaffold(
      body: Center(
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
                      width: 280,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        width: 280,
                        height: 180,
                        alignment: Alignment.center,
                        color: Colors.white12,
                        child: const Icon(Icons.person, color: Colors.white54, size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Luba's Portfolio",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      int cols;
                      if (w >= 1100) {
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
                            .map((t) => SizedBox(width: 260, height: 150, child: t))
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
    );
  }
}

Future<void> openPublic(String path) async {
  final uri = Uri.parse(path); // served directly from web/
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}

void showIntro(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
      contentTextStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.white70, height: 1.35),
      title: const Text('Introduction'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SelectableText(
                '''From a young age, curiosity guided me toward math, physics, and languages, nurturing an early passion for solving complex puzzles. However, my journey was far from smooth; high school was particularly challenging, marked by insomnia and personal struggles, ultimately preventing me from completing my matriculation exams (Bagrut). But resilience defined the next chapter of my story: after serving in Sherut Leumi, I rebuilt my academic foundation through a preparatory program at Sami Shamoon College of Engineering, paving the way for a Bachelor's and subsequently a Master's degree in Software Engineering, which I completed cum laude with a GPA of 96. My master's research was particularly fascinating—simulating lunar regolith melting using physics-informed neural networks and advanced numerical analysis.''',
              ),
              SizedBox(height: 12),
              SelectableText(
                '''Today, my professional journey reflects not only my technical expertise but also a profound commitment to giving back. For several years, I've dedicated myself to tutoring students with disabilities, helping them master software engineering, mathematics, and physics. Since January 2025, I've expanded my impact by taking on freelance software development projects, building tailored technological solutions for private clients. Now, in these challenging times, I'm eagerly looking for an entry-level, part-time position where I can blend my passion for technology, teaching, and problem-solving to contribute meaningfully to an innovative team.''',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.home, color: Colors.white70),
          label: const Text('Main menu'),
        ),
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
    final hoverColor = const Color(0xFF7FFFD4).withOpacity(0.18); // aquamarine tint
    final pressedColor = const Color(0xFFDA70D6).withOpacity(0.28); // orchid tint

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _pressed
              ? pressedColor
              : _hovered
                  ? hoverColor
                  : Colors.black,
          border: Border.all(
            color: _pressed
                ? const Color(0xFFDA70D6).withOpacity(0.6)
                : _hovered
                    ? const Color(0xFF7FFFD4).withOpacity(0.6)
                    : Colors.white24,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _hovered || _pressed
              ? [
                  BoxShadow(
                    color: (_pressed
                            ? const Color(0xFFDA70D6)
                            : const Color(0xFF7FFFD4))
                        .withOpacity(0.2),
                    blurRadius: 18,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onHighlightChanged: (v) => setState(() => _pressed = v),
          onTap: widget.onTap,
          splashColor: const Color(0xFFDA70D6).withOpacity(0.2),
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
                    Icon(widget.icon, color: Colors.white70),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.subtitle,
                        style: const TextStyle(color: Colors.white70)),
                    AnimatedOpacity(
                      opacity: _hovered ? 1 : 0,
                      duration: const Duration(milliseconds: 120),
                      child: const Icon(Icons.open_in_new, color: Colors.white70),
                    ),
                  ],
                )
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
    final hoverColor = const Color(0xFF7FFFD4).withOpacity(0.18); // aquamarine tint
    final pressedColor = const Color(0xFFDA70D6).withOpacity(0.28); // orchid tint

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
            color: _pressed
                ? pressedColor
                : _hovered
                    ? hoverColor
                    : Colors.black,
            border: Border.all(
              color: _pressed
                  ? const Color(0xFFDA70D6).withOpacity(0.6)
                  : _hovered
                      ? const Color(0xFF7FFFD4).withOpacity(0.6)
                      : Colors.white24,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered || _pressed
                ? [
                    BoxShadow(
                      color: (_pressed
                              ? const Color(0xFFDA70D6)
                              : const Color(0xFF7FFFD4))
                          .withOpacity(0.2),
                      blurRadius: 18,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      'CV',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                if (_hovered)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => openPublic('/docs/CV1.pdf'),
                        icon: const Icon(Icons.description, color: Colors.white70, size: 18),
                        label: const Text('English'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => openPublic('/docs/CV1heb.pdf'),
                        icon: const Icon(Icons.description, color: Colors.white70, size: 18),
                        label: const Text('Hebrew'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Hover to choose', style: TextStyle(color: Colors.white70)),
                      Icon(Icons.folder_open, color: Colors.white70),
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
    final hoverColor = const Color(0xFF7FFFD4).withOpacity(0.18); // aquamarine tint
    final pressedColor = const Color(0xFFDA70D6).withOpacity(0.28); // orchid tint

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
            color: _pressed
                ? pressedColor
                : _hovered
                    ? hoverColor
                    : Colors.black,
            border: Border.all(
              color: _pressed
                  ? const Color(0xFFDA70D6).withOpacity(0.6)
                  : _hovered
                      ? const Color(0xFF7FFFD4).withOpacity(0.6)
                      : Colors.white24,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered || _pressed
                ? [
                    BoxShadow(
                      color: (_pressed
                              ? const Color(0xFFDA70D6)
                              : const Color(0xFF7FFFD4))
                          .withOpacity(0.2),
                      blurRadius: 18,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_note, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      'Cover Letter',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                if (_hovered)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => openPublic('/docs/CL1.pdf'),
                        icon: const Icon(Icons.description, color: Colors.white70, size: 18),
                        label: const Text('English'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => openPublic('/docs/CL1heb.pdf'),
                        icon: const Icon(Icons.description, color: Colors.white70, size: 18),
                        label: const Text('Hebrew'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Hover to choose', style: TextStyle(color: Colors.white70)),
                      Icon(Icons.folder_open, color: Colors.white70),
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
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      titleTextStyle: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
      contentTextStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.white70, height: 1.35),
      title: Text(title),
      content: const SizedBox(
        width: 420,
        child: Text('Content coming soon.'),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.home, color: Colors.white70),
          label: const Text('Main menu'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
