import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/shifts_model.dart';

import '../Network/API.dart';
import '../Routes/app_pages.dart';
import '../services/workers_service.dart';

class HomeController extends GetxController {
  int? executeShiftId;

  String timeElasped = '00:00';
  late Timer _timer;
  int totalUsersCount = 0;
  int numberSelected = 0;

  String timeRemaining = '00:00';

  var isTimeOver = false;
  void loadShiftId(processId) async {
    // final prefs = await SharedPreferences.getInstance();

    executeShiftId = Api().sp.read('execute_shift_id');

    // this.executeShiftId = execShiftId;

    loadUsers(processId);
  }

  void loadUsers(processId) async {
    var responseShift =
        await WorkersService.getShiftWorkers(executeShiftId!, processId!);

    numberSelected = responseShift!.data!.shiftWorker!.length;

    totalUsersCount = responseShift.data!.shiftWorker!.length +
        responseShift.data!.worker!.length;
    update();

    print('');
  }

  onEndShiftInit({required selectedShift, required processId}) {
    loadShiftId(processId);

    // appMenu02 =

    startTimer(selectedShift);
  }

  void startTimer(selectedShift) {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (selectedShift!.timeRemaining.contains('Over')) {
          timeRemaining = selectedShift!.timeRemaining.replaceAll('Over ', '');
          isTimeOver = true;
        } else {
          timeRemaining = selectedShift!.timeRemaining;
        }

        timeElasped = selectedShift!.timeElasped;
        update();

        print('');
      },
    );
  }

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
