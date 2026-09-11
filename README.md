# Flutter BLoC Boilerplate with State Management

A comprehensive Flutter boilerplate project using the BLoC (Business Logic Component) pattern for state management. This project demonstrates best practices for structuring Flutter applications with automated CI/CD pipelines.

## Project Structure

```
mobile_boiler_plate_with_bloc_state_management/
├── lib/                           # Main Flutter application code
│   ├── main.dart                  # Application entry point
│   ├── app.dart                   # Main app configuration and setup
│   ├── app_router.dart            # Navigation and routing setup
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
│   │   ├── build.gradle.kts       # Android app build configuration (single "production" flavor)
│   │   └── src/                   # Android source files
│   ├── build.gradle.kts           # Root Android build configuration
│   ├── settings.gradle.kts        # Gradle settings
│   └── gradle/                    # Gradle wrapper and configuration
│
├── ios/                           # iOS native code and configuration
│   ├── Runner.xcodeproj/          # Xcode project configuration (single "production" flavor)
│   ├── Runner.xcworkspace/        # Xcode workspace
│   ├── Runner/                    # iOS app source files
│   │   ├── AppDelegate.swift      # iOS app entry point
│   │   └── Info.plist            # iOS app configuration
│   ├── Podfile                    # CocoaPods dependencies
│   ├── Pods/                      # CocoaPods dependencies (generated)
│   └── Flutter/                   # Flutter framework configuration
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
├── mobile_cd_android.sh           # Android CD/deployment script
├── mobile-pr-ci.yml               # CI/CD pipeline configuration
└── test.sh                        # Test execution script
```

## Key Features

### BLoC State Management
- Implements the BLoC pattern for clean separation of business logic from UI
- Reactive state management with Dart streams
- Predictable state transitions and event handling

### CI/CD Automation
- GitHub Actions workflows for automated testing and deployment
- Separate pipelines for pull requests and continuous delivery
- Automated Android and iOS builds

### Project Configuration Files

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Flutter/Dart package dependencies and project metadata |
| `analysis_options.yaml` | Dart code analysis rules and lint configuration |
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

4. Run the app:
```bash
flutter run -t lib/main.dart --flavor production --dart-define-from-file=.env
```

5. Build the app:
```bash
flutter build apk --flavor production --dart-define-from-file=.env
flutter build ios --flavor production --dart-define-from-file=.env
```

**Note:** The project ships a single `.env` file in the project root with the following format:
```
APP_LABEL=<display name>
SCHEME=<https>
SCOPE=<api/v1>
HOST=<api host>
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
- **Data Layer**: Repositories and data sources (API, local storage)
- **Core Layer**: Shared utilities, services, and helpers

## Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [BLoC Library Documentation](https://bloclibrary.dev/)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
