import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shiftapp/Network/API.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/shift_start.dart';

import '../Routes/app_pages.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/workers_service.dart';

class EndShiftView extends StatefulWidget {
  bool? startedBefore;
  int? shiftId;
  int? processId;
  List<String>? userId;
  List<String>? efficiencyCalculation;
  ShiftItem? selectedShift;
  String? comment;
  Process? process;

  bool? autoOpen;

  int? execShiftId;

  EndShiftView(
      {Key? key,
      this.shiftId,
      this.processId,
      this.userId,
      this.efficiencyCalculation,
      this.selectedShift,
      this.comment = '',
      this.startedBefore = false,
      this.process,
      this.autoOpen = false,
      this.execShiftId})
      : super(key: key);

  @override
  State<EndShiftView> createState() => _EndShiftViewState();
}

class _EndShiftViewState extends State<EndShiftView> {
  late AppPopupMenu<int> appMenu02;

  int? executeShiftId;

  String timeElasped = '00:00';
  late Timer _timer;
  int totalUsersCount = 0;
  int numberSelected = 0;

  String timeRemaining = '00:00';

  var isTimeOver = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.selectedShift!.timeRemaining.contains('Over')) {
          timeRemaining =
              widget.selectedShift!.timeRemaining.replaceAll('Over ', '');
          isTimeOver = true;
        } else {
          timeRemaining = widget.selectedShift!.timeRemaining;
        }

        setState(() {
          timeElasped = widget.selectedShift!.timeElasped;
        });

        print('');
      },
    );
  }

  void loadShiftId() async {
    // final prefs = await SharedPreferences.getInstance();

    this.executeShiftId = Api().sp.read('execute_shift_id');

    // this.executeShiftId = widget.execShiftId;

    loadUsers();
  }

  @override
  void initState() {
    super.initState();
    widget.startedBefore = Get.arguments["startedBefore"];
    widget.shiftId = Get.arguments["shiftId"];
    widget.processId = Get.arguments["processId"];
    widget.userId = Get.arguments["userId"];
    widget.efficiencyCalculation = Get.arguments["efficiencyCalculation"];
    widget.selectedShift = Get.arguments["selectedShift"];
    widget.comment = Get.arguments["comment"];
    widget.process = Get.arguments["process"];
    widget.autoOpen = Get.arguments["autoOpen"];
    widget.execShiftId = Get.arguments["execShiftId"];
    loadShiftId();

    appMenu02 = AppPopupMenu<int>(
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

            String endTime =
                DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

            // final prefs = await SharedPreferences.getInstance();

            Api().sp.remove('shiftId');

            Api().sp.remove('selectedShiftName');
            Api().sp.remove('selectedShiftEndTime');
            Api().sp.remove('selectedShiftStartTime');
            Api().sp.remove('username');
            Api().sp.remove('password');

            if (widget.autoOpen!) {
              Get.back(result: true);
            } else {
              Get.back(result: true);
              Get.back(result: true);
            }

            /// widget.onLogout();
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
    );

    startTimer();
  }

  void loadUsers() async {
    var responseShift = await WorkersService.getShiftWorkers(
        executeShiftId!, widget.processId!);

    numberSelected = responseShift!.data!.shiftWorker!.length;

    setState(() {
      totalUsersCount = responseShift.data!.shiftWorker!.length +
          responseShift.data!.worker!.length;
    });

    print('');
  }

  @override
  Widget build(BuildContext context) {
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
              widget.process!.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
        actions: [appMenu02],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TimerTopWidget(
                selectedShift: widget.selectedShift!, timeElasped: timeElasped),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      isTimeOver
                          ? ('TIME OVER : $timeRemaining')
                          : ('TIME REMAINING: $timeRemaining'),
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
                text1: widget.process!.headCount != null
                    ? '$numberSelected /${widget.process!.headCount} Workers'
                    : '$numberSelected /$totalUsersCount Workers',
                text2: 'Tap to Add or remove',
                showWarning: false,
                onTap: () {
                  Get.toNamed(Routes.editWorkers, arguments: {
                    "startTime": widget.selectedShift!.startTime!,
                    "processId": widget.processId,
                    "endTime": widget.selectedShift!.endTime!,
                    "userId": [],
                    "efficiencyCalculation": [],
                    "shiftId": widget.shiftId,
                    "totalUsersCount": widget.userId!.length,
                    "selectedShift": widget.selectedShift,
                    "process": widget.process,
                    "execShiftId": this.widget.execShiftId,
                  });
                  loadUsers();

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) => EditWorkers(
                  //       startTime: widget.selectedShift.startTime!,
                  //       processId: widget.processId,
                  //       endTime: widget.selectedShift.endTime!,
                  //       userId: [],
                  //       efficiencyCalculation: [],
                  //       shiftId: widget.shiftId,
                  //       totalUsersCount: widget.userId.length,
                  //       selectedShift: widget.selectedShift,
                  //       process: widget.process,
                  //       execShiftId: this.widget.execShiftId,
                  //     ),
                  //   ),
                  // );
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
                        "autoOpen": widget.autoOpen,
                        "startTime": widget.selectedShift!.startTime!,
                        "selectedShift": widget.selectedShift,
                        "shiftId": widget.shiftId,
                        "processId": widget.processId,
                        "endTime": widget.selectedShift!.endTime!,
                        "comments": '',
                        "process": widget.process,
                        "executeShiftId": executeShiftId!,
                      });
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => EndShiftFinalScreen(
                      //       autoOpen: widget.autoOpen,
                      //       startTime: widget.selectedShift.startTime!,
                      //       selectedShift: widget.selectedShift,
                      //       shiftId: widget.shiftId,
                      //       processId: widget.processId,
                      //       endTime: widget.selectedShift.endTime!,
                      //       comments: '',
                      //       process: widget.process,
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
