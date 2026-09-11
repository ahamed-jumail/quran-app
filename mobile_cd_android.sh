#!/usr/bin/env bash
set -e

echo "🚀 Starting Android Firebase Distribution"

# ----------------------------
# CONFIG (DEFAULTS)
# ----------------------------
#replace these default values as per your project setup
DEFAULT_FLAVOR="dev"
DEFAULT_FIREBASE_APP_ID="1:256627936922:android:4a746a131df13127ddd923"
DEFAULT_FIREBASE_GROUPS="mobile-dev"
DEFAULT_VERSION_NAME="1.0.0"
DEFAULT_RELEASE_NOTES="CI build"

# ----------------------------
# ENV → FALLBACK
# ----------------------------
FLAVOR="${FLAVOR:-$DEFAULT_FLAVOR}"
VERSION_NAME="${VERSION_NAME:-$DEFAULT_VERSION_NAME}"
BUILD_NUMBER="${BUILD_NUMBER:-$(date +%s)}"
RELEASE_NOTES="${RELEASE_NOTES:-$DEFAULT_RELEASE_NOTES}"
FIREBASE_APP_ID="${FIREBASE_APP_ID:-$DEFAULT_FIREBASE_APP_ID}"
FIREBASE_GROUPS="${FIREBASE_GROUPS:-$DEFAULT_FIREBASE_GROUPS}"

APK_PATH="build/app/outputs/flutter-apk/app-${FLAVOR}-release.apk"

# ----------------------------
# LOG VALUES
# ----------------------------
echo "📦 Flavor        : $FLAVOR"
echo "🔢 Build Number  : $BUILD_NUMBER"
echo "🚀 Version Name  : $VERSION_NAME"
echo "📝 Release Notes:"
echo "$RELEASE_NOTES"
echo "📱 Firebase App  : $FIREBASE_APP_ID"
echo "👥 Firebase Grps : $FIREBASE_GROUPS"

# ----------------------------
# BUILD APK
# ----------------------------
echo "📦 Building APK"
flutter build apk \
  --flavor "$FLAVOR" \
  --build-name "$VERSION_NAME" \
  --build-number "$BUILD_NUMBER"

# ----------------------------
# VALIDATE APK
# ----------------------------
if [ ! -f "$APK_PATH" ]; then
  echo "❌ APK not found at $APK_PATH"
  exit 1
fi

# ----------------------------
# DISTRIBUTE TO FIREBASE
# ----------------------------
echo "📤 Uploading to Firebase App Distribution"

firebase appdistribution:distribute "$APK_PATH" \
  --app "$FIREBASE_APP_ID" \
  --groups "$FIREBASE_GROUPS" \
  --release-notes "$RELEASE_NOTES"

echo "✅ Firebase distribution completed successfully"
