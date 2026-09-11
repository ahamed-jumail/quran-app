# Flutter BLoC Boilerplate with State Management

A comprehensive Flutter boilerplate project using the BLoC (Business Logic Component) pattern for state management. This project demonstrates best practices for structuring Flutter applications with Firebase integration, multi-flavor support, and automated CI/CD pipelines.

## Project Structure

```
mobile_boiler_plate_with_bloc_state_management/
├── lib/                           # Main Flutter application code
│   ├── main.dart                  # Application entry point
│   ├── app.dart                   # Main app configuration and setup
│   ├── app_router.dart            # Navigation and routing setup
│   ├── firebase_options.dart      # Firebase configuration for different flavors
│   ├── flavors.dart               # Flavor definitions and configuration
│   ├── core/                      # Core functionality and utilities
│   │   ├── bloc/                  # BLoC classes for app-wide state
│   │   ├── services/              # Core services (API, storage, etc.)
│   │   └── utils/                 # Utility functions and constants
│   ├── models/                    # Data models and entities
│   ├── views/                     # UI screens and pages
│   │   ├── home/                  # Home screen
│   │   ├── login/                 # Authentication screens
│   │   └── ...                    # Other feature screens
│   └── global_widgets/            # Reusable widgets used across the app
│
├── android/                       # Android native code and configuration
│   ├── app/
│   │   ├── build.gradle.kts       # Android app build configuration
│   │   ├── flavorizr.gradle.kts   # Flavor-specific Android configuration
│   │   └── src/                   # Android source files
│   ├── build.gradle.kts           # Root Android build configuration
│   ├── settings.gradle.kts        # Gradle settings
│   └── gradle/                    # Gradle wrapper and configuration
│
├── ios/                           # iOS native code and configuration
│   ├── Runner.xcodeproj/          # Xcode project configuration
│   ├── Runner.xcworkspace/        # Xcode workspace
│   ├── Runner/                    # iOS app source files
│   │   ├── AppDelegate.swift      # iOS app entry point
│   │   ├── Info.plist            # iOS app configuration
│   │   ├── dev/                   # Dev flavor resources
│   │   └── staging/               # Staging flavor resources
│   ├── Podfile                    # CocoaPods dependencies
│   ├── Pods/                      # CocoaPods dependencies (generated)
│   └── Flutter/                   # Flutter framework configuration
│
├── firebase/                      # Firebase configuration files
│   ├── dev/
│   │   ├── google-services.json   # Firebase config for Android (dev)
│   │   └── GoogleService-Info.plist # Firebase config for iOS (dev)
│   └── staging/
│       ├── google-services.json   # Firebase config for Android (staging)
│       └── GoogleService-Info.plist # Firebase config for iOS (staging)
│
├── test/                          # Unit and widget tests
│   ├── widget_test.dart           # Widget test examples
│   ├── pages/                     # Page/screen tests
│   └── test_helpers/              # Test utilities and helpers
│
├── build/                         # Generated build artifacts (not versioned)
│   ├── ios/                       # iOS build outputs
│   └── native_assets/             # Native asset build outputs
│
├── pubspec.yaml                   # Flutter/Dart dependencies and metadata
├── analysis_options.yaml          # Dart analyzer configuration
├── coverage_exclude.json          # Test coverage exclusions
├── firebase.json                  # Firebase CLI configuration
├── flavorizr.yml                  # Flavor configuration for automation
├── mobile_cd_android.sh           # Android CD/deployment script
├── mobile-pr-ci.yml               # CI/CD pipeline configuration
└── test.sh                        # Test execution script
```

## Key Features

### BLoC State Management
- Implements the BLoC pattern for clean separation of business logic from UI
- Reactive state management with Dart streams
- Predictable state transitions and event handling

### Multi-Flavor Support
- **Dev**: Development environment with development Firebase project
- **Staging**: Staging environment with staging Firebase project
- Automated flavor switching for both Android and iOS using `flavorizr`

### Firebase Integration
- Firebase Authentication
- Firestore Database
- Firebase Analytics
- Firebase Crash Reporting
- Firebase Remote Config
- Flavor-specific Firebase projects

### CI/CD Automation
- GitHub Actions workflows for automated testing and deployment
- Separate pipelines for pull requests and continuous delivery
- Automated Android and iOS builds

### Project Configuration Files

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Flutter/Dart package dependencies and project metadata |
| `analysis_options.yaml` | Dart code analysis rules and lint configuration |
| `firebase.json` | Firebase CLI project configuration |
| `flavorizr.yml` | Flavor automation configuration |
| `firebase.json` | Firebase deployment rules |
| `mobile_cd_android.sh` | Android continuous deployment script |
| `mobile-pr-ci.yml` | GitHub Actions CI/CD workflow configuration |
| `test.sh` | Test execution automation script |

## Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK
- Xcode 13+ (for iOS development)
- Android Studio or Android SDK (for Android development)
- CocoaPods (for iOS dependencies)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd mobile_boiler_plate_with_bloc_state_management
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate required files:
```bash
flutter pub run build_runner build
```

4. Update flavorizr configuration:
```bash
flutter pub run flutter_flavorizr
```

5. Run the app with environment variables (dev flavor):
```bash
flutter run -t lib/main.dart --flavor dev --dart-define-from-file=.env.dev
```

6. Run the app with environment variables (staging flavor):
```bash
flutter run -t lib/main.dart --flavor staging --dart-define-from-file=.env.staging
```

7. Build the app with environment variables (dev flavor):
```bash
flutter build apk --flavor dev --dart-define-from-file=.env.dev
flutter build ios --flavor dev --dart-define-from-file=.env.dev
```

8. Build the app with environment variables (staging flavor):
```bash
flutter build apk --flavor staging --dart-define-from-file=.env.staging
flutter build ios --flavor staging --dart-define-from-file=.env.staging
```

**Note:** Create `.env.dev` and `.env.staging` files in the project root with the following format:
```
API_BASE_URL=<your-dev-api-url>
API_KEY=<your-dev-api-key>
```

### Running Tests

Execute all tests:
```bash
./test.sh
```

Or using Flutter directly:
```bash
flutter test
```

## Architecture Overview

This project follows clean architecture principles with the following layers:

- **UI Layer**: Widgets and screens in the `views/` directory
- **BLoC Layer**: Business logic components managing state in `core/bloc/`
- **Domain Layer**: Use cases and business rules
- **Data Layer**: Repositories and data sources (API, Firebase, local storage)
- **Core Layer**: Shared utilities, services, and helpers

## Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Firebase Flutter Documentation](https://firebase.flutter.dev/)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
