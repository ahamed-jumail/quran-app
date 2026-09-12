import 'dart:io';

class TestEnvironment {
  static bool isFlutterTest = Platform.environment.containsKey('FLUTTER_TEST');
}
