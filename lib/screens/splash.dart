import 'package:flutter/material.dart';

import '../config/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mainBackGroundColor,
        child:  Center(
          child: Image(image: const AssetImage('assets/images/logo.png'),width: MediaQuery.of(context).size.width / 1.35,),
        ),
      ),
    );
  }
}
