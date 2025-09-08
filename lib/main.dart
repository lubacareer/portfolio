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
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          surface: Colors.black,
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
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
      HoverTile(
        title: 'Introduction',
        subtitle: 'About me',
        onTap: () => showIntro(context),
      ),
      HoverTile(
        title: 'Education',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Education'),
      ),
      HoverTile(
        title: 'Skills',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Skills'),
      ),
      HoverTile(
        title: 'Experience',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Experience'),
      ),
      HoverTile(
        title: 'Research',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Research'),
      ),
      HoverTile(
        title: 'Projects',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Projects'),
      ),
      HoverTile(
        title: 'Hobbies',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Hobbies'),
      ),
      HoverTile(
        title: 'Links',
        subtitle: 'Coming soon',
        onTap: () => showPlaceholder(context, 'Links'),
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
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      '/images/me2.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        width: 160,
                        height: 160,
                        color: Colors.white12,
                        child: const Icon(Icons.person, color: Colors.white54, size: 80),
                      ),
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
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      contentTextStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      title: const Text('Hi!'),
      content: const Text(
        'This is my minimalist Flutter web portfolio.\n'
        'Hover over the tiles to explore.',
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
  const HoverTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<HoverTile> createState() => _HoverTileState();
}

class _HoverTileState extends State<HoverTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _hovered ? Colors.white12 : Colors.black,
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _hovered
              ? [BoxShadow(color: Colors.white.withOpacity(0.08), blurRadius: 14)]
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white)),
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
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _hovered = !_hovered),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _hovered ? Colors.white12 : Colors.black,
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [BoxShadow(color: Colors.white.withOpacity(0.08), blurRadius: 14)]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CV',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
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

void showPlaceholder(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.black,
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      contentTextStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      title: Text(title),
      content: const Text('Content coming soon.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
