#!/usr/bin/env bash
set -euo pipefail

echo ":: Installing Flutter (stable)"
git clone https://github.com/flutter/flutter.git -b stable --depth 1 .flutter
export PATH="$PATH:$(pwd)/.flutter/bin"

echo ":: Flutter version"
flutter --version

echo ":: Enable web support"
flutter config --enable-web

echo ":: Pub get"
flutter pub get

echo ":: Build web (release)"
# Use CanvasKit for better typography/rendering; skip tree-shake icons to keep all icons
flutter build web --release --web-renderer canvaskit --no-tree-shake-icons

echo ":: Build artifacts in build/web"
