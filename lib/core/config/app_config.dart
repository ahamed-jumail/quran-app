enum Flavor { production, staging, dev, qa }

class AppConfig {
  AppConfig({
    required this.flavor,
    required this.appName,
    required this.scheme,
    required this.scope,
    required this.host,
    required this.baseUrl,
  });
  factory AppConfig.initiate() {
    const String environment = String.fromEnvironment('ENVIRONMENT');
    const String appName = String.fromEnvironment('APP_NAME');
    const String scheme = String.fromEnvironment('SCHEME');
    const String scope = String.fromEnvironment('SCOPE');
    const String host = String.fromEnvironment('HOST');

    return shared = AppConfig(
      flavor: (environment == Flavor.dev.name)
          ? Flavor.dev
          : (environment == Flavor.qa.name)
              ? Flavor.qa
              : (environment == Flavor.staging.name)
                  ? Flavor.staging
                  : Flavor.production,
      appName: appName,
      scheme: scheme,
      scope: scope,
      host: host,
      baseUrl: '$scheme://$scope',

    );
  }

  /// Builds a config directly from a [Flavor] without reading
  /// `String.fromEnvironment`. Used by tests, which have no `--dart-define`s.
  factory AppConfig.fromFlavor(Flavor flavor) {
    const String scheme = 'https';
    final String scope = switch (flavor) {
      Flavor.production => 'api.example.com/api/v1',
      Flavor.staging => 'api.staging.example.com/api/v1',
      Flavor.qa => 'api.qa.example.com/api/v1',
      Flavor.dev => 'api.dev.example.com/api/v1',
    };

    return shared = AppConfig(
      flavor: flavor,
      appName: '[${flavor.name}] App',
      scheme: scheme,
      scope: scope,
      host: scope.split('/').first,
      baseUrl: '$scheme://$scope',
    );
  }
  Flavor flavor;
  String appName;
  String scheme;
  String scope;
  String host;
  String baseUrl;

  static AppConfig shared = AppConfig.initiate();
}
