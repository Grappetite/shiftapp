import 'package:intl/intl.dart';

abstract class BaseConfig {
  String get apiUrl;

  String get imageUrl;

  String get baseUrl;

  String get staging;

  String get version;

  bool get preset;

  String get downloadLink;
}

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => "https://dev-shift.grappetite.com/api/v1/";
  @override
  String get downloadLink => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get version => "V.6";

  @override
  String get imageUrl => "assets/images/toplogo.png";

  @override
  String get apiUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get staging => "Version:Local";

  @override
  bool get preset => true;
}

class LocalConfig implements BaseConfig {
  @override
  String get baseUrl => "https://dev-shift.grappetite.com/api/v1/";
  @override
  String get downloadLink => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get version => "V.6";

  @override
  String get imageUrl => "assets/images/toplogo.png";

  @override
  String get apiUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get staging => "Version:Localhome";

  @override
  bool get preset => true;
}

class ProductionConfig implements BaseConfig {
  @override
  String get baseUrl => "https://dev-shift.grappetite.com/api/v1/";
  @override
  String get downloadLink => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get version => "V.6";

  @override
  String get imageUrl => "assets/images/toplogo.png";

  @override
  String get apiUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get staging => "Version:Production";

  @override
  bool get preset => false;
}

class TakealotConfig implements BaseConfig {
  @override
  String get baseUrl => "https://takealot.grappetite.com/api/v1/";
  @override
  String get downloadLink =>
      "install.appcenter.ms/users/mahboob-grappetite.com/apps/shift-android/distribution_groups/public";

  @override
  String get version => "V.6";

  @override
  String get imageUrl => "assets/images/toplogo.png";

  @override
  String get staging =>
      "Version:Shift-${version}-${DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toString())}(Live)";

  @override
  String get apiUrl => "https://takealot.grappetite.com/api/v1/";

  @override
  bool get preset => false;
}

class TakealotDemoConfig implements BaseConfig {
  @override
  String get baseUrl => "https://takealotdemo.grappetite.com/api/v1/";
  @override
  String get downloadLink => "https://takealotdemo.grappetite.com/api/v1/";

  @override
  String get version => "V.6";

  @override
  String get imageUrl => "assets/images/toplogo.png";

  @override
  String get staging =>
      "Version:Shift-${version}-${DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toString())}(Takealotdummy)";

  @override
  String get apiUrl => "https://takealotdemo.grappetite.com/api/v1/";

  @override
  bool get preset => false;
}

class newDemoConfig implements BaseConfig {
  @override
  String get baseUrl => "https://shiftnewdemo.grappetite.com/api/v1/";
  @override
  String get downloadLink => "https://shiftnewdemo.grappetite.com/api/v1/";

  @override
  String get version => "V.6";

  @override
  String get imageUrl => "assets/images/toplogo.png";

  @override
  String get staging =>
      "Version:Shift-${version}-${DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toString())}(Takealotdummy)";

  @override
  String get apiUrl => "https://shiftnewdemo.grappetite.com/api/v1/";

  @override
  bool get preset => false;
}

class StingrayConfig implements BaseConfig {
  @override
  String get baseUrl => "https://shiftdemo.grappetite.com/api/v1/";
  @override
  String get downloadLink =>
      "install.appcenter.ms/users/mahboob-grappetite.com/apps/shift-android/distribution_groups/stingray";

  @override
  String get version => "V.1";

  @override
  String get imageUrl => "assets/images/thestingratgroup (white).png";

  @override
  String get staging =>
      "Version:Shift-${version}-${DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now().toString())}(StingRay)";

  @override
  String get apiUrl => "https://shiftdemo.grappetite.com/api/v1/";

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
  static const String newBuild = 'newBuild';
  static const String dummy = 'dummy';
  static const String takealotdemo = 'takealotdemo';
  static const String newDemo = 'newDemo';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.production:
        return ProductionConfig();
      case Environment.live:
        return TakealotConfig();
      case Environment.newBuild:
        return StingrayConfig();
      case Environment.dummy:
        return LocalConfig();
      case Environment.takealotdemo:
        return TakealotDemoConfig();
      case Environment.newDemo:
        return newDemoConfig();
      default:
        return DevConfig();
    }
  }
}
