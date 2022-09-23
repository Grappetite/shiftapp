import 'package:flutter/material.dart';
import 'package:shiftapp/config/BaseConfig.dart';

import '../config/constants.dart';
import 'login.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: mainBackGroundColor,
              image: DecorationImage(
                  image: const AssetImage('assets/images/logo.png'),
                  scale: 3.5)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${Environment().config.staging}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
            ),
          )
          // Image(
          //   image: const AssetImage('assets/images/logo.png'),
          //   width: MediaQuery.of(context).size.width / 1.35,
          // ),
          ),
    );
  }
}
