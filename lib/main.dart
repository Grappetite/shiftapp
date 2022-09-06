import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'Network/environment.dart';
import 'Routes/app_pages.dart';
import 'config/constants.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  // await GetStorage.init();
  const String? environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.dev,
  );
  Environment().initConfig(environment);

  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        child = ScrollConfiguration(
          behavior: MyBehavior(),
          child: BotToastInit()(context, child),
        );
        child = ScrollConfiguration(
          behavior: MyBehavior(),
          child: EasyLoading.init()(context, child),
        );

        return child;
      },
      // initialBinding: SplashBinding(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF0E577F, primaryMap),
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // home: SplashScreen()
      // home: CardAddedSuccessfully(),
    );
  }
}
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: MaterialColor(0xFF0E577F, primaryMap),
//       ),
//       initialRoute: '/splash',
//       routes: {
//         // When navigating to the "/" route, build the FirstScreen widget.
//         '/': (context) => const LoginScreen(),
//         '/splash' : (context) => const SplashScreen(),
//         },
//       builder: EasyLoading.init(),
//       // home: const SplashScreen(),
//     );
//   }
// }//

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
