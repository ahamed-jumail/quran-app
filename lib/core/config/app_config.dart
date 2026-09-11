class AppConfig {
  AppConfig({
    required this.appName,
    required this.scheme,
    required this.scope,
    required this.host,
    required this.baseUrl,
  });
  factory AppConfig.initiate() {
    const String appName = String.fromEnvironment('APP_LABEL');
    const String scheme = String.fromEnvironment('SCHEME');
    const String scope = String.fromEnvironment('SCOPE');
    const String host = String.fromEnvironment('HOST');

    return shared = AppConfig(
      appName: appName,
      scheme: scheme,
      scope: scope,
      host: host,
      baseUrl: '$scheme://$scope',
    );
  }

  /// Builds a config directly for tests, which have no `--dart-define`s.
  factory AppConfig.forTest() {
    const String scheme = 'https';
    const String scope = 'api.example.com/api/v1';

    return shared = AppConfig(
      appName: 'App',
      scheme: scheme,
      scope: scope,
      host: 'api.example.com',
      baseUrl: '$scheme://$scope',
    );
  }
  String appName;
  String scheme;
  String scope;
  String host;
  String baseUrl;

  static AppConfig shared = AppConfig.initiate();
}
