import 'package:flutter/material.dart';
import 'package:shiftapp/screens/home.dart';

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
  TextEditingController controller = TextEditingController();

  String selectedString = "";

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
                    InputView(
                      showError: false,
                      hintText: 'Code',
                      onChange: (newValue) {},
                      controller: controller,
                      text: '',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    InputView(
                      showError: false,
                      hintText: 'Password',
                      onChange: (newValue) {},
                      controller: controller,
                      text: '',
                      isSecure: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    DropDown(
                      labelText: 'Title',
                      currentList: const ['One', 'Two'],
                      showError: false,
                      onChange: (newString) {
                        setState(() {
                          selectedString = newString;
                        });
                      },
                      placeHolderText: 'Please Select',
                      preSelected: selectedString,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Center(
                child: PElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const HomeView()));
                  },
                  text: 'SIGN IN',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
