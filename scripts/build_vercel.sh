#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
echo ":: Installing Flutter ($FLUTTER_VERSION)"
git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1 .flutter
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
