import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shiftapp/Controllers/HomeController.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../Network/API.dart';
import '../Routes/app_pages.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/workers_service.dart';
import 'end_shift.dart';

class StartShiftView extends StatelessWidget {
  int? shiftId = Get.arguments["shiftId"];
  String? endTime = Get.arguments["endTime"];
  int? processId = Get.arguments["processId"];
  String? startTime = Get.arguments["startTime"];
  List<String>? efficiencyCalculation = Get.arguments["efficiencyCalculation"];
  List<String>? userId = Get.arguments["userId"];
  int? totalUsersCount = Get.arguments["totalUsersCount"];
  ShiftItem? selectedShift = Get.arguments["selectedShift"];
  Process? process = Get.arguments["process"];

  StartShiftView(
      {Key? key,
      this.shiftId,
      this.processId,
      this.userId,
      this.totalUsersCount,
      this.startTime,
      this.endTime,
      this.efficiencyCalculation,
      this.selectedShift,
      this.process})
      : super(key: key);
  final TextEditingController _controller = TextEditingController();

  String timeElasped = '00:00';
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (logic) {
      return Scaffold(
        //8171999927660000
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Image.asset(
                'assets/images/toplogo.png',
                height: 20,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                process!.name!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 2,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TimerTopWidget(
                  selectedShift: selectedShift!, timeElasped: timeElasped),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ExplainerWidget(
                  iconName: 'construct',
                  title: 'Workers',
                  text1: text1(),
                  text2: '',
                  showWarning: true,
                  showIcon: true,
                  backgroundColor: lightGreenColor,
                  postIcon: Icons.check,
                  postIconColor: Colors.green,
                ),
              ),
              //
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ExplainerWidget(
                  iconName: 'construct',
                  title: 'PPE',
                  text1: '2/5 Planned PPE per Worker Type',
                  text2: '',
                  showWarning: true,
                  showIcon: true,
                  backgroundColor: lightRedColor,
                ),
              ),

              SizedBox(
                height: 8,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Comments',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                  ),
                  minLines: 2,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.7,
                child: TextButton(
                  onPressed: () async {
                    if (_controller.text.isEmpty) {
                      showAlertDialog(
                        context: context,
                        title: 'Error',
                        message: 'Please add comment.',
                        actions: [
                          AlertDialogAction(
                            label:
                                MaterialLocalizations.of(context).okButtonLabel,
                            key: OkCancelResult.ok,
                          )
                        ],
                      );
                      return;
                    }
                    // await EasyLoading.show(
                    //   status: 'loading...',
                    //   maskType: EasyLoadingMaskType.black,
                    // );

                    var result = await WorkersService.addShiftWorker(
                        shiftId!,
                        processId!,
                        startTime!,
                        endTime!,
                        userId!,
                        efficiencyCalculation!,
                        _controller.text);

                    //await EasyLoading.dismiss();

                    if (result != null) {
                      if (result.status == 'error') {
                        showAlertDialog(
                          context: context,
                          title: 'Error',
                          message: result.message,
                          actions: [
                            AlertDialogAction(
                              label: MaterialLocalizations.of(context)
                                  .okButtonLabel,
                              key: OkCancelResult.ok,
                            )
                          ],
                        );

                        return;
                      }

                      if (result.code! == 200) {
                        // final prefs = await SharedPreferences.getInstance();
                        Api().sp.write('shiftId', selectedShift!.id!);
                        Api().sp.write('processId', processId);
                        Api().sp.write('comment', _controller.text);

                        Api()
                            .sp
                            .write('selectedShiftName', selectedShift!.name!);

                        Api().sp.write('shiftId', selectedShift!.id!);
                        Api().sp.write('processId', processId);

                        Api().sp.write('selectedShiftStartTime',
                            selectedShift!.startTime!);

                        Api().sp.write(
                            'selectedShiftEndTime', selectedShift!.endTime!);

                        Api().sp.write('selectedDisplayScreen',
                            selectedShift!.displayScreen!);

// <<<<<<< HEAD
                        Api().sp.write(
                            'execute_shift_id', result.data!.executeShiftId!);

// =======
                        Api().sp.write('selectedDisplayScreen',
                            selectedShift!.displayScreen!);

                        Api().sp.write(
                            'execute_shift_id', result.data!.executeShiftId!);
                        Get.offNamed(Routes.endShift, arguments: {
                          "userId": userId!,
                          "efficiencyCalculation": efficiencyCalculation,
                          "shiftId": shiftId,
                          "processId": processId,
                          "selectedShift": selectedShift!,
                          "comment": _controller.text,
                          "process": process!,
                          "execShiftId": result.data!.executeShiftId!
                        });
                      }
                    } else {
                      EasyLoading.showError('Could not load data');
                    }
                  },
                  child: Image.asset('assets/images/start_button.png'),
                ),
// >>>>>>> master
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      );
    });
  }

  String text1() {
    if (process!.headCount == null) {
      return '${userId!.length}/${totalUsersCount} Workers';
    }
    return '${userId!.length}/${process!.headCount} Workers';
  }
}
