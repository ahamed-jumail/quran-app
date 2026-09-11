#!/usr/bin/env bash
set -e

echo "🚀 Starting Android CI build"

# ----------------------------
# CONFIG (DEFAULTS)
# ----------------------------
#replace these default values as per your project setup
DEFAULT_VERSION_NAME="1.0.0"
DEFAULT_RELEASE_NOTES="CI build"

# ----------------------------
# ENV → FALLBACK
# ----------------------------
VERSION_NAME="${VERSION_NAME:-$DEFAULT_VERSION_NAME}"
BUILD_NUMBER="${BUILD_NUMBER:-$(date +%s)}"
RELEASE_NOTES="${RELEASE_NOTES:-$DEFAULT_RELEASE_NOTES}"

APK_PATH="build/app/outputs/flutter-apk/app-production-release.apk"

# ----------------------------
# LOG VALUES
# ----------------------------
echo "🔢 Build Number  : $BUILD_NUMBER"
echo "🚀 Version Name  : $VERSION_NAME"
echo "📝 Release Notes:"
echo "$RELEASE_NOTES"

# ----------------------------
# BUILD APK
# ----------------------------
echo "📦 Building APK"
flutter build apk \
  --flavor production \
  --dart-define-from-file=.env \
  --build-name "$VERSION_NAME" \
  --build-number "$BUILD_NUMBER"

# ----------------------------
# VALIDATE APK
# ----------------------------
if [ ! -f "$APK_PATH" ]; then
  echo "❌ APK not found at $APK_PATH"
  exit 1
fi

echo "✅ APK build completed successfully: $APK_PATH"
