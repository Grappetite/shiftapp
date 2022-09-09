import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../Network/API.dart';
import '../Routes/app_pages.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/login_service.dart';

class AuthController extends GetxController {
  bool showLogin = true;

  TextEditingController controller =
      TextEditingController(text: "mahboob+supervisor@grappetite.com");

  TextEditingController passwordController =
      TextEditingController(text: "Mahboob321");

  String selectedString = "";

  bool showInitText = true;

  List<Process> process = [];

  int processIndexSelected = -1;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDefaul();
  }

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
        // await EasyLoading.dismiss();
      } else {
        if (response.data!.shiftDetails == null) {
          // await EasyLoading.dismiss();

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

  signInOrNext() async {
    if (!showLogin) {
      if (processIndexSelected == -1) {
        return;
      }
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      var processSelected = process[processIndexSelected];

      var shifts = await LoginService.getShifts(processSelected.id!);

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

    LoginResponse? response =
        await LoginService.login(controller.text, passwordController.text);

    if (response == null) {
      //await EasyLoading.dismiss();
      EasyLoading.showError('Could not login successfully');
    } else {
      //await EasyLoading.dismiss();

      //final Api().sp = await SharedPreferences.getInstance();

      Api().sp.write('username', controller.text);
      Api().sp.write('password', passwordController.text);

      if (response.data!.shiftDetails != null) {
        Api().sp.write('shiftId', response.data!.shiftDetails!.shiftId!);
        loadDefaul();

        //prefs.reload();

        return;
      }

      process = response.data!.process!;

      showLogin = false;
      update();

      return;
    }
    return;
  }

  void processMethod(String newString) {
    selectedString = newString;
    update();

    processIndexSelected =
        process.map((e) => e.name!.trim()).toList().indexOf(newString);
  }
}
