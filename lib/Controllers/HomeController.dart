import 'dart:ui';

import 'package:get/get.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';

import '../Network/API.dart';
import '../Routes/app_pages.dart';

class HomeController extends GetxController {
  void moveToEndSession(
      {required Process processSelected,
      required ShiftItem selectedShift,
      required bool sessionStarted,
      required VoidCallback onLogout}) async {
    // await EasyLoading.show(
    //   status: 'loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );

    await Future.delayed(const Duration(seconds: 1));
    //await EasyLoading.dismiss();

    var executeShiftId = Api().sp.read('execute_shift_id');

    var response = await Get.offNamed(Routes.endShift, arguments: {
      "autoOpen": true,
      "userId": const [],
      "efficiencyCalculation": const [],
      "shiftId": selectedShift.id!,
      "processId": processSelected.id!,
      "selectedShift": selectedShift,
      "startedBefore": true,
      "process": processSelected,
      "execShiftId": executeShiftId!,
    });
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => EndShiftView(
    //       autoOpen: true,
    //       userId: const [],
    //       efficiencyCalculation: const [],
    //       shiftId: selectedShift.id!,
    //       processId: processSelected.id!,
    //       selectedShift: selectedShift,
    //       comment: comment!,
    //       startedBefore: true,
    //       process: processSelected,
    //       execShiftId: executeShiftId!,
    //     ),
    //   ),
    // );

    if (response != null) {
      if (response == true) {
        onLogout();
      }
    }
    print('=');
  }
}
