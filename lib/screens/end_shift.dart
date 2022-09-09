import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/Controllers/HomeController.dart';
import 'package:shiftapp/Network/API.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../Routes/app_pages.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/shift_service.dart';

class EndShiftView extends StatelessWidget {
  bool? startedBefore = Get.arguments["startedBefore"];
  int? shiftId = Get.arguments["shiftId"];
  int? processId = Get.arguments["processId"];
  List<dynamic>? userId = Get.arguments["userId"];
  List<dynamic>? efficiencyCalculation = Get.arguments["efficiencyCalculation"];
  ShiftItem? selectedShift = Get.arguments["selectedShift"];
  String? comment = Get.arguments["comment"];
  Process? process = Get.arguments["process"];
  bool? autoOpen = Get.arguments["autoOpen"];
  int? execShiftId = Get.arguments["execShiftId"];
  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(initState: (c) {
      controller.onEndShiftInit(
          selectedShift: selectedShift, processId: processId);
    }, builder: (logic) {
      return Scaffold(
        appBar: AppBar(
          leading: Container(),
          automaticallyImplyLeading: false,
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
          actions: [
            AppPopupMenu<int>(
              menuItems: [
                PopupMenuItem(
                  value: 1,
                  onTap: () async {
                    var result = await showOkCancelAlertDialog(
                      context: context,
                      title: 'Warning',
                      message: 'Are you sure you want to discard this shift?',
                      okLabel: 'YES',
                      cancelLabel: 'NO',
                    );

                    if (result.index == 1) {
                      return;
                    }

                    String endTime = DateFormat("yyyy-MM-dd hh:mm:ss")
                        .format(DateTime.now());

                    ShiftService.cancelShift(this.execShiftId!, endTime);

                    Api().sp.remove('shiftId');

                    Api().sp.remove('selectedShiftName');
                    Api().sp.remove('selectedShiftEndTime');
                    Api().sp.remove('selectedShiftStartTime');
                    Api().sp.remove('username');
                    Api().sp.remove('password');

                    if (autoOpen!) {
                      Get.back(result: true);
                    } else {
                      Get.back(result: true);
                      Get.back(result: true);
                    }

                    /// onLogout();
                  },
                  child: const Text(
                    'Discard Shift',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              initialValue: 2,
              onSelected: (int value) {},
              onCanceled: () {},
              elevation: 4,
              icon: const Icon(Icons.more_vert),
              offset: const Offset(0, 65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: kPrimaryColor,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TimerTopWidget(
                  selectedShift: selectedShift!,
                  timeElasped: controller.timeElasped),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        24,
                      ),
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        controller.isTimeOver
                            ? ('TIME OVER : ${controller.timeRemaining}')
                            : ('TIME REMAINING: ${controller.timeRemaining}'),
                        style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  children: [
                    ExplainerWidget(
                      comingSoon: true,
                      iconName: 'construct',
                      title: 'SOP REQUIRED',
                      text1: '4 Workers require SOP Training',
                      text2: 'Tap to train now or swipe to ignore',
                      showWarning: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          'Coming Soon',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ExplainerWidget(
                  iconName: 'filled-walk',
                  title: 'MANAGE WORKERS',
                  text1: process!.headCount != null
                      ? '${controller.numberSelected} /${process!.headCount} Workers'
                      : '${controller.numberSelected} /${controller.totalUsersCount} Workers',
                  text2: 'Tap to Add or remove',
                  showWarning: false,
                  onTap: () {
                    Get.toNamed(Routes.editWorkers, arguments: {
                      "startTime": selectedShift!.startTime!,
                      "processId": processId,
                      "endTime": selectedShift!.endTime!,
                      "userId": [],
                      "efficiencyCalculation": [],
                      "shiftId": shiftId,
                      "totalUsersCount": userId!.length,
                      "selectedShift": selectedShift,
                      "process": process,
                      "execShiftId": this.execShiftId,
                    });
                    controller.loadUsers(processId!);
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  children: [
                    ExplainerWidget(
                      comingSoon: true,
                      iconName: 'exclamation',
                      title: 'INCIDENTS',
                      text1: '5',
                      text2: 'Tap to train now or swipe to ignore',
                      showWarning: false,
                      text1_2: '01:50:00',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          'Coming Soon',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 26,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 52,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.endShiftFinal, arguments: {
                          "autoOpen": autoOpen,
                          "startTime": selectedShift!.startTime!,
                          "selectedShift": selectedShift,
                          "shiftId": shiftId,
                          "processId": processId,
                          "endTime": selectedShift!.endTime!,
                          "comments": '',
                          "process": process,
                          "executeShiftId": controller.executeShiftId!,
                        });
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => EndShiftFinalScreen(
                        //       autoOpen: autoOpen,
                        //       startTime: selectedShift.startTime!,
                        //       selectedShift: selectedShift,
                        //       shiftId: shiftId,
                        //       processId: processId,
                        //       endTime: selectedShift.endTime!,
                        //       comments: '',
                        //       process: process,
                        //       executeShiftId: executeShiftId!,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Image.asset('assets/images/end-shift.png'),
                    ),
                  ),
                  Expanded(
                    flex: 26,
                    child: Container(),
                  ),
                ],
              ),
              const SizedBox(
                height: 26,
              )
            ],
          ),
        ),
      );
    });
  }
}

class ExplainerWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String text1;
  final String text1_2;
  final String text2;

  final VoidCallback? onTap;

  final IconData? postIcon;

  final Color backgroundColor;

  bool showIcon;

  final bool showWarning;

  final Color? postIconColor;

  bool comingSoon;

  ExplainerWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.text1,
    required this.text2,
    this.showWarning = false,
    this.text1_2 = '',
    this.showIcon = false,
    this.backgroundColor = Colors.white,
    this.postIcon,
    this.postIconColor,
    this.onTap,
    this.comingSoon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: comingSoon ? Colors.grey : kPrimaryColor,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                24,
              ),
            ),
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: text1_2.isNotEmpty ? 9 : 16, horizontal: 16),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  if (showIcon) ...[
                    Icon(
                      Icons.directions_walk,
                      size: MediaQuery.of(context).size.width / 12,
                      color: comingSoon ? Colors.grey : kPrimaryColor,
                    ),
                  ] else ...[
                    Image(
                      image: AssetImage('assets/images/$iconName.png'),
                      width: MediaQuery.of(context).size.width / 12,
                      color: comingSoon ? Colors.grey : kPrimaryColor,
                    ),
                  ],
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: comingSoon ? Colors.grey : kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        if (text1_2.isNotEmpty) ...[
                          const SizedBox(
                            height: 2,
                          ),
                        ] else ...[
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                        if (text1_2.isNotEmpty) ...[
                          Row(
                            children: [
                              Text(
                                'Incidents Recorded:',
                                style: TextStyle(
                                    color: comingSoon
                                        ? Colors.grey
                                        : kPrimaryColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                text1,
                                style: TextStyle(
                                  color:
                                      comingSoon ? Colors.grey : kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          if (text1_2.isNotEmpty) ...[
                            const SizedBox(
                              height: 2,
                            ),
                          ] else ...[
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                          Row(
                            children: [
                              Text(
                                'Downtime Recorded:',
                                style: TextStyle(
                                    color: comingSoon
                                        ? Colors.grey
                                        : kPrimaryColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                text1_2,
                                style: TextStyle(
                                  color:
                                      comingSoon ? Colors.grey : kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            text1,
                            style: TextStyle(
                              color: comingSoon ? Colors.grey : kPrimaryColor,
                            ),
                          ),
                        ],
                        if (text2.isNotEmpty) ...[
                          if (text1_2.isNotEmpty) ...[
                            const SizedBox(
                              height: 2,
                            ),
                          ] else ...[
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                          Text(
                            text2,
                            style: TextStyle(
                              color: comingSoon ? Colors.grey : kPrimaryColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  if (postIcon != null) ...[
                    Icon(
                      postIcon,
                      size: MediaQuery.of(context).size.width / 12,
                      color: comingSoon
                          ? Colors.grey
                          : (postIconColor ?? Colors.cyan),
                    ),
                  ] else if (showWarning) ...[
                    Image(
                      image: const AssetImage('assets/images/warning.png'),
                      width: MediaQuery.of(context).size.width / 12,
                      color: comingSoon ? Colors.grey : null,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
