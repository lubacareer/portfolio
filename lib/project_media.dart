/// Curated media is keyed by both account and repository name; GitHub remains
/// the source of the project list and repository links.
class ProjectScreenshot {
  const ProjectScreenshot({
    required this.asset,
    required this.englishLabel,
    required this.hebrewLabel,
  });

  final String asset;
  final String englishLabel;
  final String hebrewLabel;
}

class ProjectVideo {
  const ProjectVideo({
    required this.id,
    required this.englishLabel,
    required this.hebrewLabel,
  });

  final String id;
  final String englishLabel;
  final String hebrewLabel;
  String get watchUrl => 'https://www.youtube.com/watch?v=$id';
}

class ProjectMedia {
  const ProjectMedia({this.screenshots = const [], this.videos = const []});

  final List<ProjectScreenshot> screenshots;
  final List<ProjectVideo> videos;
}

const _mediaByRepository = <String, ProjectMedia>{
  'lubacareer/cml': ProjectMedia(
    screenshots: [
      ProjectScreenshot(
        asset: 'web/images/projects/cml-interface.webp',
        englishLabel: 'CML game interface showing the detective office',
        hebrewLabel: 'ממשק המשחק CML המציג את משרד הבלשית',
      ),
    ],
  ),
  'lubacareer/nasa2': ProjectMedia(
    screenshots: [
      ProjectScreenshot(
        asset: 'web/images/projects/nasa2-synthetic-preview.png',
        englishLabel: 'NISAR surface change synthetic preview',
        hebrewLabel: 'תצוגה מקדימה סינתטית של שינויי פני השטח ב-NISAR',
      ),
    ],
  ),
  'lubacareer/spritebury': ProjectMedia(
    screenshots: [
      ProjectScreenshot(
        asset: 'web/images/projects/spritebury-interface.webp',
        englishLabel: 'Spritebury opening screen',
        hebrewLabel: 'מסך הפתיחה של Spritebury',
      ),
    ],
  ),
  'lubacareer/heatequationsimulator': ProjectMedia(
    screenshots: [
      ProjectScreenshot(
        asset: 'web/images/projects/magnetic-torus.jpg',
        englishLabel: 'Magnetic Torus Simulator interface and visualizations',
        hebrewLabel: 'ממשק סימולטור טורוס מגנטי וההדמיות',
      ),
    ],
    videos: [
      ProjectVideo(
        id: 'dOgUwgH-XtE',
        englishLabel: 'Magnetic torus simulation: planetary dynamo',
        hebrewLabel: 'סימולציית טורוס מגנטי: דינמו פלנטרי',
      ),
      ProjectVideo(
        id: 'QYacq8NXiZY',
        englishLabel: 'Magnetic torus simulation: particle trajectories',
        hebrewLabel: 'סימולציית טורוס מגנטי: מסלולי חלקיקים',
      ),
    ],
  ),
};

ProjectMedia? mediaForProject(String owner, String name) =>
    _mediaByRepository['${owner.toLowerCase()}/${name.toLowerCase()}'];
