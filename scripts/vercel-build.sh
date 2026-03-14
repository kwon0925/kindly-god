#!/bin/bash
set -e

# Install Flutter (stable, minimal clone)
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable
export PATH="$PATH:$(pwd)/flutter/bin"

flutter --version
flutter config --no-analytics
flutter precache --web
flutter pub get
flutter build web

echo "Build completed. Output in build/web"
