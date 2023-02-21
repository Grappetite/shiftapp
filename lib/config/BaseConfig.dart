import 'package:intl/intl.dart';

abstract class BaseConfig {
  String get apiUrl;

  String get imageUrl;

  String get baseUrl;

  String get staging;

  String get version;

  bool get preset;
}

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get version => "V.4";

  @override
  String get imageUrl => "https://dev-shift.grappetite.com/api/v1/public";

  @override
  String get apiUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get staging => "Version:Local";

  @override
  bool get preset => true;
}

class ProductionConfig implements BaseConfig {
  @override
  String get baseUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get version => "V.4";

  @override
  String get imageUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get apiUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get staging => "Version:Production";

  @override
  bool get preset => false;
}

class LiveConfig implements BaseConfig {
  @override
  String get baseUrl => "https://takealot.grappetite.com/api/v1/";

  @override
  String get version => "V.4";

  @override
  String get imageUrl => "https://takealot.grappetite.com/api/v1/";

  @override
  String get staging =>
      "Version:Shift-${version}-${DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toString())}(Live)";

  @override
  String get apiUrl => "https://takealot.grappetite.com/api/v1/";

  @override
  bool get preset => false;
}

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'dev';
  static const String production = 'production';
  static const String live = 'live';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.production:
        return ProductionConfig();
      case Environment.live:
        return LiveConfig();
      default:
        return DevConfig();
    }
  }
}
