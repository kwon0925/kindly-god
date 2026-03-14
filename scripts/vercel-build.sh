#!/bin/bash
set -e
set -x

echo "=== Vercel Flutter build started ==="
echo "PWD: $(pwd)"
ls -la scripts/ 2>/dev/null || true
ls -la . 2>/dev/null || true

trap 'echo "=== FAILED at line $LINENO (exit $?) ==="; exit 1' ERR

echo "=== Cloning Flutter SDK ==="
git clone https://github.com/flutter/flutter.git --depth 1 -b stable
export PATH="$PATH:$(pwd)/flutter/bin"

echo "=== Flutter version ==="
flutter --version

echo "=== Flutter config ==="
flutter config --no-analytics

echo "=== Flutter precache (web) ==="
flutter precache --web

echo "=== Flutter pub get ==="
flutter pub get

echo "=== Flutter build web ==="
flutter build web

echo "=== Build output ==="
ls -la build/web/

echo "=== Vercel Flutter build finished ==="
