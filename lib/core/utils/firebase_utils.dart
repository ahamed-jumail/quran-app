import 'dart:io';

class FirebaseUtils {
  static bool isFlutterTest = Platform.environment.containsKey('FLUTTER_TEST');
}
