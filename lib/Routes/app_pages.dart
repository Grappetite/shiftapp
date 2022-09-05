import 'package:get/get.dart';

import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/splash.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: _Paths.splash, page: () => SplashScreen()),
    GetPage(
      name: _Paths.login,
      page: () => LoginScreen(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      // binding: AuthBinding(),
    ),
  ];
}
