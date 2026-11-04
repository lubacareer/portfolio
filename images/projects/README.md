# Project media sources

- `finance1-desktop.png` is the Flutter Windows app dashboard from the public
  [finance1 repository](https://github.com/lubacareer/finance1), at commit
  `6a02935a7ba1483cdceb0ac9250e25302fc729d4`. An isolated test entry point
  populated a temporary encrypted vault with synthetic accounts and entries;
  the running app's `RepaintBoundary` captured its rendered interface.
- `nasaclps-desktop.png` shows Trend Detective's desktop app, associated with
  [nasaCLPS-releases](https://github.com/lubacareer/nasaCLPS-releases). The
  development checkout was at commit `772756d2084b5980ad410600a610781f141bb317`.
  An isolated Electron window and temporary profile used the project's offline
  synthetic UI fixture; the displayed values are not NASA observations. The
  capture used Electron `webContents.capturePage`.
- `electricity-desktop.png` is an offscreen capture of the running Qt app from
  the public [electricity repository](https://github.com/lubacareer/electricity),
  at commit `8800c01659357533b67ce126bf822ccadd5fcabb`. It shows the bundled
  USB sensor board example and its simulated RT1 open-fault scenario; the Qt
  widget was captured in an isolated profile using `QWidget.grab`.
- `jupiter-desktop.png` captures the running Europa Engine Electron desktop
  app from the public [jupiter repository](https://github.com/lubacareer/jupiter),
  at commit `294d849b9ad461ea3243144c56cecc1adcf30387`. Its default CPU
  orbital simulation was running in an isolated checkout; the interior view is
  schematic and the orbital model is a simplified research prototype.
- `magnetic-torus.jpg` is the public thumbnail for the supplied
  [magnetic torus video](https://www.youtube.com/watch?v=QYacq8NXiZY).
- `cml-interface.webp` is a screenshot of the default office scene from the
  public [CML repository](https://github.com/lubacareer/CML), at commit
  `225a6480149a511de0cecf9ec333c37ca051c07c`. It was captured at 1280 × 800
  after running `npm ci` and `npm run dev` on an isolated checkout; no personal
  data was used.
- `nasa2-synthetic-preview.png` is a screenshot of the default synthetic
  preview from the public [Nasa2 repository](https://github.com/lubacareer/Nasa2),
  at commit `e0ebc4803167e2f7bef11a228b24970d174d7593`. It was captured at
  1440 × 1000 after running the repository's development server. The preview
  contains no satellite measurements.
- `spritebury-interface.webp` is a screenshot of the opening screen from the
  public [spritebury repository](https://github.com/lubacareer/spritebury), at
  commit `c3b84bfb5779f8ec65f1b5ee6ff8a82332a8c865`. It was captured at
  1280 × 800 from an isolated checkout using `npm install` and `npm run dev`,
  without credentials or personal data. `npm ci` could not be used because
  the repository's lockfile did not match its package manifest.
