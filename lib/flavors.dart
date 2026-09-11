enum Flavor { dev, staging, prod }

class F {
  static   Flavor appFlavor=Flavor.dev;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return '[Dev] App';
      case Flavor.staging:
        return '[Staging] App';
      case Flavor.prod:
        return 'App';
    }
  }
}
