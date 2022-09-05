abstract class BaseConfig {
  String get apiUrl;
  String get imageUrl;
  String get baseUrl;
  String get socketUrl;
  String get mapKey;
}

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get imageUrl => "https://dev-shift.grappetite.com/api/v1/public";

  @override
  String get apiUrl => "https://dev-shift.grappetite.com/api/v1/";

  @override
  String get socketUrl => "ws://192.168.5.251:8081/chat";
  @override
  String get mapKey => "AIzaSyCPDZxZYp3Su6ReZTh4lHRoie6HAM2P0sU";
}

class ProductionConfig implements BaseConfig {
  @override
  String get baseUrl => "http://18.191.253.101/bladeryders/";

  @override
  String get imageUrl => "http://18.191.253.101/bladeryders/";

  @override
  String get apiUrl => "http://18.191.253.101/bladeryders/api/";
  @override
  String get socketUrl => "ws://18.191.253.101:8081/chat";
  @override
  String get mapKey => "AIzaSyCPDZxZYp3Su6ReZTh4lHRoie6HAM2P0sU";
// String get mapKey => "AIzaSyDLtchj3AddQGK3mlMgqA6HKbLQlEkEa38";
}
//flutter run --dart-define=ENVIRONMENT=dev
