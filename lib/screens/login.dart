import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shiftapp/Network/API.dart';
import 'package:shiftapp/services/login_service.dart';

import '../Routes/app_pages.dart';
import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
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

  int processIndexSelected = -1;

  void loadDefaul() async {
    //final prefs = await SharedPreferences.getInstance();

    int? shiftId = Api().sp.read('shiftId');

    if (shiftId != null) {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      String loginUserName = Api().sp.read('username')!;
      String passString = Api().sp.read('password')!;

      LoginResponse? response =
          await LoginService.login(loginUserName, passString);

      if (response == null) {
        await EasyLoading.dismiss();
      } else {
        if (response.data!.shiftDetails == null) {
          await EasyLoading.dismiss();

          Api().sp.remove('username');

          Api().sp.remove('password');

          Api().sp.remove('shiftId');
          return;
        }
        process = response.data!.process!;

        var shiftObject = ShiftItem(
          id: response.data!.shiftDetails!.shiftId!,
          name: response.data!.shiftDetails!.shiftName!,
          startTime: response.data!.shiftDetails!.executeShiftStartTime,
          endTime: response.data!.shiftDetails!.executeShiftEndTime,
        );

// <<<<<<< HEAD
//         shiftObject.displayScreen = 1;
//
//         //await EasyLoading.dismiss();
//         Get.offAllNamed(Routes.home, arguments: {
//           "selectedShift": shiftObject,
//           "processSelected": selectedProcess,
//           "sessionStarted": true,
//           "comment": Api().sp.read('comment'),
//         });
//         //     // Navigator.pushReplacement(
//         //     //   context,
//         //     //   MaterialPageRoute(
//         //     //     builder: (BuildContext context) => HomeView(
//         //     //       selectedShift: shiftObject,
//         //     //       processSelected: selectedProcess,
//         //     //       sessionStarted: true,
//         //     //       comment: Api().sp.read('comment'),
//         //     //     ),
//         //     //   ),
//         //     // );
// =======

        shiftObject.executedShiftId =
            response.data!.shiftDetails!.executeShiftId;

        shiftObject.displayScreen = 2;

        // await EasyLoading.dismiss();
        Get.offAllNamed(Routes.home, arguments: {
          "selectedShift": shiftObject,
          "processSelected": response.data!.shiftDetails!.process!,
          "sessionStarted": true,
        });

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => HomeView(
        //       selectedShift: shiftObject,
        //       processSelected: response.data!.shiftDetails!.process!,
        //       sessionStarted: true,
        //     ),
        //   ),
        // );

// >>>>>>> master
      }
    }
  }

  @override
  void initState() {
    super.initState();

    controller.text = 'sidra+supervisor@grappetite.com';

    controller.text = 'asfa+s@grappetite.com';
    controller.text = 'asfa+supervisor@grappetite.com';
    pwd:

    //
    passwordController.text = 'sidragrap';
    passwordController.text = 'isqvqx';
    passwordController.text = 'oznytw';

    loadDefaul();
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
                    if (!showLogin) {
                      if (processIndexSelected == -1) {
                        return;
                      }
                      // await EasyLoading.show(
                      //   status: 'loading...',
                      //   maskType: EasyLoadingMaskType.black,
                      // );
                      var processSelected = process[processIndexSelected];

                      var shifts =
                          await LoginService.getShifts(processSelected.id!);

                      //await EasyLoading.dismiss();

                      //shifts!.data!.first.displayScreen = 3;

                      if (shifts == null) {
                        EasyLoading.showError('Could not load shifts');
                      } else {
                        if (shifts.data!.isNotEmpty) {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (BuildContext context) =>
                          Get.offAllNamed(Routes.home, arguments: {
                            "selectedShift": shifts.data!.first,
                            "processSelected": processSelected,
                          });
                          // HomeView(
                          // selectedShift: shifts.data!.first,
                          // processSelected: processSelected,
                          // ),
                          // ),
                          // );
                        }
                      }
                      print("object");

                      //getShifts
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

                    // await EasyLoading.show(
                    //   status: 'loading...',
                    //   maskType: EasyLoadingMaskType.black,
                    // );

                    LoginResponse? response = await LoginService.login(
                        controller.text, passwordController.text);

                    if (response == null) {
                      //await EasyLoading.dismiss();
                      EasyLoading.showError('Could not login successfully');
                    } else {
                      //await EasyLoading.dismiss();

                      //final Api().sp = await SharedPreferences.getInstance();

                      Api().sp.write('username', controller.text);
                      Api().sp.write('password', passwordController.text);

                      if (response.data!.shiftDetails != null) {
                        Api().sp.write(
                            'shiftId', response.data!.shiftDetails!.shiftId!);
                        loadDefaul();

                        //prefs.reload();

                        return;
                      }

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
