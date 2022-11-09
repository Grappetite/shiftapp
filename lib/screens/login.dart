import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/BaseConfig.dart';
import 'package:shiftapp/screens/StartedShiftList.dart';
import 'package:shiftapp/services/login_service.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../widgets/elevated_button.dart';
import '../widgets/input_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLogin = true;

  TextEditingController controller = Environment().config.preset
      ? TextEditingController(text: "mahboob+supervisor@grappetite.com")
      : TextEditingController();
  TextEditingController passwordController = Environment().config.preset
      ? TextEditingController(text: "Mahboob321")
      : TextEditingController();
  String selectedString = "";
  bool showInitText = true;
  int processIndexSelected = -1;

  @override
  void initState() {
    super.initState();

    pwd:
    loadDefaul();
  }

  void loadDefaul() async {
    final prefs = await SharedPreferences.getInstance();
    int? shiftId = prefs.getInt('shiftId');
    String? loginUserName = prefs.getString('username');
    String? passString = prefs.getString('password');
    if (prefs.getString('username') != null) {
      controller.text = prefs.getString('username')!;
    }
    if (loginUserName != null && passString != null) {
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );

      LoginResponse? response =
          await LoginService.login(loginUserName!, passString!);

      if (response == null) {
        await EasyLoading.dismiss();
      } else {
        ///will go to the new page

        await EasyLoading.dismiss();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => StartedShifts(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: whiteBackGroundColor,
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Image(
                image: const AssetImage('assets/images/logo-colored.png'),
                width: MediaQuery.of(context).size.width / 1.35,
              ),
            ),
            Expanded(
              flex: 12,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.21,
                child: Column(
                  children: [
                    Visibility(
                      visible: showLogin,
                      child: InputView(
                        showError: false,
                        hintText: 'Email',
                        onChange: (newValue) {},
                        controller: controller,
                        text: '',
                      ),
                    ),
                    Visibility(
                      visible: showLogin,
                      child: const SizedBox(
                        height: 24,
                      ),
                    ),
                    Visibility(
                      visible: showLogin,
                      child: InputView(
                        showError: false,
                        hintText: 'Password',
                        onChange: (newValue) {},
                        controller: passwordController,
                        text: '',
                        isSecure: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Center(
                child: PElevatedButton(
                  onPressed: () async {
                    if (!showLogin) {
                      if (processIndexSelected == -1) {
                        return;
                      }

                      return;
                    }
                    if (controller.text.isEmpty) {
                      EasyLoading.showError('Please enter valid data');

                      return;
                    }
                    if (passwordController.text.isEmpty) {
                      EasyLoading.showError('Please enter valid data');

                      return;
                    }

                    await EasyLoading.show(
                      status: 'loading...',
                      maskType: EasyLoadingMaskType.black,
                    );

                    LoginResponse? response = await LoginService.login(
                        controller.text, passwordController.text);

                    if (response == null) {
                      await EasyLoading.dismiss();
                      EasyLoading.showError('Could not login successfully');
                    } else {
                      await EasyLoading.dismiss();

                      final prefs = await SharedPreferences.getInstance();

                      prefs.setString('username', controller.text);
                      prefs.setString('password', passwordController.text);

                      if (response.data!.shiftDetails != null) {
                        prefs.setInt('shiftId',
                            response.data!.shiftDetails![0].shiftId!);
                        loadDefaul();

                        return;
                      }

                      setState(() {
                        showLogin = false;
                      });
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => StartedShifts()));
                      return;
                    }
                    return;
                  },
                  text: showLogin ? 'SIGN IN' : 'NEXT',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
