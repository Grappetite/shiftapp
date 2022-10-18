import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/screens/StartedShiftList.dart';
import 'package:shiftapp/screens/shift_start.dart';
import 'package:shiftapp/services/login_service.dart';

import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../services/shift_service.dart';
import '../services/workers_service.dart';
import 'edit_workers.dart';
import 'end_shift_final_screen.dart';
import 'inner_widgets/HandOverShift.dart';
import 'inner_widgets/coming_soon_container.dart';

class EndShiftView extends StatefulWidget {
  final bool startedBefore;
  final int shiftId;
  final int processId;
  final List<String> userId;
  final List<String> efficiencyCalculation;
  final ShiftItem selectedShift;
  final Process process;

  final bool autoOpen;

  final int execShiftId;

  const EndShiftView(
      {Key? key,
      required this.shiftId,
      required this.processId,
      required this.userId,
      required this.efficiencyCalculation,
      required this.selectedShift,
      this.startedBefore = false,
      required this.process,
      this.autoOpen = false,
      required this.execShiftId})
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
  double expectedUnits = 0;

  var stopper = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (widget.selectedShift.timeRemaining.contains('Over')) {
          timeRemaining =
              widget.selectedShift.timeRemaining.replaceAll('Over ', '');
          isTimeOver = true;
        } else {
          timeRemaining = widget.selectedShift.timeRemaining;
        }

        setState(() {
          timeElasped = widget.selectedShift.timeElasped;
          if (int.parse(timeElasped.split(":")[1].toString()) % 30 == 0 &&
              stopper == false) {
            stopper = true;
            loadExpectedUnits();
          } else if (int.parse(timeElasped.split(":")[1].toString()) % 30 !=
                  0 &&
              stopper == true) {
            stopper = false;
          }

          ///My Algorithm
          // if (WorkersService.prefs!.getString(widget.execShiftId.toString()) !=
          //     null) {
          //   ///worker*((baseline)/2)
          //   expectedEffeicency =
          //       WorkersService.prefs!.getString(widget.execShiftId.toString())!;
          //   WorkersService.prefs!.setString(
          //       widget.execShiftId.toString(),
          //       (double.parse(expectedEffeicency) +
          //               (numberSelected *
          //                   ((double.parse(widget.process.baseline!) / 2))))
          //           .toString());
          //   expectedEffeicency =
          //       WorkersService.prefs!.getString(widget.execShiftId.toString())!;
          // } else {
          //   WorkersService.prefs!
          //       .setString(widget.execShiftId.toString(), 0.toString());
          // }
        });

