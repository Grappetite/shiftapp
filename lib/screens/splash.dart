import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Routes/app_pages.dart';
import '../config/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadToNextView();
  }

  void loadToNextView() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mainBackGroundColor,
        child: Center(
          child: Image(
            image: const AssetImage('assets/images/logo.png'),
            width: MediaQuery.of(context).size.width / 1.35,
          ),
        ),
      ),
    );
  }
}
