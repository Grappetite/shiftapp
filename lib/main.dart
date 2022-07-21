import 'package:flutter/material.dart';
import 'package:shiftapp/screens/login.dart';
import 'package:shiftapp/screens/splash.dart';

import 'config/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF0E577F, primaryMap),

      ),
      home: const LoginScreen(),
     // home: const SplashScreen(),
    );
  }
}//

