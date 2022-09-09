import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shiftapp/Controllers/AuthController.dart';

import '../config/constants.dart';
import '../widgets/drop_down.dart';
import '../widgets/elevated_button.dart';
import '../widgets/input_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (logic) {
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
                        visible: controller.showLogin,
                        child: InputView(
                          showError: false,
                          hintText: 'Username',
                          onChange: (newValue) {},
                          controller: controller.controller,
                          text: '',
                        ),
                      ),
                      Visibility(
                        visible: controller.showLogin,
                        child: const SizedBox(
                          height: 24,
                        ),
                      ),
                      Visibility(
                        visible: controller.showLogin,
                        child: InputView(
                          showError: false,
                          hintText: 'Password',
                          onChange: (newValue) {},
                          controller: controller.passwordController,
                          text: '',
                          isSecure: true,
                        ),
                      ),
                      Visibility(
                        visible: !controller.showLogin,
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Please select Process',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Visibility(
                        visible: !controller.showLogin,
                        child: DropDown(
                          labelText: 'Title',
                          currentList: controller.process
                              .map((e) => e.name!.trim())
                              .toList(),
                          showError: false,
                          onChange: (newString) {
                            controller.processMethod(newString);
                            //final List<String> cityNames = cities.map((city) => city.name).toList();
                          },
                          placeHolderText: 'Process',
                          preSelected: controller.selectedString,
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
                      await controller.signInOrNext();
                    },
                    text: controller.showLogin ? 'SIGN IN' : 'NEXT',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
