import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shiftapp/screens/home.dart';
import 'package:shiftapp/screens/shifts_listing.dart';
import 'package:shiftapp/services/login_service.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../widgets/drop_down.dart';
import '../widgets/elevated_button.dart';
import '../widgets/input_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLogin = true;

  TextEditingController controller = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  String selectedString = "";

  bool showInitText = true;

  List<Process> process = [];

  int processIndexSelected = 0;

  @override
  void initState() {
    super.initState();

    controller.text = 'sidra+supervisor@grappetite.com';
    passwordController.text = 'sidragrap';
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
                        hintText: 'Username',
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
                    Visibility(
                      visible: !showLogin,
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
                      visible: !showLogin,
                      child: DropDown(
                        labelText: 'Title',
                        currentList:
                            process.map((e) => e.name!.trim()).toList(),
                        showError: false,
                        onChange: (newString) {
                          setState(() {
                            selectedString = newString;
                          });

                          processIndexSelected = process
                              .map((e) => e.name!.trim())
                              .toList()
                              .indexOf(newString);

                          //final List<String> cityNames = cities.map((city) => city.name).toList();
                        },
                        placeHolderText: 'Process',
                        preSelected: selectedString,
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
                    await EasyLoading.show(
                      status: 'loading...',
                      maskType: EasyLoadingMaskType.black,
                    );

                    if (!showLogin) {
                      var processSelected = process[processIndexSelected];

                      var shifts =
                          await LoginService.getShifts(processSelected.id!);

                      await EasyLoading.dismiss();

                      if (shifts == null) {
                        EasyLoading.showError('Could not load shifts');
                      } else {

                        if(shifts.data!.isNotEmpty) {

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomeView(
                                selectedShift: shifts.data!.first,
                                processSelected: processSelected,
                              ),
                            ),
                          );

                        }

                      }
                      print("object");

                      //getShifts
                      return;
                    }
                    LoginResponse? response = await LoginService.login(
                        controller.text, passwordController.text);

                    if (response == null) {
                      await EasyLoading.dismiss();
                      EasyLoading.showError('Could not login successfully');
                    } else {
                      await EasyLoading.dismiss();

                      process = response.data!.process!;

                      setState(() {
                        showLogin = false;
                      });

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
