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
  'lubacareer/finance1': ProjectMedia(
    screenshots: [
      ProjectScreenshot(
        asset: 'web/images/projects/finance1-desktop.png',
        englishLabel: 'Financial Diary desktop dashboard with synthetic data',
        hebrewLabel: 'לוח הבקרה של Financial Diary במחשב עם נתונים סינתטיים',
      ),
    ],
  ),
  'lubacareer/nasaclps-releases': ProjectMedia(
    screenshots: [
      ProjectScreenshot(
        asset: 'web/images/projects/nasaclps-desktop.png',
        englishLabel:
            'Trend Detective desktop with synthetic example data, not NASA observations',
        hebrewLabel:
            'Trend Detective במחשב עם נתונים סינתטיים לדוגמה, שאינם תצפיות של נאס״א',
      ),
    ],
  ),
  'lubacareer/electricity': ProjectMedia(
    screenshots: [
      ProjectScreenshot(
        asset: 'web/images/projects/electricity-desktop.png',
        englishLabel:
            'SMD Twin Lab desktop simulation of a sample sensor board',
        hebrewLabel: 'סימולציית לוח חיישנים לדוגמה ביישום המחשב SMD Twin Lab',
      ),
    ],
  ),
  'lubacareer/jupiter': ProjectMedia(
    screenshots: [
      ProjectScreenshot(
        asset: 'web/images/projects/jupiter-desktop.png',
        englishLabel: 'Europa Engine desktop orbital simulation prototype',
        hebrewLabel: 'אב טיפוס לסימולציית מסלול ביישום המחשב Europa Engine',
      ),
    ],
  ),
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
