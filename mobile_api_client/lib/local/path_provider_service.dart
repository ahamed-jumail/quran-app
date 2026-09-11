import 'package:path_provider/path_provider.dart' as path_provider;

class PathProviderService {
  PathProviderService();

  String? _path;

  String get path {
    if (_path != null) {
      return _path!;
    } else {
      throw Exception('Path not initialized');
    }
  }

  Future<void> init() async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    _path = dir.path;
  }
}