        // print(WorkersService.prefs!.getString(widget.execShiftId.toString())!);
      },
    );
  }

  void loadShiftId() async {
    this.executeShiftId = widget.execShiftId;
    loadUsers();
    loadExpectedUnits();
  }

  @override
  void initState() {
    super.initState();
    loadShiftId();

    appMenu02 = AppPopupMenu<int>(
      menuItems: [
        PopupMenuItem(
          value: 1,
          onTap: () async {
            await Future.delayed(Duration(seconds: 1), () async {
              var answer = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return HandOverShift(execShiftId: widget.execShiftId);
                  }).then((value) async {
                if (value) {
                  final prefs = await SharedPreferences.getInstance();
                  FlutterLocalNotificationsPlugin
                      flutterLocalNotificationsPlugin =
                      FlutterLocalNotificationsPlugin();
                  await flutterLocalNotificationsPlugin
                      .cancel(prefs.getInt("execute_shift_id")!);
                  prefs.remove('shiftId');
                  prefs.remove('selectedShiftName');
                  prefs.remove('selectedShiftEndTime');
                  prefs.remove('selectedShiftStartTime');
                  // prefs.remove('username');
                  prefs.remove('password');
                  // if (widget.autoOpen) {
                  //   Navigator.pop(context, true);
                  // } else {
                  //   Navigator.pop(context, true);
                  //   Navigator.pop(context, true);
                  // }
                  // var process = <Process>[];
                  // jsonDecode(prefs.getString("processesMahboob")!).forEach((v) {
                  //   process!.add(Process.fromJson(v));
                  // });
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder:
                              (context) => //   Navigator.pop(context, true);
                                  StartedShifts()
                          // HomeView(
                          //     processSelected: widget.process,
                          //     selectedShift: widget.selectedShift)
                          ),
                      (route) => false);
                }
              });
              // var process = await LoginService.getProcess();
              // final prefs = await SharedPreferences.getInstance();
              // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
              //     FlutterLocalNotificationsPlugin();
              // await flutterLocalNotificationsPlugin
              //     .cancel(prefs.getInt("execute_shift_id")!);
              // prefs.remove('shiftId');
              //
              // prefs.remove('selectedShiftName');
              // prefs.remove('selectedShiftEndTime');
              // prefs.remove('selectedShiftStartTime');
              // // prefs.remove('username');
              // prefs.remove('password');
              //
              // // if (widget.autoOpen) {
              // //   Navigator.pop(context, true);
              // // } else {
              // //   Navigator.pop(context, true);
              // //   Navigator.pop(context, true);
              // // }
              // // var process = <Process>[];
              // // jsonDecode(prefs.getString("processesMahboob")!).forEach((v) {
              // //   process!.add(Process.fromJson(v));
              // // });
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(
              //         builder: (context) => //   Navigator.pop(context, true);
              //             DropDownPage(process: process!)
              //         // HomeView(
              //         //     processSelected: widget.process,
              //         //     selectedShift: widget.selectedShift)
              //         ),
              //     (route) => false);
            });

            /// widget.onLogout();
          },
          child: const Text(
            'Transfer Shift',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () async {
            await Future.delayed(Duration(seconds: 1), () async {
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

              ShiftService.cancelShift(this.widget.execShiftId, endTime);
              var process = await LoginService.getProcess();
              final prefs = await SharedPreferences.getInstance();
              FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();
              await flutterLocalNotificationsPlugin
                  .cancel(prefs.getInt("execute_shift_id")!);
              prefs.remove('shiftId');

              prefs.remove('selectedShiftName');
              prefs.remove('selectedShiftEndTime');
              prefs.remove('selectedShiftStartTime');
              // prefs.remove('username');
              prefs.remove('password');

              // if (widget.autoOpen) {
              //   Navigator.pop(context, true);
              // } else {
              //   Navigator.pop(context, true);
              //   Navigator.pop(context, true);
              // }
              // var process = <Process>[];
              // jsonDecode(prefs.getString("processesMahboob")!).forEach((v) {
              //   process!.add(Process.fromJson(v));
              // });
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => //   Navigator.pop(context, true);
                          StartedShifts()
                      // HomeView(
                      //     processSelected: widget.process,
                      //     selectedShift: widget.selectedShift)
                      ),
                  (route) => false);
            });

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
      initialValue: 0,
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
    var responseShift =
        await WorkersService.getShiftWorkers(executeShiftId!, widget.processId);

    if (responseShift != null) {
      int count = responseShift.data!.shiftWorker!.length;

      if (count != 0) {
        responseShift.data!.worker = responseShift.data!.shiftWorker!
            .where((e) => e.isAdded == false)
            .toList();
        responseShift.data!.shiftWorker = responseShift.data!.shiftWorker!
            .where((e) => e.isAdded == true)
            .toList();
      }
    }
    numberSelected = responseShift!.data!.shiftWorker!.length;

    setState(() {
      totalUsersCount = responseShift.data!.shiftWorker!.length +
          responseShift.data!.worker!.length;
    });

    print('');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StartedShifts()));
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => StartedShifts()));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
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
                widget.process.name!,
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
          actions: [appMenu02],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TimerTopWidget(
                  selectedShift: widget.selectedShift,
                  timeElasped: timeElasped),
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
              ComingSoonContainer(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                innerWidget: ExplainerWidget(
                  comingSoon: true,
                  iconName: 'construct',
                  title: 'SOP REQUIRED',
                  text1: '4 Workers require SOP Training',
                  text2: 'Tap to train now or swipe to ignore',
                  showWarning: true,
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
                  text1: widget.process.headCount != null
                      ? '$numberSelected/${widget.process.headCount} Workers'
                      : '$numberSelected/$totalUsersCount Workers',
                  text2: 'Tap to Add or remove',
                  showWarning: false,
                  onTap: () async {
                    var response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => EditWorkers(
                          startTime: widget.selectedShift.startTime!,
                          processId: widget.processId,
                          endTime: widget.selectedShift.endTime!,
                          userId: [],
                          efficiencyCalculation: [],
                          shiftId: widget.shiftId,
                          totalUsersCount: widget.userId.length,
                          selectedShift: widget.selectedShift,
                          process: widget.process,
                          execShiftId: this.widget.execShiftId,
                        ),
                      ),
                    );

                    loadUsers();
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ComingSoonContainer(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                innerWidget: ExplainerWidget(
                  comingSoon: true,
                  iconName: 'exclamation',
                  title: 'INCIDENTS',
                  text1: '5',
                  text2: 'Tap to train now or swipe to ignore',
                  showWarning: false,
                  text1_2: '01:50:00',
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ExplainerWidget(
                  iconName: 'construct',
                  title: 'Expected ${widget.process.unit} Produced By Now',
                  text1: "${expectedUnits.toStringAsFixed(0)}",
                  text2: '',
                  showWarning: false,
                  onTap: () async {
                    // var response = await Navigator.push(
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
                    //
                    // loadUsers();
                  },
                ),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EndShiftFinalScreen(
                              autoOpen: widget.autoOpen,
                              startTime: widget.selectedShift.startTime!,
                              selectedShift: widget.selectedShift,
                              shiftId: widget.shiftId,
                              processId: widget.processId,
                              endTime: widget.selectedShift.endTime!,
                              process: widget.process,
                              executeShiftId: executeShiftId!,
                              expectedUnits: expectedUnits,
                            ),
                          ),
                        );
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
      ),
    );
  }

  void loadExpectedUnits() async {
    expectedUnits = 0;
    var shiftWorkerList =
        await WorkersService.getAllShiftWorkersList(executeShiftId!);
    for (var calculation in shiftWorkerList!.data!) {
      expectedUnits = expectedUnits +
          ((((calculation.actualTimeloggedout!
                              .difference(calculation.actualTimeloggedin!)
                              .inMinutes) >=
                          300
                      ? (calculation.actualTimeloggedout!
                              .difference(calculation.actualTimeloggedin!)
                              .inMinutes -
                          60)
                      : calculation.actualTimeloggedout!
                          .difference(calculation.actualTimeloggedin!)
                          .inMinutes) /
                  60) *
              (double.parse(widget.process.baseline!)));
    }
    setState(() {});
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
