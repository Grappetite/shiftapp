import 'package:get/get.dart';
import 'package:shiftapp/screens/edit_workers.dart';
import 'package:shiftapp/screens/end_shift.dart';
import 'package:shiftapp/screens/end_shift_final_screen.dart';
import 'package:shiftapp/screens/select_exister_workers.dart';
import 'package:shiftapp/screens/start_shift_page.dart';

import '../Bindings/AuthBinding.dart';
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/splash.dart';
import '../screens/workers_listing.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: _Paths.splash, page: () => SplashScreen()),
    GetPage(
      name: _Paths.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.editWorkers,
      page: () => EditWorkers(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.endShift,
      page: () => EndShiftView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.endShiftFinal,
      page: () => EndShiftFinalScreen(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.startShift,
      page: () => StartShiftView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.selectedExistingWorker,
      page: () => SelectExistingWorkers(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.workerListing,
      page: () => WorkersListing(),
      // binding: AuthBinding(),
    ),
  ];
}
