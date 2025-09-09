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
# Renderer selection can vary across Flutter versions.
# Try --web-renderer first, then --renderer, then no flag.
WEB_RENDERER="${WEB_RENDERER:-canvaskit}"
set +e
flutter build web --release --web-renderer "$WEB_RENDERER" --no-tree-shake-icons
status=$?
if [ $status -ne 0 ]; then
  echo ":: '--web-renderer' not supported; trying '--renderer'"
  flutter build web --release --renderer "$WEB_RENDERER" --no-tree-shake-icons
  status=$?
fi
if [ $status -ne 0 ]; then
  echo ":: Renderer flag unsupported; building without renderer flag"
  flutter build web --release --no-tree-shake-icons
  status=$?
fi
set -e

echo ":: Build artifacts in build/web"
