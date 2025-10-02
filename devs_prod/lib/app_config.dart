enum Flavor { dev, prod }

class AppConfig {
  final Flavor flavor;
  final String appTitle;
  final bool showDebugBanner;

  static late AppConfig instance;

  AppConfig._internal({
    required this.flavor,
    required this.appTitle,
    required this.showDebugBanner,
  });

  factory AppConfig({
    required Flavor flavor,
    required String appTitle,
    required bool showDebugBanner,
  }) {
    instance = AppConfig._internal(
      flavor: flavor,
      appTitle: appTitle,
      showDebugBanner: showDebugBanner,
    );
    return instance;
  }
}
