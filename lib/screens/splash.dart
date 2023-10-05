import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shiftapp/config/BaseConfig.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/constants.dart';
import '../services/login_service.dart';
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

  Future<void> _launchInBrowser(Uri url) async {
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      Clipboard.setData(
          new ClipboardData(text: Environment().config.downloadLink));
      EasyLoading.showError(
          "Can not launch the url, but it's copied to your clipboard",
          dismissOnTap: true,
          duration: Duration(seconds: 2));
    }
  }

  void loadToNextView() async {
    var data = await LoginService.checkVersion();
    if (data["data"]["name"] == Environment().config.version) {
      // await Future.delayed(const Duration(seconds: 1), () {});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      EasyLoading.showError(
              "Please update the Version. Will redirect you to the browser in 5 seconds",
              dismissOnTap: true,
              duration: Duration(seconds: 2))
          .then((value) async {
        await Future.delayed(const Duration(seconds: 4), () {});
        _launchInBrowser(Uri.parse(Environment()
                .config
                .staging
                .toLowerCase()
                .contains("Production".toLowerCase())
            ? "https://install.appcenter.ms/users/mahboob-grappetite.com/apps/shift-android/distribution_groups/dev"
            : "https://install.appcenter.ms/users/mahboob-grappetite.com/apps/shift-android/distribution_groups/public"));
      });
    }
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
          )),
    );
  }
}
