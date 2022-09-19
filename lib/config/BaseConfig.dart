abstract class BaseConfig {
  String get apiUrl;
  String get imageUrl;
  String get baseUrl;
  bool get preset;
}

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get imageUrl => "https://dev-shift.grappetite.com/api/v1/public";

  @override
  String get apiUrl => "https://dev-shift.grappetite.com/api/v1/";
  @override
  bool get preset => true;
}

class ProductionConfig implements BaseConfig {
  @override
  String get baseUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get imageUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get apiUrl => "https://dev-shift.grappetite.com/api/v1/";
  @override
  bool get preset => false;

// String get mapKey => "AIzaSyDLtchj3AddQGK3mlMgqA6HKbLQlEkEa38";
}
//flutter run --dart-define=ENVIRONMENT=dev

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'dev';
  static const String production = 'production';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.production:
        return ProductionConfig();
      default:
        return DevConfig();
    }
  }
}
